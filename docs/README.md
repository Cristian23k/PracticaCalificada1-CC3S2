# Monitor de seguridad en redes con Bash (Proyecto 7)

**Objetivo:** Monitorear aspectos clave de HTTP, DNS y TLS mediante **scripts Bash** y herramientas de CLI (curl, dig, ss, nc), cumpliendo 12-Factor (I, III, V), Makefile con **caché incremental**, y pruebas con **Bats**.

## Estructura
- `src/` scripts Bash (robustos, con `set -euo pipefail`, `trap` y funciones).
- `tests/` suite Bats (HTTP/DNS/TLS/redes/robustez/idempotencia).
- `systemd/` unidad mínima cuando aplique.
- `docs/` documentación, bitácoras y guion de videos.
- `out/` evidencias reproducibles (trazas y reportes).
- `dist/` paquete reproducible por `make pack`.

## Variables de entorno (contrato)
| Variable     | Ejemplo                                  | Efecto observable |
|--------------|-------------------------------------------|-------------------|
| `TARGETS`    | `example.com:80,example.com:443`          | Objetivos a monitorear (host:puerto). |
| `PORT`       | `443`                                     | Puerto por defecto si un target no lo define. |
| `DNS_SERVER` | `1.1.1.1`                                 | Servidor DNS a consultar en `dig`. |
| `TIMEOUT`    | `5`                                       | Timeout para `curl`/`dig`. |
| `RETRIES`    | `2`                                       | Reintentos ante errores transitorios. |
| `RELEASE`    | `v1.0.0`                                  | Nombre del paquete en `make pack`. |
| `LOG_LEVEL`  | `INFO`                                    | Verbosidad de logging (`DEBUG/INFO/WARN/ERROR`). |
| `CONFIG_URL` | `https://ejemplo/targets.txt`             | Lista remota opcional de objetivos (CSV `host:port`). |

> **Regla:** no cambiar scripts para alterar comportamiento: **todo** se parametriza por entorno.

## Uso rápido
```bash
make help
make tools
TARGETS="example.com:80,example.com:443" DNS_SERVER=1.1.1.1 make build
TARGETS="example.com:80,example.com:443" DNS_SERVER=1.1.1.1 make run
make test
RELEASE=v1.0.0 make pack
```

## Códigos de salida (utils.sh)
- `10` configuración inválida (ej. `TARGETS` vacío)
- `20` error de red/HTTP
- `30` error DNS
- `50` análisis TLS fallido
- `90` error interno (bash)

Consulta `docs/contrato-salidas.md` para la validación de artefactos.