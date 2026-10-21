#!/usr/bin/env bash
# Práctica 6 — Demuestra el balanceo de carga con traefik/whoami (sección 2.6.5).
# Ejecutar en el maestro. Crea el servicio "quien", lo consulta y lo elimina al final.
# Uso: bash balanceo.sh <a|b> [solicitudes]
source "$(dirname "$0")/../comun/lib.sh"
usar_grupo "$1"
N="${2:-12}"

docker service create --name quien --replicas 4 -p 8080:80 --detach=false traefik/whoami
docker service scale quien=6 --detach=false
docker service ps quien --format 'table {{.Name}}\t{{.Node}}\t{{.CurrentState}}'

titulo "Routing mesh: $N solicitudes alternando entre los nodos del grupo"
for i in $(seq 1 "$N"); do
  set -- $NODOS
  shift $(( (i - 1) % 4 ))
  host=$(curl -s "http://$1:8080" | awk '/^Hostname:/ {print $2}')
  printf "%2d  vía %-14s -> réplica %s\n" "$i" "$1" "$host"
done | tee /tmp/balanceo.txt

echo
echo "Réplicas distintas que respondieron: $(awk '{print $NF}' /tmp/balanceo.txt | sort -u | wc -l)"
docker service rm quien >/dev/null && ok "Servicio quien eliminado"
