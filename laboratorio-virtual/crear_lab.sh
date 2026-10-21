#!/usr/bin/env bash
# Anexo F — Laboratorio virtual de 4 nodos con Docker in Docker (macOS / Linux).
# Uso: bash crear_lab.sh            crear y formar el swarm
#      bash crear_lab.sh --borrar   eliminar el laboratorio
NODOS="nodo1 nodo2 nodo3 nodo4"

if [ "$1" = "--borrar" ]; then
  docker rm -f $NODOS
  docker network rm lab
  exit 0
fi

docker network create lab >/dev/null
for n in $NODOS; do
  docker run -d --privileged --name "$n" --hostname "$n" --network lab docker:dind >/dev/null
done

echo "Esperando a que Docker arranque dentro de cada nodo..."
for n in $NODOS; do
  until docker exec "$n" docker info >/dev/null 2>&1; do sleep 2; done
done

docker exec nodo1 docker swarm init >/dev/null
T=$(docker exec nodo1 docker swarm join-token -q worker)
for n in nodo2 nodo3 nodo4; do
  docker exec "$n" docker swarm join --token "$T" nodo1:2377 >/dev/null
done
docker exec nodo1 docker node ls

cat <<'EOF'

Laboratorio listo. Prueba de falla (F.3):
  docker exec nodo1 docker service create --name web --replicas 4 -p 8080:80 nginx
  docker stop nodo3
  docker exec nodo1 docker service ps web
  docker start nodo3
Borrar:  bash crear_lab.sh --borrar
EOF
