#!/usr/bin/env bash
# Reto 2 — Muestra el último reporte de cada nodo. Uso: bash ver_monitoreo.sh <a|b>
source "$(dirname "$0")/../../comun/lib.sh"
usar_grupo "$1"
watch -n 5 "cat $MONTAJE/$CARPETA_GRUPO/monitoreo/*.txt 2>/dev/null | sort -k2"
