#usr/bin/env bash

DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"
DIRECTORIO_SALIDA="${DIRECTORIO_RAIZ}/out/http"
mkdir -p "${DIRECTORIO_SALIDA}"

#Verificar codigo de estado
codigo_de_estado="$(curl -s -o /dev/null -w "%{http_code}" "${TARGETS}")"
if [ "${CODIGO_DE_ESTADO_ESPERADO}" == "${codigo_de_estado}" ]; then
    echo -e "Codigo de estado correcto: ${codigo_de_estado}\n" > "${DIRECTORIO_SALIDA}/reporte_http.txt"
else 
    echo -e "Codigo de estado incorrecto:\n\tEsperado:${CODIGO_DE_ESTADO_ESPERADO}\tRecibido:${codigo_de_estado}" > "${DIRECTORIO_SALIDA}/reporte_http.txt"
fi
#Incluye el tiempo de respuesta en el reporte
curl -s -o /dev/null -w "Tiempo de respuesta: %{time_total}s\n" "${TARGETS}">> "${DIRECTORIO_SALIDA}/reporte_http.txt" 
curl -sI "${TARGETS}" > "${DIRECTORIO_SALIDA}/cabeceras.txt" #Crea archivo con las cabeceras