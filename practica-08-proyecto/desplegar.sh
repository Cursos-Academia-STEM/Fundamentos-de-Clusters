#!/usr/bin/env bash
# Proyecto integrador — Prepara las carpetas del NAS, despliega el stack y escala la web.
# Ejecutar en el maestro del grupo.
# Uso: bash desplegar.sh <a|b>
source "$(dirname "$0")/../comun/lib.sh"
usar_grupo "$1"
cd "$(dirname "$0")"
export GRUPO="$CARPETA_GRUPO"

mount | grep -q " $MONTAJE " || { falla "$MONTAJE no está montado (Práctica 7)"; exit 1; }
mkdir -p "$MONTAJE/$GRUPO/db" "$MONTAJE/$GRUPO/wp" && ok "Carpetas $GRUPO/db y $GRUPO/wp listas"

docker stack deploy -c stack.yml sitio
echo "Esperando a que los servicios arranquen..."
until docker stack services sitio --format '{{.Replicas}}' | grep -qv '^0/'; do sleep 5; done
docker stack services sitio
docker service ps sitio_db sitio_web --format 'table {{.Name}}\t{{.Node}}\t{{.CurrentState}}'

echo
echo "Abre http://$MAESTRO:8080 y completa la instalación de WordPress."
read -rp "Presiona Enter cuando termines para escalar la web a 3 réplicas... "
docker service scale sitio_web=3
