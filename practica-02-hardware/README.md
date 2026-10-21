# Práctica 2 — Reconocimiento del hardware

> **Manual:** Módulo 2, sección 2.2.7 — Práctica 2 · Guía de referencia 2.2.8 · Anexo D
>
> Primero realiza el procedimiento del manual escribiendo tú los comandos; después usa estos recursos para comprobar tu resultado.

| Archivo | Para qué |
|---|---|
| `presupuesto_poe.py` | Calcula el presupuesto de potencia con margen y lo compara con el switch. |
| `tabla_conexiones.csv` | Plantilla nodo → puerto del switch para la bitácora. |

```bash
python presupuesto_poe.py --nodos 8 --consumo 12 --budget 120
python presupuesto_poe.py --nodos 8 --consumo 12 --budget 60   # "Analiza el error"
```

Esta práctica **no** requiere tocar el cluster: observa, documenta y calcula.
Orden de encendido: router (30 s) → switch y NAS → Raspberry Pi.

## Evidencia para el portafolio

- [ ] Tabla nodo → puerto del switch de tu grupo (`tabla_conexiones.csv`).
- [ ] Cálculo del presupuesto de potencia con la ficha técnica del switch.
- [ ] Fotografía del cluster con los componentes y los dos grupos señalados.
- [ ] Orden de encendido justificado.
