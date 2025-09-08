# Contrato de salidas

## Archivos generados
- `out/http/<host>_<port>.hdr` → cabeceras HTTP crudas (curl -i / -D -).
- `out/http/<host>_<port>.body` → cuerpo de la respuesta.
- `out/http/<host>_<port>.meta` → `status_code content_type time_total` (una línea).
- `out/dns/<host>.txt` → registros A/CNAME + TTL y servidor usado.
- `out/tls/<host>_<port>.trace` → traza de `curl -v` u `openssl s_client` (solo análisis).
- `out/sockets/<host>_<port>.check` → resultado de `nc -z`/`ss` (reachability/estado).
- `out/report/summary.csv` → consolidado resumido por objetivo (si existe).

## Validación mínima
- Cada archivo tiene timestamp consistente y **no se reescribe** si no cambian dependencias (caché incremental).
- Repetir `make run` sin cambios **no rehace** artefactos (idempotencia observable por timestamps).
- Los códigos de salida se registran en `out/last_exit_code.txt`.