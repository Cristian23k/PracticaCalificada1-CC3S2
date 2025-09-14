#!/usr/bin/env bash
set -euo pipefail
trap error ERR #En caso de que ocurra un error se informa y se limpian directorios

DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"
DIRECTORIO_SALIDA="${DIRECTORIO_RAIZ}/out/http"
mkdir -p "${DIRECTORIO_SALIDA}"
error() {
    echo "Ha ocurrido un error en src/http_check.sh"
    rm -rf "${DIRECTORIO_SALIDA}"
}

#Verificar codigo de estado
codigo_de_estado="$(curl -s -o /dev/null -w "%{http_code}" "${TARGETS}")"
if [ "${CODIGO_DE_ESTADO_ESPERADO}" == "${codigo_de_estado}" ]; then
    echo -e "Codigo de estado correcto: ${codigo_de_estado}\n" > "${DIRECTORIO_SALIDA}/reporte_http.txt"
else 
    echo -e "Codigo de estado incorrecto:\n\tEsperado:${CODIGO_DE_ESTADO_ESPERADO}\tRecibido:${codigo_de_estado}" > "${DIRECTORIO_SALIDA}/reporte_http.txt"
fi
#Incluye el tiempo de respuesta en el reporte y envía el cuerpo a out/cuerpo_http.txt
curl -s -o "${DIRECTORIO_SALIDA}/cuerpo_http.txt" -w "Tiempo de respuesta: tcp_connect=%{time_connect}s tls=%{time_appconnect}s ttfb=%{time_starttransfer}s total=%{time_total}s\n" "${TARGETS}" >> "${DIRECTORIO_SALIDA}/reporte_http.txt" 
curl -sI "${TARGETS}" > "${DIRECTORIO_SALIDA}/cabeceras.txt" #Crea archivo con las cabeceras
grep "Content-Length" "${DIRECTORIO_SALIDA}/cabeceras.txt" | sed "s/Content-Length/Tamano de la respuesta/" >> "${DIRECTORIO_SALIDA}/reporte_http.txt"