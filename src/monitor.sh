#!/usr/bin/env bash

DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"

menu() {
    echo "Target: ${TARGETS} Puerto: ${PORT} Servidor DNS: ${DNS_SERVER}"
    echo "Ingrese un digito"
    echo -e "1)http_check\t2)dns_check\t3)tls_check\t4)salir"
    read opcion
    case ${opcion} in
        1)
            http_check
            ;;
        2)
            dns_check
            ;;
        3)
            tls_check
            ;;
        4)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opcion invalida"
            ;;
    esac
}
tls_check() {
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
}
http_check() {
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
}
dns_check() {
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
}
echo "MONITOR DE SEGURIDAD EN REDES"
while true
do 
    menu
done

