#usr/bin/env bash

DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"
DIRECTORIO_SALIDA="${DIRECTORIO_RAIZ}/out/dns"
mkdir -p "${DIRECTORIO_SALIDA}"

#Consulta el dominio al servidor dns definido
dig "@${DNS_SERVER}" "${TARGETS}" > "${DIRECTORIO_SALIDA}/salida_dig.txt"