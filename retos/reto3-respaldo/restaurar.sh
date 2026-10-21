#!/usr/bin/env bash
# Reto 3 — Restaura un respaldo en la base de datos del stack "sitio".
# Ejecutar en el maestro. Usa una tarea única conectada a la red del stack.
# Uso: bash restaurar.sh <a|b> [archivo.sql.gz]   (por omisión, el más reciente)
source "$(dirname "$0")/../../comun/lib.sh"
usar_grupo "$1"
DIR="$MONTAJE/$CARPETA_GRUPO/respaldos"
ARCHIVO="$(basename "${2:-$(ls -1t "$DIR"/*.sql.gz 2>/dev/null | head -n 1)}")"
[ -f "$DIR/$ARCHIVO" ] || { falla "No hay respaldos en $DIR"; exit 1; }

confirmar "Se restaurará $ARCHIVO sobre la base 'wordpress' del grupo $GRUPO (se sobrescriben los datos actuales)."

docker service create --name restaurar --detach=false \
  --mode replicated-job --network sitio_default \
  --env MYSQL_PWD=raiz123 \
  --mount "type=volume,source=sitio_respaldos,target=/respaldos,volume-driver=local,volume-opt=type=nfs,volume-opt=o=addr=$NAS_IP\,rw\,nfsvers=4,volume-opt=device=:$NFS_RUTA/$CARPETA_GRUPO/respaldos" \
  mariadb:11 bash -c "gunzip -c /respaldos/$ARCHIVO | mariadb -h db -u root wordpress && echo RESTAURADO"

docker service logs restaurar 2>/dev/null | grep -q RESTAURADO && ok "Restauración completa" \
  || falla "Revisa: docker service logs restaurar"
docker service rm restaurar >/dev/null
