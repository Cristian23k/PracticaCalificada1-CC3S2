#usr/bin/env bash

DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"
DIRECTORIO_SALIDA="${DIRECTORIO_RAIZ}/out/http"
mkdir -p "${DIRECTORIO_SALIDA}"

curl -sI "${TARGETS}" > "${DIRECTORIO_SALIDA}/cabeceras.txt" #Crea archivo con las cabeceras