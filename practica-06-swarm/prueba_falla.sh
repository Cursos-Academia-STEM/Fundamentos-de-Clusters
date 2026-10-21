#!/usr/bin/env bash
# Práctica 6 — Prueba de tolerancia a fallos guiada (pasos 4 y 6–10).
# Ejecutar en el maestro, CON AUTORIZACIÓN DEL INSTRUCTOR. Apaga solo un worker, nunca el maestro.
# Uso: bash prueba_falla.sh <a|b> [worker]     (worker por omisión: pi-<g>-02)
source "$(dirname "$0")/../comun/lib.sh"
usar_grupo "$1"
SERVICIO="test-$GRUPO"
WORKER="${2:-pi-$GRUPO-02}"
[[ "$WORKER" == *master* ]] && { falla "No apagues el maestro"; exit 1; }
WORKER_IP=$(awk -v n="$WORKER" '$1==n {print $3}' "$(dirname "$0")/../comun/nodos.conf")
BITACORA="bitacora_falla_$(date +%Y%m%d_%H%M).txt"

log() { echo "$(date +%H:%M:%S)  $*" | tee -a "$BITACORA"; }

log "Creando $SERVICIO con 4 réplicas, 1 por nodo"
docker service create --name "$SERVICIO" --replicas 4 --replicas-max-per-node 1 --detach=false nginx
docker service ps "$SERVICIO" --format '{{.Name}} {{.Node}} {{.CurrentState}}' | tee -a "$BITACORA"

log "Quitando el límite de réplicas por nodo"
docker service update --replicas-max-per-node 0 --detach=false "$SERVICIO" >/dev/null

confirmar "Se apagará $WORKER ($WORKER_IP) con 'sudo shutdown -h now'."
log "Apagando $WORKER"
ssh -o ConnectTimeout=5 "$USUARIO@$WORKER_IP" "sudo shutdown -h now" || true

log "Esperando a que $WORKER aparezca como Down y la tarea se reprograme..."
t0=$(date +%s)
while true; do
  estado=$(docker node ls --filter "name=$WORKER" --format '{{.Status}}')
  corriendo=$(docker service ps "$SERVICIO" --filter desired-state=running --format '{{.Node}} {{.CurrentState}}' \
              | grep -v "^$WORKER " | grep -c Running)
  printf "\r  t=%3ss  %s: %-5s  réplicas en otros nodos: %s/4" "$(( $(date +%s) - t0 ))" "$WORKER" "$estado" "$corriendo"
  [ "$estado" = Down ] && [ "$corriendo" -eq 4 ] && break
  sleep 3
done
echo
log "Recuperado en $(( $(date +%s) - t0 )) s: $WORKER Down y 4 réplicas activas"
docker service ps "$SERVICIO" --filter desired-state=running --format '{{.Name}} {{.Node}} {{.CurrentState}}' | tee -a "$BITACORA"

echo
read -rp "Reconecta el cable PoE de $WORKER y presiona Enter... "
until [ "$(docker node ls --filter "name=$WORKER" --format '{{.Status}}')" = Ready ]; do sleep 5; done
log "$WORKER volvió a Ready; redistribuyendo"
docker service update --force --detach=false "$SERVICIO" >/dev/null
docker service ps "$SERVICIO" --filter desired-state=running --format '{{.Name}} {{.Node}} {{.CurrentState}}' | tee -a "$BITACORA"

docker service rm "$SERVICIO" >/dev/null
log "Servicio eliminado. Bitácora guardada en $BITACORA"
