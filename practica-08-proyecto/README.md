# Práctica 8 — Proyecto integrador

> **Manual:** Módulo 8, secciones 2.8.1 a 2.8.5 · Capítulo 3.3
>
> Primero realiza el procedimiento del manual escribiendo tú los comandos; después usa estos recursos para comprobar tu resultado.

| Archivo | Para qué |
|---|---|
| `stack.yml` | Stack WordPress + MariaDB con volúmenes NFS; la variable `GRUPO` elige la carpeta del NAS. |
| `desplegar.sh` | Crea las carpetas en el NAS, despliega el stack y escala la web a 3 réplicas. |
| `pruebas.sh` | Ejecuta las 5 pruebas de la sección 2.8.3 y genera un CSV para la documentación. |
| `DOCUMENTACION_PLANTILLA.md` | Estructura de la documentación técnica que se entrega. |

```bash
bash desplegar.sh a
bash pruebas.sh a          # con autorización del instructor
```

Despliegue manual equivalente: `GRUPO=grupo-b docker stack deploy -c stack.yml sitio`.
Para retirar el proyecto: `docker stack rm sitio` (los datos permanecen en el NAS).

| Criterio | Peso |
|---|---|
| Funcionamiento | 30 % |
| Tolerancia a fallos | 25 % |
| Persistencia | 15 % |
| Documentación | 20 % |
| Presentación | 10 % |

## Evidencia para el portafolio

- [ ] `stack.yml` completo y comentado.
- [ ] CSV de `pruebas.sh` con las 5 pruebas y capturas.
- [ ] Documentación técnica a partir de `DOCUMENTACION_PLANTILLA.md`.
- [ ] Presentación de 5 a 10 minutos con demostración en vivo.
