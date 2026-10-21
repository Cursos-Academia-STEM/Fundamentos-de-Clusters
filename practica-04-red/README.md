# Práctica 4 — Exploración y diagnóstico de la red

> **Manual:** Módulo 4, sección 2.4.8 — Práctica 4 · Diagnóstico en 2.4.7 · Anexo C
>
> Primero realiza el procedimiento del manual escribiendo tú los comandos; después usa estos recursos para comprobar tu resultado.

| Archivo | Tipo | Para qué |
|---|---|---|
| `diagnostico_red.sh` | Exploración | IP, MAC, puerta de enlace, ping a vecinos/NAS/Internet y resolución de nombres. |
| `verificar_aislamiento.sh` | Exploración | Prueba con `nc` los puertos de Swarm del propio grupo y del contrario. |
| `calculadora_subred.py` | Laptop | Rangos de las subredes `/24` y `/29` del laboratorio. |
| `plan_direccionamiento.csv` | Plantilla | Anexo C para completar con los datos reales. |
| `hosts.txt` | Referencia | Bloque de `/etc/hosts`. |
| `ufw_grupo.sh` | **Guía de referencia** | Reglas UFW de un grupo. No ejecutar en el laboratorio. |

```bash
bash diagnostico_red.sh a
bash verificar_aislamiento.sh a
python calculadora_subred.py --laboratorio
```

## Evidencia para el portafolio

- [ ] Plan de direccionamiento con IP, puerta de enlace y MAC de los 4 nodos.
- [ ] Resultados de ping a nodos, NAS, puerta de enlace e Internet.
- [ ] Captura de `sudo ufw status verbose` con la explicación de cada regla.
- [ ] Prueba de aislamiento con `nc -zv` (propio grupo responde, otro grupo falla).
