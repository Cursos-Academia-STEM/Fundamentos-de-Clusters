#!/usr/bin/env bash
# Práctica 5 — Verifica Docker en el nodo y la persistencia de la aplicación de Compose.
# Ejecutar en la carpeta donde está compose.yaml:  bash verificar_docker.sh
source "$(dirname "$0")/../comun/lib.sh"
cd "$(dirname "$0")"

titulo "Docker"
cmd "docker --version"
docker --version && ok "Docker instalado" || { falla "Docker no instalado"; exit 1; }
id -nG | grep -qw docker && ok "Usuario en el grupo docker" \
  || aviso "Usuario fuera del grupo docker: sudo usermod -aG docker \$USER y vuelve a entrar"
docker run --rm hello-world >/dev/null 2>&1 && ok "hello-world funciona" || falla "hello-world falló"
[ "$(uname -m)" = aarch64 ] && ok "Arquitectura aarch64: usa imágenes linux/arm64"

titulo "Aplicación de Compose"
cmd "docker compose config"
docker compose config -q && ok "compose.yaml válido" || { falla "Error de formato en compose.yaml"; exit 1; }
docker compose up -d
docker compose ps

IP=$(hostname -I | awk '{print $1}')
echo
echo "Abre http://$IP:8080, completa la instalación y publica una entrada."
read -rp "Presiona Enter cuando la entrada esté publicada para probar la persistencia... "

docker compose down
docker compose up -d
echo "Espera a que MariaDB arranque..."
sleep 20
if curl -fsS "http://localhost:8080/" | grep -qi "wp-content"; then
  ok "WordPress responde tras down/up. Comprueba en el navegador que tu entrada sigue ahí."
else
  aviso "WordPress aún no responde; espera un minuto y revisa 'docker compose logs'"
fi
