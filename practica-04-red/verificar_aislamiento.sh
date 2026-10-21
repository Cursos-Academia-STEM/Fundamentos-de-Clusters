#!/usr/bin/env bash
# Práctica 4 / 6 — Comprueba que los puertos de Swarm del otro grupo están bloqueados
# y los del propio grupo abiertos. Se ejecuta en un nodo del grupo.
# Uso: bash verificar_aislamiento.sh <a|b>
source "$(dirname "$0")/../comun/lib.sh"
usar_grupo "$1"

titulo "Mi maestro ($MAESTRO) — debe RESPONDER"
cmd "nc -zv $MAESTRO 2377"
if nc -zv -w 3 "$MAESTRO" 2377 2>&1 | grep -qi succeeded; then
  ok "2377/tcp abierto en $MAESTRO"
else
  aviso "2377/tcp no responde en $MAESTRO (¿ya existe el swarm? ¿estás en un nodo del grupo $GRUPO?)"
fi

titulo "Maestro del grupo $OTRO ($MAESTRO_OTRO) — debe FALLAR"
for puerto in 2377 7946; do
  cmd "nc -zv $MAESTRO_OTRO $puerto"
  if nc -zv -w 3 "$MAESTRO_OTRO" "$puerto" 2>&1 | grep -qi succeeded; then
    falla "$puerto/tcp ACCESIBLE en el otro grupo: revisa las reglas UFW de ambos nodos"
  else
    ok "$puerto/tcp bloqueado hacia $MAESTRO_OTRO"
  fi
done
