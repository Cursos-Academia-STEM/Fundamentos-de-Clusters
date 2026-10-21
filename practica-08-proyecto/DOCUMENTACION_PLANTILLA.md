# Proyecto integrador — Grupo ___

**Integrantes:**
**Fecha:**

## 1. Objetivo y problema que resuelve

## 2. Arquitectura

- Diagrama del cluster del grupo (nodos, switch, router, NAS).
- Diagrama del servicio desplegado (servicios, réplicas, volúmenes, puerto publicado).

| Servicio | Imagen | Réplicas | Datos persistentes |
|---|---|---|---|
| web | wordpress:latest | 3 | cluster-data/grupo-_/wp |
| db | mariadb:11 | 1 | cluster-data/grupo-_/db |

## 3. Red

- Plan de direccionamiento (adjuntar `plan_direccionamiento.csv`).
- Reglas UFW activas (`sudo ufw status verbose`).

## 4. Almacenamiento compartido

- Ruta NFS, regla de permisos y línea de `/etc/fstab`.

## 5. Archivo `stack.yml`

Adjunta tu `stack.yml` completo y comentado.

## 6. Pruebas

Adjunta el CSV generado por `pruebas.sh` y capturas.

| Prueba | Acción | Resultado esperado | Resultado observado |
|---|---|---|---|
| Acceso por cualquier nodo | | El sitio responde en ambas IP | |
| Escalamiento | `scale sitio_web=4` | Réplicas distribuidas | |
| Falla de un nodo web | `shutdown` de un worker | El sitio sigue respondiendo | |
| Falla del nodo de la BD | `shutdown` del nodo de `sitio_db` | Las entradas se conservan | |
| Recuperación | `update --force sitio_web` | Réplicas redistribuidas | |

## 7. Problemas encontrados y solución

| Problema | Causa | Solución |
|---|---|---|

## 8. Conclusiones y mejoras propuestas
