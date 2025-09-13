#!/usr/bin/env bash
set -euo pipefail
trap error ERR #En caso de que ocurra un error se informa y se limpian directorios

DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"
DIRECTORIO_SALIDA="${DIRECTORIO_RAIZ}/out/dns"
mkdir -p "${DIRECTORIO_SALIDA}"

error() {
    echo "Ha ocurrido un error en src/dns_check.sh"
    rm -rf "${DIRECTORIO_SALIDA}"
}
#Consulta el dominio al servidor dns definido
dig "@${DNS_SERVER}" "${TARGETS}" > "${DIRECTORIO_SALIDA}/salida_dig.txt"
#Creando reporte
tail -n 6 "${DIRECTORIO_SALIDA}/salida_dig.txt" |  sed -e 's/Query time/Tiempo de consulta/; s/SERVER/Servidor/; s/WHEN/Fecha/; s/MSG SIZE  rcvd/Tamano del mensaje recibido/' > "${DIRECTORIO_SALIDA}/reporte_dns.txt"
echo -e "RESPUESTAS:\n\t\t\tTTL    CLASE   TIPO\t DIRECCION\n\t\t\t       DE LA   DE  \t          \n\t\t\t     CONSULTA  REGISTRO" >> "${DIRECTORIO_SALIDA}/reporte_dns.txt"
#Extrayendo respuestas y dando formato
awk '/ANSWER SECTION/,/^$/' "${DIRECTORIO_SALIDA}/salida_dig.txt" | tail -n +2 >> "${DIRECTORIO_SALIDA}/reporte_dns.txt"