# Práctica 5 — WordPress con MariaDB en Docker Compose

> **Manual:** Módulo 5, sección 2.5.7 — Práctica 5 · Compose en 2.5.6
>
> Primero realiza el procedimiento del manual escribiendo tú los comandos; después usa estos recursos para comprobar tu resultado.

| Archivo | Para qué |
|---|---|
| `compose.yaml` | Aplicación de la práctica, comentada. |
| `verificar_docker.sh` | Verifica Docker, valida el YAML, levanta la app y prueba la persistencia. |
| `ejercicio_error.yaml` | El "Analiza el error" del módulo, para corregirlo y validarlo. |

```bash
scp -r practica-05-docker comun cluster@192.168.20.11:~/
ssh cluster@192.168.20.11
cd ~/practica-05-docker && bash verificar_docker.sh
```

Valida tu corrección del ejercicio con `docker compose -f ejercicio_error.yaml config`.
Al terminar: `docker compose down` (agrega `-v` solo si quieres borrar también los datos).

## Evidencia para el portafolio

- [ ] Archivo `compose.yaml` funcional.
- [ ] Captura de `docker compose ps` con ambos servicios en *running*.
- [ ] Captura de la entrada de prueba antes y después de `down`/`up`.
- [ ] Corrección del YAML del *Analiza el error*.
