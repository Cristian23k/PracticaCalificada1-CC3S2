#!/usr/bin/env bats

DIRECTORIO_RAIZ="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
load ${DIRECTORIO_RAIZ}/tests/test_helpers.bash
@test "Comprobando ejecucion correcta del script y creacion de archivos" {
    bash ${DIRECTORIO_RAIZ}/src/http_check.sh
    [ -f "${DIRECTORIO_RAIZ}/out/http/cabeceras.txt" ]
    [ -f "${DIRECTORIO_RAIZ}/out/http/cuerpo_http.txt" ]
    [ -f "${DIRECTORIO_RAIZ}/out/http/reporte_http.txt" ]
}
