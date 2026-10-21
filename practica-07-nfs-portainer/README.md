# Práctica 7 — NAS, NFS y Portainer

> **Manual:** Módulo 7, sección 2.7.7 — Práctica 7 · Montaje NFS en 2.7.3 · Portainer en 2.7.5
>
> Primero realiza el procedimiento del manual escribiendo tú los comandos; después usa estos recursos para comprobar tu resultado.

| Archivo | Para qué |
|---|---|
| `verificar_nfs.sh` | NAS accesible, montaje en los 4 nodos, prueba de archivo compartido y carpetas `db`/`wp`. |
| `monitoreo.sh` | Nodos, servicios, temperatura, carga y memoria de cada nodo (modo tablero opcional). |
| `montar_nfs.sh` | **Guía de referencia**: montaje permanente sin duplicar `/etc/fstab`. |

```bash
bash verificar_nfs.sh a
bash monitoreo.sh a 10
```

Portainer (desde el maestro, con autorización del instructor):

```bash
curl -L https://downloads.portainer.io/ce-lts/portainer-agent-stack.yml -o portainer-agent-stack.yml
docker stack deploy -c portainer-agent-stack.yml portainer
```

Panel: `https://192.168.20.10:9443` (Grupo A) o `https://192.168.20.20:9443` (Grupo B).

## Evidencia para el portafolio

- [ ] Ruta de montaje del NAS y captura de la regla NFS en DSM.
- [ ] Salida de `mount | grep cluster-data` en los 4 nodos.
- [ ] Archivo creado en un nodo y leído desde otro.
- [ ] Capturas de Portainer con nodos y servicios (sin contraseñas visibles).
