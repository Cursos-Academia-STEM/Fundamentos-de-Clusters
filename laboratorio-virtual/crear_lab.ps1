# Anexo F — Laboratorio virtual de 4 nodos con Docker in Docker (Windows + Docker Desktop).
# Uso:  powershell -ExecutionPolicy Bypass -File crear_lab.ps1 [-Borrar]
param([switch]$Borrar)

$nodos = 1..4 | ForEach-Object { "nodo$_" }

if ($Borrar) {
    docker rm -f $nodos
    docker network rm lab
    return
}

docker network create lab | Out-Null
foreach ($n in $nodos) {
    docker run -d --privileged --name $n --hostname $n --network lab docker:dind | Out-Null
}

Write-Host "Esperando a que Docker arranque dentro de cada nodo..."
foreach ($n in $nodos) {
    do { Start-Sleep -Seconds 2; docker exec $n docker info *> $null } until ($LASTEXITCODE -eq 0)
}

docker exec nodo1 docker swarm init | Out-Null
$T = docker exec nodo1 docker swarm join-token -q worker
foreach ($n in $nodos[1..3]) {
    docker exec $n docker swarm join --token $T nodo1:2377 | Out-Null
}
docker exec nodo1 docker node ls

Write-Host @"

Laboratorio listo. Prueba de falla (F.3):
  docker exec nodo1 docker service create --name web --replicas 4 -p 8080:80 nginx
  docker stop nodo3
  docker exec nodo1 docker service ps web
  docker start nodo3
Borrar:  powershell -File crear_lab.ps1 -Borrar
"@
