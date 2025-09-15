
DIRECTORIO_RAIZ="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"

#Funciones que se ejecutan en cada prueba
setup() {   #Antes de la prueba
    rm -rf ${DIRECTORIO_RAIZ}/out/
}
teardown() {   #Despues de la prueba
    rm -rf ${DIRECTORIO_RAIZ}/out/
}