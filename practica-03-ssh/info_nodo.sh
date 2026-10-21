#!/usr/bin/env bash
# Práctica 3 — Muestra la información del nodo para la bitácora (sección 2.3.3).
# Se ejecuta EN el nodo:  bash info_nodo.sh
# O desde la laptop:       ssh cluster@192.168.20.10 'bash -s' < info_nodo.sh

echo "Nodo:          $(hostname)"
echo "Arquitectura:  $(uname -m)  (debe ser aarch64)"
echo "Sistema:       $(. /etc/os-release && echo "$PRETTY_NAME")"
echo "Memoria:       $(free -h | awk '/^Mem:/ {print $7 " libres de " $2}')"
echo "Disco /:       $(df -h / | awk 'NR==2 {print $4 " libres de " $2}')"
if command -v vcgencmd >/dev/null; then
  echo "Temperatura:   $(vcgencmd measure_temp | cut -d= -f2)"
fi
echo "IP eth0:       $(ip -4 -o addr show eth0 2>/dev/null | awk '{print $4}')"
echo "Encendido:     $(uptime -p)"

echo
echo "Herramientas base:"
for h in git curl vim htop nc ufw docker; do
  if command -v "$h" >/dev/null; then echo "  [x] $h"; else echo "  [ ] $h"; fi
done
