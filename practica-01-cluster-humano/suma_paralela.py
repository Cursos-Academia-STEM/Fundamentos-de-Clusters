"""Práctica 1 — Versión en computadora del "cluster humano".

Suma una lista grande de números con 1, 2, 4 y 8 procesos (los "nodos") y mide
el tiempo de cada configuración. Un costo de coordinación artificial simula
el tiempo de repartir el trabajo y unir los resultados (o una red lenta).

Uso:
    python suma_paralela.py
    python suma_paralela.py --n 20000000 --coordinacion 0.05
"""
import argparse
import time
from multiprocessing import Pool


def suma_parcial(rango):
    inicio, fin = rango
    return sum(x % 100 for x in range(inicio, fin))


def ejecutar(n, nodos, coordinacion):
    tam = n // nodos
    partes = [(i * tam, n if i == nodos - 1 else (i + 1) * tam) for i in range(nodos)]
    t0 = time.perf_counter()
    time.sleep(coordinacion * nodos)          # repartir: el coordinador entrega una parte a cada nodo
    with Pool(nodos) as pool:
        parciales = pool.map(suma_parcial, partes)
    time.sleep(coordinacion * nodos)          # unir: el coordinador recibe cada resultado
    total = sum(parciales)
    return total, time.perf_counter() - t0


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--n", type=int, default=8_000_000, help="cantidad de números a sumar")
    p.add_argument("--coordinacion", type=float, default=0.02,
                   help="segundos de coordinación por nodo (súbelo para simular una red lenta)")
    args = p.parse_args()

    print(f"{'Nodos':>5} | {'Tiempo (s)':>10} | {'Aceleración':>11} | Resultado")
    print("-" * 50)
    base = None
    for nodos in (1, 2, 4, 8):
        total, t = ejecutar(args.n, nodos, args.coordinacion)
        base = base or t
        print(f"{nodos:>5} | {t:>10.3f} | {base / t:>10.2f}x | {total}")
    print("\n¿Por qué 8 nodos no son 8 veces más rápidos? Revisa simulador_amdahl.py")


if __name__ == "__main__":
    main()
