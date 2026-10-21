# Retos de integración (capítulo 3.2)

Opcionales. Todos se ejecutan en el maestro del grupo y usan la carpeta del NAS del grupo.

## Reto 1 — Cómputo paralelo (π)

```bash
bash reto1-pi-paralelo/lanzar_pi.sh a 8 20000000
```

Ejecuta primero el cálculo en un solo contenedor y después lo reparte en `N` tareas
(`--mode replicated-job`). Compara tiempos y relaciónalos con la Ley de Amdahl (Práctica 1).

## Reto 2 — Monitoreo global

```bash
mkdir -p /mnt/cluster-data/grupo-a/monitoreo
GRUPO=grupo-a docker stack deploy -c reto2-monitoreo/monitoreo-stack.yml monitoreo
bash reto2-monitoreo/ver_monitoreo.sh a
```

Servicio con `mode: global`: una réplica por nodo que reporta temperatura, carga y memoria.
Retíralo con `docker stack rm monitoreo`.

## Reto 3 — Respaldo y restauración

```bash
mkdir -p /mnt/cluster-data/grupo-a/respaldos
GRUPO=grupo-a docker stack deploy -c ../practica-08-proyecto/stack.yml -c reto3-respaldo/respaldo.yml sitio
bash reto3-respaldo/restaurar.sh a
```

Para probarlo: crea una entrada, espera un respaldo (baja `INTERVALO` para la prueba),
borra la entrada en WordPress y restaura.
