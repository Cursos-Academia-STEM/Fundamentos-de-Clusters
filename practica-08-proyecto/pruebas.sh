#!/usr/bin/env bash
# Proyecto integrador — Pruebas de la sección 2.8.3 con registro en CSV (hora, prueba, acción, resultado).
# Ejecutar en el maestro, CON AUTORIZACIÓN DEL INSTRUCTOR. Solo apaga workers, una prueba a la vez.
# Uso: bash pruebas.sh <a|b>
source "$(dirname "$0")/../comun/lib.sh"
usar_grupo "$1"
CSV="resultados_pruebas_$(date +%Y%m%d_%H%M).csv"
echo "hora,prueba,accion,resultado" > "$CSV"

registrar() { echo "$(date +%T),$1,$2,$3" >> "$CSV"; echo "  -> $3"; }
nodo_de()   { docker service ps "$1" --filter desired-state=running --format '{{.Node}}' | head -n 1; }
ip_de()     { awk -v n="$1" '$1==n {print $3}' "$(dirname "$0")/../comun/nodos.conf"; }
sitio_ok()  { curl -fs -o /dev/null -m 5 "http://$1:8080/"; }

esperar_estable() {
  echo "  Esperando a que el cluster se estabilice..."
  until docker service ls --filter name=sitio_ --format '{{.Replicas}}' \
        | awk -F/ '$1!=$2 {exit 1}'; do sleep 5; done
}

apagar() {  # $1 nodo
  confirmar "Se apagará $1."
  ssh -o ConnectTimeout=5 "$USUARIO@$(ip_de "$1")" "sudo shutdown -h now" || true
  until [ "$(docker node ls --filter "name=$1" --format '{{.Status}}')" = Down ]; do sleep 3; done
}

titulo "1. Acceso por cualquier nodo"
set -- $NODOS
r=""; for ip in "$2" "$3"; do sitio_ok "$ip" && r="$r $ip:OK" || r="$r $ip:FALLA"; done
registrar "Acceso por cualquier nodo" "curl a $2 y $3" "$r"

titulo "2. Escalamiento"
docker service scale sitio_web=4 --detach=false >/dev/null
registrar "Escalamiento" "scale sitio_web=4" \
  "$(docker service ps sitio_web --filter desired-state=running --format '{{.Node}}' | sort | uniq -c | tr -s ' \n' ' ')"

titulo "3. Falla de un nodo web"
WEB=$(docker service ps sitio_web --filter desired-state=running --format '{{.Node}}' | grep -v master | grep -v "$(nodo_de sitio_db)" | head -n 1)
apagar "$WEB"
sitio_ok "$MAESTRO" && r="sitio responde" || r="sitio NO responde"
esperar_estable
registrar "Falla de nodo web" "shutdown $WEB" "$r; réplicas $(docker service ls --filter name=sitio_web --format '{{.Replicas}}')"
read -rp "Reconecta el cable PoE de $WEB y presiona Enter... "
until [ "$(docker node ls --filter "name=$WEB" --format '{{.Status}}')" = Ready ]; do sleep 5; done

titulo "4. Falla del nodo de la base de datos"
DB=$(nodo_de sitio_db)
apagar "$DB"
esperar_estable
sleep 20
sitio_ok "$MAESTRO" && r="db reiniciada en $(nodo_de sitio_db); sitio responde" || r="sitio NO responde"
registrar "Falla de nodo db" "shutdown $DB" "$r (verifica que las entradas se conservan)"
read -rp "Reconecta el cable PoE de $DB y presiona Enter... "
until [ "$(docker node ls --filter "name=$DB" --format '{{.Status}}')" = Ready ]; do sleep 5; done

titulo "5. Recuperación"
docker service update --force --detach=false sitio_web >/dev/null
registrar "Recuperación" "update --force sitio_web" \
  "$(docker service ps sitio_web --filter desired-state=running --format '{{.Node}}' | sort | uniq -c | tr -s ' \n' ' ')"

ok "Resultados guardados en $CSV"
