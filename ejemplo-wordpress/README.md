# Ejemplo WordPress para la guía

Sitio WordPress que se instala y llena solo con [WP-CLI](https://wp-cli.org/) (`wordpress:cli`, compatible con ARM64),
para que la guía muestre un sitio con contenido sin tener que pasar por el asistente de instalación.

Contenido que se publica: *Te damos la bienvenida a nuestro cluster*, *Arquitectura del cluster*,
*¿Cómo sigue funcionando si falla un nodo?* y *Prueba de persistencia* (con fecha y hora).
El sitio queda en español de México (si hay Internet) con enlaces `/nombre-de-entrada/`.

| Archivo | Para qué |
|---|---|
| `contenido.sh` | Instala WordPress y publica las entradas. No duplica nada si se ejecuta de nuevo. |
| `compose.yaml` | Versión para un solo nodo (Práctica 5) con el servicio `wpcli`. |
| `poblar_swarm.sh` | Versión para el stack `sitio` del swarm (Práctica 8). |

## En un nodo (Práctica 5)

```bash
cd ~/ejemplo-wordpress
docker compose up -d
WP_URL=http://192.168.20.11:8080 docker compose run --rm wpcli
```

Prueba de persistencia: `docker compose down`, `docker compose up -d` y las entradas siguen ahí.

## En el swarm (Práctica 8)

```bash
bash ../practica-08-proyecto/desplegar.sh a     # en la pausa, en lugar de instalar a mano:
bash poblar_swarm.sh a                          # en otra terminal
```

Acceso de administración: `http://<IP>:8080/wp-admin` — usuario `admin`, contraseña `cluster2026`
(solo para el laboratorio).

> [!WARNING]
> Esta contraseña es pública porque está en el repositorio. Como buena práctica de seguridad,
> define la tuya al crear el sitio, por ejemplo
> `WP_CLAVE=<tu-contraseña> WP_URL=http://192.168.20.11:8080 docker compose run --rm wpcli`,
> o cámbiala después en **wp-admin › Perfil**.
