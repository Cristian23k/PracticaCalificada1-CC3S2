#!/usr/bin/env bash
set -euo pipefail

trap limpieza EXIT #Se ejecuta la funcion limpieza siempre que se sale del programa
DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"

limpieza() {
    echo "Saliendo ..."
    rm -rf "${DIRECTORIO_RAIZ}/out"
}
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
            exit 0
            ;;
        *)
            echo "Opcion invalida"
            ;;
    esac
}
tls_check() {
    clear
    echo "Ejecutando tls_check.sh ..."
    if bash ${DIRECTORIO_RAIZ}/src/tls_check.sh; then
        echo "Se ejecutó el script correctamente"
    else
        echo "Error al ejecutar el script"
        exit 1
    fi
    echo "REPORTE:"
    cat "${DIRECTORIO_RAIZ}/out/tls/reporte.txt"
    while true
    do
        echo -e "\n1)Mostrar certificado\t2)Volver al menu"
        read opcion
        if [ "$opcion" -eq 1 ]; then
            echo "Ingrese una opcion(0,1..):"
            read op
            ((op+=1))
            if ! cat "${DIRECTORIO_RAIZ}/out/tls/cert${op}.txt" 2>/dev/null; then
                echo "opcion invalida"
            fi
        else
            clear
            return 0
        fi
    done
}
http_check() {
    clear
    echo "Ejecutando http_check.sh ..."
    if bash ${DIRECTORIO_RAIZ}/src/http_check.sh; then
        echo "Se ejecutó el script correctamente"
    else
        echo "Error al ejecutar el script"
        exit 1
    fi
    echo "REPORTE:"
    cat "${DIRECTORIO_RAIZ}/out/http/reporte_http.txt" 
    while true
    do
        echo -e "Mostrar\n1)Cabeceras\t2)Cuerpo\t3)Volver al menu"
        read opcion
        if [ "$opcion" -eq 1 ]; then
            echo "Cabeceras:"
            cat "${DIRECTORIO_RAIZ}/out/http/cabeceras.txt"
        elif [ "$opcion" -eq 2 ]; then
            echo "Cuerpo:"
            cat "${DIRECTORIO_RAIZ}/out/http/cuerpo_http.txt"
        else
            clear
            return 0
        fi
    done    
}
dns_check() {
    clear
    echo "Ejecutando dns_check.sh ..."
    if bash ${DIRECTORIO_RAIZ}/src/dns_check.sh; then
        echo "Se ejecutó el script correctamente"
    else
        echo "Error al ejecutar el script"
        exit 1
    fi
    echo "REPORTE:"
    cat "${DIRECTORIO_RAIZ}/out/dns/reporte_dns.txt"
}
echo "MONITOR DE SEGURIDAD EN REDES"
nc -vz "${TARGETS}" "${PORT}"
while true
do 
    menu
done

