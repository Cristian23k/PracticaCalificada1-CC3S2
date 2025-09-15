#!/usr/bin/env bats

DIRECTORIO_RAIZ="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
load ${DIRECTORIO_RAIZ}/tests/test_helpers.bash
@test "Comprobando ejecucion correcta del script y creacion de archivos" {
    run ${DIRECTORIO_RAIZ}/src/tls_check.sh
    [ "$status" -eq 0 ]
    [ -f "${DIRECTORIO_RAIZ}/out/tls/info_tls.txt" ]
    [ -f "${DIRECTORIO_RAIZ}/out/tls/reporte.txt" ]
    [ -f "${DIRECTORIO_RAIZ}/out/tls/cert1.txt" ]
}
#Matriz minima de casos
#tls_check usa 2 entradas targets y port ,pueden ser correcta o incorrecta
#La matriz minima de casos contiene 4 casos
@test "Probando con 2 entradas correctas" {
    run env TARGETS=facebook.com PORT=443 ${DIRECTORIO_RAIZ}/src/tls_check.sh
    [ "$status" -eq 0 ]
    #Comprobar la conexion cliente servidor
    run grep -q "Verification: OK" "${DIRECTORIO_RAIZ}/out/tls/reporte.txt"
    [ "$status" -eq 0 ]   
}
@test "Probando con target incorrecto" {
    run env TARGETS=estedominionoexiste.xyz PORT=443 ${DIRECTORIO_RAIZ}/src/tls_check.sh
    [ "$status" -eq 50 ]  
}
@test "Probando con puerto incorrecto" {
    run env TARGETS=youtube.com PORT=4433 ${DIRECTORIO_RAIZ}/src/tls_check.sh
    [ "$status" -eq 50 ]  
}