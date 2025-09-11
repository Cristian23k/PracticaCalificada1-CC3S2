#!/usr/bin/env bash

DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"

echo "Iniciando monitor de seguridad..."
echo "Target: ${TARGETS} Puerto: ${PORT} Servidor DNS: ${DNS_SERVER}"
#HTTP
echo "Ejecutando http_check.sh ..."
if bash ${DIRECTORIO_RAIZ}/src/http_check.sh; then
    echo "Se ejecutó el script correctamente"
else
    echo "Error al ejecutar el script"
    exit 1
fi
echo "REPORTE:"
cat "${DIRECTORIO_RAIZ}/out/http/reporte_http.txt"
sleep 2
echo "Cabeceras:"
cat "${DIRECTORIO_RAIZ}/out/http/cabeceras.txt"
sleep 2
echo "Cuerpo:"
cat "${DIRECTORIO_RAIZ}/out/http/cuerpo_http.txt"
#DNS
echo "Ejecutando dns_check.sh ..."
if bash ${DIRECTORIO_RAIZ}/src/dns_check.sh; then
    echo "Se ejecutó el script correctamente"
else
    echo "Error al ejecutar el script"
    exit 1
fi
echo "REPORTE:"
sleep 2
cat "${DIRECTORIO_RAIZ}/out/dns/salida_dig.txt"
#TLS
echo "Ejecutando tls_check.sh ..."
if bash ${DIRECTORIO_RAIZ}/src/tls_check.sh; then
    echo "Se ejecutó el script correctamente"
else
    echo "Error al ejecutar el script"
    exit 1
fi
echo "REPORTE:"
sleep 2
cat "${DIRECTORIO_RAIZ}/out/tls/info_tls.txt"