#!/usr/bin/env bash

DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"
DIRECTORIO_SALIDA="${DIRECTORIO_RAIZ}/out/tls"
mkdir -p "${DIRECTORIO_SALIDA}"

#Mostrar informacion sobre la conexion y la cadena de certificados
openssl s_client -connect "${TARGETS}:${PORT}" -showcerts > "${DIRECTORIO_SALIDA}/info_tls.txt"
