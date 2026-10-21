#!/usr/bin/env bash
# Práctica 4 — Diagnóstico de red "de lo más cercano a lo más lejano" (sección 2.4.7).
# Se ejecuta en un nodo del grupo. No modifica nada.
# Uso: bash diagnostico_red.sh <a|b>
source "$(dirname "$0")/../comun/lib.sh"
usar_grupo "$1"

probar_ping() {  # $1 destino  $2 descripción
  cmd "ping -c 2 $1"
  if ping -c 2 -W 2 "$1" >/dev/null 2>&1; then ok "$2 ($1)"; else falla "$2 ($1)"; fi
}

titulo "1. ¿Tengo dirección?"
cmd "ip -4 addr show eth0"; cmd "ip link show eth0"
IP=$(ip -4 -o addr show eth0 | awk '{print $4}')
MAC=$(cat /sys/class/net/eth0/address 2>/dev/null)
[ -n "$IP" ] && ok "IP $IP  MAC $MAC" || falla "eth0 sin dirección IPv4"

titulo "2. ¿Cuál es mi puerta de enlace?"
cmd "ip route"
GW=$(ip route | awk '/^default/ {print $3; exit}')
[ "$GW" = "$GATEWAY" ] && ok "Puerta de enlace $GW" || aviso "Puerta de enlace '$GW' (se esperaba $GATEWAY)"

titulo "3. ¿Llego a mis vecinos del grupo $GRUPO?"
for ip in $NODOS; do probar_ping "$ip" "nodo"; done

titulo "4. ¿Llego a la infraestructura?"
probar_ping "$GATEWAY" "router"
probar_ping "$NAS_IP" "NAS"
probar_ping 8.8.8.8 "Internet"

titulo "5. ¿Se resuelven los nombres?"
for n in nas pi-$GRUPO-master pi-$GRUPO-01 pi-$OTRO-01; do
  cmd "getent hosts $n"
  r=$(getent hosts "$n" | awk '{print $1}')
  [ -n "$r" ] && ok "$n -> $r" || falla "$n no se resuelve (revisa /etc/hosts)"
done
getent hosts google.com >/dev/null && ok "DNS externo" || falla "DNS externo"

titulo "6. Firewall"
cmd "sudo ufw status verbose"
if command -v ufw >/dev/null; then
  sudo -n ufw status 2>/dev/null | head -n 1 || aviso "Ejecuta 'sudo ufw status verbose' para ver las reglas"
fi
