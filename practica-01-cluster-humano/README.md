# Práctica 1 — El "cluster humano"

> **Manual:** Módulo 1, sección 2.1.6 — Práctica 1 · Autoevaluación al final del módulo
>
> Primero realiza el procedimiento del manual escribiendo tú los comandos; después usa estos recursos para comprobar tu resultado.

| Archivo | Para qué |
|---|---|
| `generar_hojas.py` | Genera las hojas de 64 números para 1, 4 y 8 personas y la clave del instructor. |
| `suma_paralela.py` | Repite el experimento en la computadora con 1, 2, 4 y 8 procesos. |
| `simulador_amdahl.py` | Calcula la aceleración teórica para comprobar tu respuesta al "Analiza el error" del módulo. |
| `resultados.csv` | Plantilla para registrar los tiempos del experimento. |

```bash
python generar_hojas.py --semilla 2026
python suma_paralela.py --coordinacion 0.2   # simula el "dictado" (red lenta)
python simulador_amdahl.py --tiempo 600
```

Preguntas guía: ¿quién fue el *manager*? ¿qué pasa si un *worker* se ausenta?
Compara la aceleración medida con la de Amdahl y explica la diferencia en tu bitácora.

## Evidencia para el portafolio

- [ ] Tabla de tiempos (`resultados.csv`) de 1, 4, 8 y 8 personas con dictado.
- [ ] Explicación de por qué 8 personas no fueron 8 veces más rápidas (Ley de Amdahl).
- [ ] Salida de `simulador_amdahl.py` y respuesta al *Analiza el error*.
- [ ] Mapa conceptual de tipos de clusters.
