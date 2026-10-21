#!/usr/bin/env bash
# Práctica 6 — Verifica el swarm del grupo sin modificarlo. Ejecutar en el maestro.
# Uso: bash verificar_swarm.sh <a|b>
source "$(dirname "$0")/../comun/lib.sh"
usar_grupo "$1"

estado=$(docker info --format '{{.Swarm.LocalNodeState}} {{.Swarm.ControlAvailable}}')
case "$estado" in
  "active true")  ok "Este nodo es manager de un swarm activo" ;;
  "active false") falla "Este nodo es worker: ejecuta el script en pi-$GRUPO-master"; exit 1 ;;
  *)              falla "Este nodo no pertenece a un swarm ($estado)"; exit 1 ;;
esac

titulo "Nodos"
cmd "docker node ls"
docker node ls

total=$(docker node ls -q | wc -l)
listos=$(docker node ls --format '{{.Status}}' | grep -c Ready)
ajenos=$(docker node ls --format '{{.Hostname}}' | grep -vc "^pi-$GRUPO-")
[ "$total" -eq 4 ] && ok "4 nodos en el swarm" || aviso "$total nodos en el swarm (se esperaban 4)"
[ "$listos" -eq "$total" ] && ok "Todos en Ready" || aviso "$((total - listos)) nodo(s) no están Ready"
[ "$ajenos" -eq 0 ] && ok "Sin nodos del grupo $OTRO" || falla "$ajenos nodo(s) ajenos al grupo $GRUPO: revisa el token usado"

titulo "Aislamiento"
bash "$(dirname "$0")/../practica-04-red/verificar_aislamiento.sh" "$GRUPO"
