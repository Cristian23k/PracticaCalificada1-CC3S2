#!/usr/bin/env bats

DIRECTORIO_RAIZ="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
load ${DIRECTORIO_RAIZ}/tests/test_helpers.bash
@test "Comprobando ejecucion correcta del script y creacion de archivos" {
    bash ${DIRECTORIO_RAIZ}/src/dns_check.sh
    [ -f "${DIRECTORIO_RAIZ}/out/dns/salida_dig.txt" ]

}