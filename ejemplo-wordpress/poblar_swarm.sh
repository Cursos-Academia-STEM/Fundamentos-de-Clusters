#!/usr/bin/env bash
# Ejemplo WordPress — Instala y publica el contenido de ejemplo en el stack "sitio" (Práctica 8).
# Ejecutar en el maestro, con el stack ya desplegado (sitio_web en 1 réplica).
# Uso: bash poblar_swarm.sh <a|b>
source "$(dirname "$0")/../comun/lib.sh"
usar_grupo "$1"
DIR="$MONTAJE/$CARPETA_GRUPO/ejemplo"

docker stack services sitio >/dev/null 2>&1 || { falla "El stack 'sitio' no está desplegado"; exit 1; }
mkdir -p "$DIR" && cp "$(dirname "$0")/contenido.sh" "$DIR/"

nfs() {  # $1 nombre del volumen  $2 subcarpeta del NAS
  echo "type=volume,source=$1,volume-driver=local,volume-opt=type=nfs,volume-opt=o=addr=$NAS_IP\,rw\,nfsvers=4,volume-opt=device=:$NFS_RUTA/$CARPETA_GRUPO/$2"
}

docker service create --name wp-ejemplo --detach=false \
  --mode replicated-job --network sitio_default --user 33:33 \
  --env WORDPRESS_DB_HOST=db --env WORDPRESS_DB_USER=wp \
  --env WORDPRESS_DB_PASSWORD=wp123 --env WORDPRESS_DB_NAME=wordpress \
  --env WP_URL="http://$MAESTRO:8080" --env WP_TITULO="Cluster Grupo ${GRUPO^^}" \
  --env WP_ADMIN="${WP_ADMIN:-admin}" --env WP_CLAVE="${WP_CLAVE:-cluster2026}" \
  --mount "$(nfs sitio_wp_datos wp),target=/var/www/html" \
  --mount "$(nfs ejemplo_$CARPETA_GRUPO ejemplo),target=/ejemplo" \
  --entrypoint "sh /ejemplo/contenido.sh" \
  wordpress:cli >/dev/null

docker service logs wp-ejemplo 2>/dev/null | sed 's/^[^|]*| //'
docker service rm wp-ejemplo >/dev/null
echo
echo "Ahora puedes escalar: docker service scale sitio_web=3"
