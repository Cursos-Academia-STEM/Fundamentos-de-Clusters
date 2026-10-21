#!/usr/bin/env bash
# GUÍA DE REFERENCIA — Forma el swarm de un grupo desde su maestro (sección 2.6.3).
# Solo para un cluster NUEVO. En el laboratorio los swarms ya existen.
# Requiere llave SSH del maestro hacia sus workers.
# Uso: bash formar_swarm.sh <a|b>
source "$(dirname "$0")/../comun/lib.sh"
usar_grupo "$1"

if [ "$(docker info --format '{{.Swarm.LocalNodeState}}')" = active ]; then
  falla "Este nodo ya pertenece a un swarm. No lo vuelvas a inicializar."; exit 1
fi
confirmar "Se inicializará el swarm del grupo $GRUPO en $MAESTRO y se unirán sus 3 workers."

docker swarm init --advertise-addr "$MAESTRO"
TOKEN=$(docker swarm join-token -q worker)

for ip in $NODOS; do
  [ "$ip" = "$MAESTRO" ] && continue
  echo "Uniendo $ip..."
  ssh "$USUARIO@$ip" "docker swarm join --token $TOKEN $MAESTRO:2377"
done
docker node ls
