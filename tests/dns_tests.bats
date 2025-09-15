#!/usr/bin/env bats

DIRECTORIO_RAIZ="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
load ${DIRECTORIO_RAIZ}/tests/test_helpers.bash
@test "Comprobando ejecucion correcta del script y creacion de archivos" {
    run ${DIRECTORIO_RAIZ}/src/dns_check.sh
    [ "$status" -eq 0 ]
    [ -f "${DIRECTORIO_RAIZ}/out/dns/salida_dig.txt" ]

}
#Matriz minima de casos
#dns_check usa 2 entradas TARGET y DNS_SERVER, ambas pueden ser correcta o incorrecta
#La matriz minima de casos contiene 4 combinaciones
@test "Probando con 2 entradas correctas" {
    run env TARGETS=facebook.com DNS_SERVER=9.9.9.9 ${DIRECTORIO_RAIZ}/src/dns_check.sh
    [ "$status" -eq 0 ]
    #Comprobar resolucion A y/o -CNAME
    grep -Eq '\sIN\s+A\s' "${DIRECTORIO_RAIZ}/out/dns/reporte_dns.txt" || grep -Eq '\sIN\s+CNAME\s' "${DIRECTORIO_RAIZ}/out/dns/reporte_dns.txt"   
}
@test "Probando con target incorrecto" {
    run env TARGETS=estedominionoexiste.xyz ${DIRECTORIO_RAIZ}/src/dns_check.sh
    [ "$status" -eq 30 ]  
}
@test "Probando con dns server incorrecto" {
    run env DNS_SERVER=127.0.0.1 ${DIRECTORIO_RAIZ}/src/dns_check.sh
    [ "$status" -eq 30 ]  
}
