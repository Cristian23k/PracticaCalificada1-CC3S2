#!/usr/bin/env bats

DIRECTORIO_RAIZ="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
load ${DIRECTORIO_RAIZ}/tests/test_helpers.bash
@test "Comprobando ejecucion correcta del script y creacion de archivos" {
    run ${DIRECTORIO_RAIZ}/src/http_check.sh
    [ "$status" -eq 0 ]
    [ -f "${DIRECTORIO_RAIZ}/out/http/cabeceras.txt" ]
    [ -f "${DIRECTORIO_RAIZ}/out/http/cuerpo_http.txt" ]
    [ -f "${DIRECTORIO_RAIZ}/out/http/reporte_http.txt" ]
}
#Matriz minima de casos
#http_check usa 1 entrada TARGET ,puede ser correcta o incorrecta
#La matriz minima de casos contiene 2 casos
@test "Probando con target incorrecto" {
    run env TARGETS=estedominionoexiste.xyz ${DIRECTORIO_RAIZ}/src/http_check.sh
    [ "$status" -eq 20 ]  
}