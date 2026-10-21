#!/usr/bin/env bash
# Práctica 7 — Verifica el NAS y el montaje NFS en los 4 nodos del grupo, y prueba
# que un archivo escrito en un nodo se lee desde otro (reto 2.7.3). Ejecutar en el maestro.
# Uso: bash verificar_nfs.sh <a|b>
source "$(dirname "$0")/../comun/lib.sh"
usar_grupo "$1"

ping -c 2 -W 2 "$NAS_IP" >/dev/null && ok "NAS responde ($NAS_IP)" || { falla "NAS sin respuesta"; exit 1; }

titulo "Montaje en cada nodo"
cmd "mount | grep cluster-data ; grep cluster-data /etc/fstab   (en cada nodo)"
for ip in $NODOS; do
  r=$(ssh -o BatchMode=yes -o ConnectTimeout=5 "$USUARIO@$ip" \
      "mount | grep -c ' $MONTAJE '; grep -c '$MONTAJE' /etc/fstab" 2>/dev/null | tr '\n' ' ')
  set -- $r
  if [ "${1:-0}" -ge 1 ] && [ "${2:-0}" -eq 1 ]; then ok "$ip montado y en fstab"
  elif [ "${2:-0}" -gt 1 ]; then aviso "$ip: línea duplicada en /etc/fstab"
  else falla "$ip: montado=${1:-?} fstab=${2:-?}"; fi
done

titulo "Datos compartidos"
cmd "echo \"hola desde \$(hostname)\" > $MONTAJE/$CARPETA_GRUPO/prueba.txt   (en un nodo)"
cmd "cat $MONTAJE/$CARPETA_GRUPO/prueba.txt   (en otro nodo)"
set -- $NODOS
ARCHIVO="$MONTAJE/$CARPETA_GRUPO/prueba.txt"
ssh "$USUARIO@$2" "echo \"hola desde \$(hostname) $(date +%T)\" > $ARCHIVO" && ok "Escrito desde $2"
leido=$(ssh "$USUARIO@$4" "cat $ARCHIVO")
[ -n "$leido" ] && ok "Leído desde $4: $leido" || falla "No se pudo leer desde $4"

titulo "Carpetas del proyecto integrador"
mkdir -p "$MONTAJE/$CARPETA_GRUPO/db" "$MONTAJE/$CARPETA_GRUPO/wp" && \
  ok "$MONTAJE/$CARPETA_GRUPO/{db,wp} listas"
