SHELL := /usr/bin/env bash

SRC_DIR := src
TEST_DIR := tests
OUT_DIR := out
DIST_DIR := dist

.PHONY: tools build run clean help

all: tools build run

tools: ## Verifica disponibilidad de utilidades
	@echo "Verificando disponibilidad de utilidades ..."
	@command -v curl >/dev/null || { echo "Falta curl"; exit 1; }
	@command -v dig >/dev/null || { echo "Falta dig"; exit 1; }
	@echo "Verificaciones exitosas"

build: ## Prepara artefactos intermedios
	@mkdir -p "$(OUT_DIR)/http"
	@mkdir -p "$(OUT_DIR)/http"

run: ## Ejecuta el flujo principal
	@echo "Ejecutando flujo principal"
	@bash src/monitor.sh

clean: ## Limpiar archivos generados
	@echo "Eliminando directorios out y dist ..."
	@rm -rf $(OUT_DIR) $(DIST_DIR)
	@echo "Directorios limpios"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) | awk -F':|##' '{printf "  %-12s %s\n", $$1, $$3}'

