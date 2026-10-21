#!/usr/bin/env bash
# Práctica 3 — Ejecuta un comando en los 4 nodos del grupo por SSH (Linux/macOS).
# Uso: bash consultar_nodos.sh <a|b> [comando]
#      bash consultar_nodos.sh a "vcgencmd measure_temp"
source "$(dirname "$0")/../comun/lib.sh"
usar_grupo "$1"
CMD="${2:-hostname; uptime}"

for ip in $NODOS; do
  printf -- "--- %s ---\n" "$ip"
  ssh -o BatchMode=yes -o ConnectTimeout=5 "$USUARIO@$ip" "$CMD" \
    || falla "$ip no respondió (¿llave copiada? ¿nodo encendido?)"
done
