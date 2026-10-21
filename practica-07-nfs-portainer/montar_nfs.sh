#!/usr/bin/env bash
# GUÍA DE REFERENCIA — Monta la carpeta del NAS de forma permanente (sección 2.7.3).
# Solo para un nodo NUEVO. Es idempotente: no duplica la línea de /etc/fstab.
# Uso (en el nodo): bash montar_nfs.sh
source "$(dirname "$0")/../comun/lib.sh"

LINEA="$NAS_IP:$NFS_RUTA $MONTAJE nfs defaults,_netdev 0 0"
confirmar "Se montará $NAS_IP:$NFS_RUTA en $MONTAJE y se agregará a /etc/fstab si no existe."

sudo mkdir -p "$MONTAJE"
if grep -q " $MONTAJE " /etc/fstab; then
  aviso "/etc/fstab ya contiene $MONTAJE; no se agrega de nuevo"
else
  echo "$LINEA" | sudo tee -a /etc/fstab
fi
sudo mount -a && mount | grep "$MONTAJE" && ok "Montaje correcto" || falla "Revisa la regla NFS del NAS"
