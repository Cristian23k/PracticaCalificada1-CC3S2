# Monitor de seguridad en redes con Bash (Proyecto 7)

**Objetivo:** Monitorear aspectos clave de HTTP, DNS y TLS mediante **scripts Bash** y herramientas de CLI (curl, dig, ss, nc), cumpliendo 12-Factor , Makefile con **caché incremental**, y pruebas con **Bats**.

## Estructura
- `src/` scripts Bash (robustos, con `set -euo pipefail`, `trap` y funciones).
- `tests/` suite Bats (HTTP/DNS/TLS/robustez/idempotencia).
- `systemd/` unidad mínima cuando aplique.
- `docs/` documentación, bitácoras y guion de videos.
- `out/` evidencias reproducibles (trazas y reportes).
- `dist/` paquete reproducible por `make pack`.

## Variables de entorno (contrato)
| Variable     | Ejemplo                                  | Efecto observable |
|--------------|-------------------------------------------|-------------------|
| `TARGETS`    | `example.com`          | Objetivos a monitorear. |
| `PORT`       | `443`                                     | Puerto por defecto si un target no lo define. |
| `DNS_SERVER` | `1.1.1.1`                                 | Servidor DNS a consultar en `dig`. |
| `RELEASE`    | `v1.0`                                  | Nombre del paquete en `make pack`. |
| `CODIGO_DE_ESTADO_ESPERADO`    | `200`                                  | Código que se espera recibir |

> **Regla:** no cambiar scripts para alterar comportamiento: **todo** se parametriza por entorno.

## Uso rápido
```bash
make help
make tools
TARGETS="example.com" DNS_SERVER=1.1.1.1 
make build
make run
make test
RELEASE=v1.0 
make pack
```

## Códigos de salida 
- `20` error de red/HTTP
- `30` error DNS
- `50` análisis TLS fallido
