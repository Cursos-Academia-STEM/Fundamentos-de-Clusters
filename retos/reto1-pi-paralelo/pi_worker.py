"""Reto 1 — Estima π por Monte Carlo con una parte del total de muestras.

Cada tarea del swarm recibe su número (PARTE, desde 1) y el total de partes,
calcula su porción y escribe el resultado en DIR_SALIDA/parte_<n>.txt.

Variables de entorno: PARTE, PARTES, MUESTRAS (total), DIR_SALIDA.
También funciona en un solo equipo:  python pi_worker.py --local
"""
import os
import random
import socket
import sys
import time


def contar_aciertos(muestras, semilla):
    rng = random.Random(semilla)
    dentro = 0
    for _ in range(muestras):
        x, y = rng.random(), rng.random()
        if x * x + y * y <= 1.0:
            dentro += 1
    return dentro


def main():
    total = int(os.environ.get("MUESTRAS", 20_000_000))
    if "--local" in sys.argv:
        t0 = time.perf_counter()
        dentro = contar_aciertos(total, 0)
        print(f"pi ~ {4 * dentro / total:.6f}  ({total} muestras, 1 proceso, {time.perf_counter() - t0:.1f} s)")
        return

    parte = int(os.environ["PARTE"])
    partes = int(os.environ["PARTES"])
    salida = os.environ.get("DIR_SALIDA", "/datos/pi")
    muestras = total // partes

    t0 = time.perf_counter()
    dentro = contar_aciertos(muestras, parte)
    duracion = time.perf_counter() - t0

    os.makedirs(salida, exist_ok=True)
    with open(os.path.join(salida, f"parte_{parte}.txt"), "w") as f:
        f.write(f"{dentro} {muestras} {duracion:.2f} {socket.gethostname()}\n")
    print(f"parte {parte}/{partes}: {dentro}/{muestras} en {duracion:.1f} s")


if __name__ == "__main__":
    main()
