# Práctica 3 — Administración remota por SSH

> **Manual:** Módulo 3, sección 2.3.6 — Práctica 3 · Comandos en 2.3.3 · Llaves SSH en 2.3.5
>
> Primero realiza el procedimiento del manual escribiendo tú los comandos; después usa estos recursos para comprobar tu resultado.

| Archivo | Dónde se ejecuta | Para qué |
|---|---|---|
| `info_nodo.sh` | Nodo | Nombre, arquitectura, memoria, disco, temperatura y herramientas base. |
| `copiar_llave.ps1` | Laptop Windows | Genera la llave ed25519 y la copia a los 4 nodos. |
| `consultar_nodos.ps1` | Laptop Windows | Ejecuta un comando en los 4 nodos. |
| `consultar_nodos.sh` | Laptop Linux/macOS | Igual, en Bash (copia la llave antes con `ssh-copy-id`). |

```powershell
powershell -ExecutionPolicy Bypass -File copiar_llave.ps1 -Grupo a
Get-Content info_nodo.sh | ssh cluster@192.168.20.10 "bash -s"
```

**Si tu equipo no permite ejecutar scripts de PowerShell** (equipos escolares administrados),
copia la llave a mano con los comandos de la sección 2.3.5, repitiendo la segunda línea para cada nodo:

```powershell
ssh-keygen -t ed25519
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh cluster@192.168.20.10 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

Punto de control: `ssh cluster@<IP> hostname` responde en los 4 nodos sin pedir contraseña.

## Evidencia para el portafolio

- [ ] Salida de `info_nodo.sh` (o de los comandos de 2.3.3) de los 4 nodos.
- [ ] Captura de `ssh cluster@<IP> hostname` sin contraseña en los 4 nodos.
- [ ] Respuesta al *Analiza el error* (`apt install` sin `sudo`).
