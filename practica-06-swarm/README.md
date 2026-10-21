# Práctica 6 — El cluster en acción

> **Manual:** Módulo 6, sección 2.6.7 — Práctica 6 · Guía de referencia 2.6.3
>
> Primero realiza el procedimiento del manual escribiendo tú los comandos; después usa estos recursos para comprobar tu resultado.

Todos los scripts se ejecutan en el **maestro de tu grupo** (`pi-a-master` o `pi-b-master`).

| Archivo | Para qué |
|---|---|
| `verificar_swarm.sh` | Comprueba 4 nodos Ready, sin nodos del otro grupo, y el aislamiento. |
| `balanceo.sh` | Crea `quien` (traefik/whoami), lo escala a 6 y muestra qué réplica responde. |
| `prueba_falla.sh` | Prueba de falla guiada con cronómetro y bitácora automática. |
| `formar_swarm.sh` | **Guía de referencia**: forma un swarm nuevo. No usar en el laboratorio. |

```bash
bash verificar_swarm.sh a
bash balanceo.sh a
bash prueba_falla.sh a pi-a-02     # con autorización del instructor
```

## Evidencia para el portafolio

- [ ] Captura de `docker node ls` con 1 manager y 3 workers de tu grupo.
- [ ] Prueba de aislamiento hacia el otro grupo.
- [ ] Evidencia del balanceo (salida de `curl` con distintos *Hostname*).
- [ ] Bitácora de la prueba de falla con tiempos (`bitacora_falla_*.txt`).
