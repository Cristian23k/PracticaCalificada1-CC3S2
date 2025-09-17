SHELL := /usr/bin/env bash

MAKEFLAGS += --warn-undefined-variables --no-builtin-rules
.DELETE_ON_ERROR:
.DEFAULT_GOAL := help
export LC_ALL := C
export LANG   := C
export TZ     := UTC

SRC_DIR := src
TEST_DIR := tests
OUT_DIR := out
DIST_DIR := dist
HTTP_DIR := out/http
HTTP_FILES  := $(HTTP_DIR)/cabeceras.txt $(HTTP_DIR)/cuerpo_http.txt $(HTTP_DIR)/reporte_http.txt

.PHONY: tools build run clean help dns_check tls_check pack run-auto

all: tools build run

tools: ## Verifica disponibilidad de utilidades
	@echo "Verificando disponibilidad de utilidades ..."
	@command -v bats >/dev/null || { echo "Falta bats"; exit 1; }
	@command -v curl >/dev/null || { echo "Falta curl"; exit 1; }
	@command -v dig >/dev/null || { echo "Falta dig"; exit 1; }
	@command -v openssl >/dev/null || { echo "Falta openssl"; exit 1; }
	@command -v grep >/dev/null || { echo "Falta dig"; exit 1; }
	@command -v sed >/dev/null || { echo "Falta dig"; exit 1; }
	@command -v awk >/dev/null || { echo "Falta dig"; exit 1; }
	@command -v tar >/dev/null || { echo "Falta tar"; exit 1; }
	@tar --version 2>/dev/null | grep -q 'GNU tar' || { echo "Se requiere GNU tar"; exit 1; }
	@echo "Verificaciones exitosas"

build: ## Prepara artefactos intermedios
	@mkdir -p "$(OUT_DIR)/http"
	@mkdir -p "$(OUT_DIR)/dns"
	@mkdir -p "$(OUT_DIR)/tls"
	@mkdir -p "$(DIST_DIR)"

run: ## Ejecuta el flujo principal
	@echo "Ejecutando flujo principal"
	@bash src/monitor.sh

$(HTTP_DIR)/cabeceras.txt $(HTTP_DIR)/cuerpo_http.txt $(HTTP_DIR)/reporte_http.txt &: $(SRC_DIR)/http_check.sh
	@bash $<

dns_check:
	@bash src/dns_check.sh

tls_check:
	@bash src/tls_check.sh

run-auto: tools build pack ## Crea todas las salidas intermedias de forma automatica
	@echo "Ejecutando de forma automatica"

#Empaquetado reproducible
pack: $(DIST_DIR)/dns_check.tar.gz $(DIST_DIR)/tls_check.tar.gz $(DIST_DIR)/http_check.tar.gz ## Genera paquetes reproducibles en dist

$(DIST_DIR)/http_check.tar.gz: $(HTTP_FILES)
	@tar --sort=name --owner=0 --group=0 --numeric-owner --mtime='UTC 1970-01-01' -czf $@ -C $(OUT_DIR) http

$(DIST_DIR)/dns_check.tar.gz: build tools dns_check
	@tar --sort=name --owner=0 --group=0 --numeric-owner --mtime='UTC 1970-01-01' -czf $@ -C $(OUT_DIR) dns

$(DIST_DIR)/tls_check.tar.gz: build tools tls_check
	@tar --sort=name --owner=0 --group=0 --numeric-owner --mtime='UTC 1970-01-01' -czf $@ -C $(OUT_DIR) tls

clean: ## Limpiar archivos generados
	@echo "Eliminando directorios out y dist ..."
	@rm -rf $(OUT_DIR) $(DIST_DIR)
	@echo "Directorios limpios"

test: ## Pruebas unitarias
	@echo "Realizando pruebas ..."
	@bats tests

help: ## Mostrar ayuda
	@echo -e "Uso: make <target>\nTargets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) | awk -F':|##' '{printf "  %-12s %s\n", $$1, $$3}'


