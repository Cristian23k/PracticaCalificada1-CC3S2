# Contrato de salidas

## Archivos generados
- `out/http/cabeceras.txt` → cabeceras HTTP (curl -I).
- `out/http/cuerpo_http.txt` → cuerpo de la respuesta.
- `out/http/reporte_http.txt` → `status_code content_length time_total` 
- `out/dns/salida_dig.txt` → registros A/CNAME + TTL y servidor usado.
- `out/dns/reporte_dns.txt` → registros A/CNAME + TTL y servidor usado.
- `out/tls/info_tls.txt` → salida de openssl, cadena de certificados, autenticación y estado de la sesión.
- `out/tls/reporte.txt` → salida con formato.
- `out/tls/cert*.txt` → certificado digital.


## Validación mínima
- Cada archivo tiene timestamp consistente y **no se reescribe** si no cambian dependencias (caché incremental).
- Repetir `make run` sin cambios **no rehace** artefactos (idempotencia observable por timestamps).