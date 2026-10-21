#!/usr/bin/env bash
# GUÍA DE REFERENCIA — Aplica las reglas UFW de un grupo (sección 2.4.6).
# Solo para un cluster NUEVO o el laboratorio virtual. En el laboratorio las reglas ya están activas.
# Uso: bash ufw_grupo.sh <a|b> <IP-de-la-laptop>
source "$(dirname "$0")/../comun/lib.sh"
usar_grupo "$1"
LAPTOP="${2:?Indica la IP reservada de la laptop de administración, p. ej. 192.168.20.140}"

confirmar "Se aplicarán reglas UFW del grupo $GRUPO: permitir $SUBRED, bloquear $SUBRED_OTRO, SSH desde $LAPTOP."

# SSH primero, para no perder el acceso al activar el firewall
sudo ufw allow from "$LAPTOP" to any port 22 proto tcp

for regla in "2377 tcp" "7946 tcp" "7946 udp" "4789 udp"; do
  set -- $regla
  sudo ufw allow from "$SUBRED"      to any port "$1" proto "$2"
  sudo ufw deny  from "$SUBRED_OTRO" to any port "$1" proto "$2"
done

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw show added
confirmar "Revisa las reglas anteriores. Se activará UFW."
sudo ufw --force enable
sudo ufw status verbose
