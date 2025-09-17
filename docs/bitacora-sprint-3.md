# Bitácora Sprint 3

## Objetivo del sprint
- Caché incremental, no volver a crear archivos si sus dependencias no han cambiado.
- Creación de paquete reproducible en dist.

## Comandos ejecutados (con explicación)
`tar` sirve para empaquetar, comprimir y descomprimir archivos.
`stat` sirve para obtener información detallada sobre un archivo, lo usamos para comparar la fecha de modificación.
`run` se usa en bats para ejecutar comandos y almacenar código de estado y la salida en variables, útiles en las pruebas.
```bash
# ejemplo
run ${DIRECTORIO_RAIZ}/src/http_check.sh # Ejecuta el script y guarda codigo de estado y stdout/stderr
stat -c %Y "${DIRECTORIO_RAIZ}/dist/http_check.tar.gz" # Devuelve la fecha de última modificación, número de segundos desde 1 de enero de 1970
tar --sort=name --owner=0 --group=0 --numeric-owner --mtime='UTC 1970-01-01' -czf $@ -C $(OUT_DIR) http
# Empaqueta el directorio http, las flags sirven para reproducibilidad, se ordenan los archivos por nombre, se asigna usuario y grupo a root(UID y GID)
# establece la fecha de última modificación
```
## Evidencias (salidas recortadas y comentadas)

En el makefile se generó la dependencia del empaquetado http_check.tar.gz, depende de los archivos en out/http, estos dependen del script http_check.sh.
Si estos no se modifican, el makefile no vuelve a ejecutar todo el proceso, conserva el empaquetado, a pesar de volver a ejecutar make run-auto.
```make
$(HTTP_DIR)/cabeceras.txt $(HTTP_DIR)/cuerpo_http.txt $(HTTP_DIR)/reporte_http.txt &: $(SRC_DIR)/http_check.sh
	@bash $<
#Empaquetado reproducible
pack: $(DIST_DIR)/dns_check.tar.gz $(DIST_DIR)/tls_check.tar.gz $(DIST_DIR)/http_check.tar.gz ## Genera paquetes reproducibles en dist

$(DIST_DIR)/http_check.tar.gz: $(HTTP_FILES)
	@tar --sort=name --owner=0 --group=0 --numeric-owner --mtime='UTC 1970-01-01' -czf $@ -C $(OUT_DIR) http

$(DIST_DIR)/dns_check.tar.gz: build tools dns_check
	@tar --sort=name --owner=0 --group=0 --numeric-owner --mtime='UTC 1970-01-01' -czf $@ -C $(OUT_DIR) dns

$(DIST_DIR)/tls_check.tar.gz: build tools tls_check
	@tar --sort=name --owner=0 --group=0 --numeric-owner --mtime='UTC 1970-01-01' -czf $@ -C $(OUT_DIR) tls
```
Se agregó una prueba en http_tests.bats para comprobar automáticamente esta característica.
```bash
@test "Prueba de idempotencia en el Makefile" {
    run make run-auto
    [ "$status" -eq 0 ]
    [ -f "${DIRECTORIO_RAIZ}/dist/http_check.tar.gz" ]
    t1=$(stat -c %Y "${DIRECTORIO_RAIZ}/dist/http_check.tar.gz")
    sleep 2
    run make run-auto
    [ "$status" -eq 0 ]
    [ -f "${DIRECTORIO_RAIZ}/dist/http_check.tar.gz" ]
    t2=$(stat -c %Y "${DIRECTORIO_RAIZ}/dist/http_check.tar.gz")
    [ "$t1" -eq "$t2" ]
}
```
Resumidamente, se ejecuta make run-auto, se crean los empaquetados, se guarda en una variable la fecha de última modificación del empaquetado. Se esperan 2 segundos y se repite el proceso, almacenando la segunda fecha en otra variable, finalmente se compara el valor de estas variables, si coinciden significa que el archivo no ha cambiado, a pesar de volver a ejecutar make run-auto.