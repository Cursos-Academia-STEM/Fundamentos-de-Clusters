# Funciones compartidas por los scripts de las prácticas.
# Uso: source "$(dirname "$0")/../comun/lib.sh"

RED="192.168.20"
GATEWAY="$RED.1"
NAS_IP="$RED.5"
NFS_RUTA="/volume1/cluster-data"
MONTAJE="/mnt/cluster-data"
USUARIO="cluster"

VERDE='\033[0;32m'; ROJO='\033[0;31m'; AMARILLO='\033[0;33m'; NC='\033[0m'

ok()    { printf "${VERDE}[OK]${NC}    %s\n" "$*"; }
falla() { printf "${ROJO}[FALLA]${NC} %s\n" "$*"; }
aviso() { printf "${AMARILLO}[AVISO]${NC} %s\n" "$*"; }
titulo(){ printf "\n== %s ==\n" "$*"; }
# Muestra el comando equivalente que el participante puede escribir a mano
cmd()   { printf "  \033[2m\$ %s\033[0m\n" "$*"; }

# Valida el argumento de grupo y define GRUPO, OTRO, BASE, SUBRED, SUBRED_OTRO, MAESTRO, NODOS
usar_grupo() {
  GRUPO="$(echo "${1:-}" | tr 'AB' 'ab')"
  case "$GRUPO" in
    a) BASE=10; OTRO=b; SUBRED="$RED.8/29";  SUBRED_OTRO="$RED.16/29" ;;
    b) BASE=20; OTRO=a; SUBRED="$RED.16/29"; SUBRED_OTRO="$RED.8/29" ;;
    *) echo "Uso: $0 <a|b>" >&2; exit 1 ;;
  esac
  MAESTRO="$RED.$BASE"
  MAESTRO_OTRO="$RED.$([ "$OTRO" = a ] && echo 10 || echo 20)"
  NODOS="$RED.$BASE $RED.$((BASE+1)) $RED.$((BASE+2)) $RED.$((BASE+3))"
  CARPETA_GRUPO="grupo-$GRUPO"
}

# Pide confirmación explícita antes de un paso que modifica el cluster
confirmar() {
  printf "${AMARILLO}%s${NC}\n¿Continuar? escribe 'si': " "$*"
  read -r resp
  [ "$resp" = "si" ] || { echo "Cancelado."; exit 1; }
}
