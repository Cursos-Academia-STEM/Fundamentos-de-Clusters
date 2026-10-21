#!/bin/sh
# Ejemplo WordPress — Instala el sitio y publica entradas de ejemplo con WP-CLI.
# Se ejecuta DENTRO del contenedor wordpress:cli (lo lanzan compose.yaml o poblar_swarm.sh).
# Es idempotente: si el sitio o una entrada ya existen, no los duplica.
set -e

: "${WP_URL:?Falta WP_URL, p. ej. http://192.168.20.10:8080}"
TITULO="${WP_TITULO:-Cluster Raspberry Pi}"
ADMIN="${WP_ADMIN:-admin}"
CLAVE="${WP_CLAVE:-cluster2026}"

echo "Esperando a que WordPress copie sus archivos y la base de datos responda..."
until [ -f /var/www/html/wp-config.php ] && wp db check >/dev/null 2>&1; do sleep 3; done

if ! wp core is-installed 2>/dev/null; then
  wp core install --url="$WP_URL" --title="$TITULO" \
    --admin_user="$ADMIN" --admin_password="$CLAVE" \
    --admin_email="admin@cluster.local" --skip-email
  wp language core install es_MX --activate || echo "Sin Internet: el sitio queda en inglés"
  wp option update blogdescription "Sitio de ejemplo del curso Fundamentos de Clusters"
  wp option update timezone_string "America/Mexico_City"
  wp rewrite structure '/%postname%/'
  wp post delete 1 --force >/dev/null 2>&1 || true      # entrada "Hello world"
fi

publicar() {  # $1 slug  $2 título  $3 contenido
  if [ -z "$(wp post list --post_type=post --name="$1" --format=ids)" ]; then
    wp post create --post_status=publish --post_name="$1" --post_title="$2" --post_content="$3" --porcelain \
      | xargs -I{} echo "Entrada creada: $2 (id {})"
  else
    echo "Ya existe: $2"
  fi
}

publicar bienvenida "Te damos la bienvenida a nuestro cluster" \
"<p>Este sitio corre en un cluster de 4 Raspberry Pi 5 con Docker. La base de datos MariaDB y los archivos de WordPress se guardan de forma persistente.</p>"

publicar arquitectura "Arquitectura del cluster" \
"<ul><li>1 manager y 3 workers Raspberry Pi 5</li><li>Switch PoE y router TP-Link Archer C6</li><li>NAS Synology con RAID 1 compartido por NFS</li><li>Firewall UFW que aísla a los grupos A y B</li></ul>"

publicar como-funciona "¿Cómo sigue funcionando si falla un nodo?" \
"<p>Docker Swarm mantiene el estado deseado: si un worker se apaga, sus réplicas se crean de nuevo en otro nodo. Como los datos viven en el NAS, el sitio conserva todas sus entradas.</p>"

publicar prueba-persistencia "Prueba de persistencia" \
"<p>Entrada creada el $(date '+%Y-%m-%d %H:%M'). Si la sigues viendo después de <code>docker compose down</code> o de apagar un nodo, la persistencia funciona.</p>"

echo
echo "Listo: $WP_URL  (usuario: $ADMIN  contraseña: $CLAVE)"
echo "IMPORTANTE: esta contraseña es pública en el repositorio. Cámbiala en wp-admin > Perfil"
echo "o vuelve a crear el sitio con WP_CLAVE=<tu-contraseña>."
