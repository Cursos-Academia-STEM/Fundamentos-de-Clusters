#!/usr/bin/env bash
# Práctica 7 — Resumen de monitoreo del grupo (sección 2.7.6). Ejecutar en el maestro.
# Uso: bash monitoreo.sh <a|b> [segundos]   (con segundos, se repite como un tablero)
source "$(dirname "$0")/../comun/lib.sh"
usar_grupo "$1"

resumen() {
  echo "=== Grupo $GRUPO — $(date '+%F %T') ==="
  docker node ls --format 'table {{.Hostname}}\t{{.Status}}\t{{.Availability}}\t{{.ManagerStatus}}'
  echo
  docker service ls --format 'table {{.Name}}\t{{.Replicas}}\t{{.Image}}'
  echo
  printf "%-15s %-8s %-12s %s\n" NODO TEMP CARGA "MEM LIBRE"
  for ip in $NODOS; do
    ssh -o BatchMode=yes -o ConnectTimeout=3 "$USUARIO@$ip" \
      'printf "%-15s %-8s %-12s %s\n" "$(hostname)" "$(vcgencmd measure_temp | cut -d= -f2)" \
       "$(cut -d" " -f1-3 /proc/loadavg)" "$(free -h | awk "/^Mem:/ {print \$7}")"' \
      2>/dev/null || printf "%-15s sin respuesta\n" "$ip"
  done
}

if [ -n "$2" ]; then
  while true; do clear; resumen; sleep "$2"; done
else
  resumen
fi
