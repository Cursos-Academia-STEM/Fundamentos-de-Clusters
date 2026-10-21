# Laboratorio virtual (Anexo F)

Cluster de 4 nodos en tu laptop con Docker Desktop: cada nodo es un contenedor `docker:dind`.
Sirve para practicar la formación del swarm y las fallas sin riesgo para el cluster del laboratorio.

```powershell
powershell -ExecutionPolicy Bypass -File crear_lab.ps1
powershell -ExecutionPolicy Bypass -File crear_lab.ps1 -Borrar
```

```bash
bash crear_lab.sh
bash crear_lab.sh --borrar
```

Reproduce solo la parte de software (Docker y Swarm). Para Linux, SSH y UFW usa máquinas virtuales.
