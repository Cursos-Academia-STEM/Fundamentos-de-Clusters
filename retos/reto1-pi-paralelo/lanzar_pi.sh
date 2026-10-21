#!/usr/bin/env bash
# Reto 1 — Reparte el cálculo de π entre varias tareas del swarm y compara contra un solo nodo.
# Ejecutar en el maestro. El código y los resultados viajan por la carpeta del NAS.
# Uso: bash lanzar_pi.sh <a|b> [partes] [muestras]
source "$(dirname "$0")/../../comun/lib.sh"
usar_grupo "$1"
PARTES="${2:-8}"
MUESTRAS="${3:-20000000}"
DIR="$MONTAJE/$CARPETA_GRUPO/pi"

rm -rf "$DIR" && mkdir -p "$DIR"
cp "$(dirname "$0")/pi_worker.py" "$DIR/"

titulo "Referencia: 1 proceso en $(hostname)"
docker run --rm -e MUESTRAS="$MUESTRAS" -v "$DIR:/datos/pi" python:3.12-slim \
  python /datos/pi/pi_worker.py --local

titulo "Cluster: $PARTES tareas"
t0=$(date +%s.%N)
docker service create --name pi-calculo --detach=false \
  --mode replicated-job --replicas "$PARTES" --max-concurrent "$PARTES" \
  --env PARTE='{{.Task.Slot}}' --env PARTES="$PARTES" --env MUESTRAS="$MUESTRAS" \
  --mount "type=volume,source=pi_$CARPETA_GRUPO,target=/datos/pi,volume-driver=local,volume-opt=type=nfs,volume-opt=o=addr=$NAS_IP\,rw\,nfsvers=4,volume-opt=device=:$NFS_RUTA/$CARPETA_GRUPO/pi" \
  python:3.12-slim python /datos/pi/pi_worker.py >/dev/null
t1=$(date +%s.%N)

docker service ps pi-calculo --format '{{.Name}} {{.Node}} {{.CurrentState}}'
docker service rm pi-calculo >/dev/null

cat "$DIR"/parte_*.txt | awk -v t="$(awk -v a="$t0" -v b="$t1" 'BEGIN {print b - a}')" '
  { dentro += $1; total += $2; nodos[$4]++ }
  END {
    printf "\nπ ≈ %.6f  (%d muestras)\n", 4 * dentro / total, total
    printf "Tiempo total en el cluster (incluye coordinación): %.1f s\n", t
    printf "Contenedores distintos: %d\n", length(nodos)
  }'
echo "Compara con el tiempo de referencia y explica el resultado con la Ley de Amdahl."
