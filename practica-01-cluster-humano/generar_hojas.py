"""Práctica 1 — Genera las hojas de 64 números de dos cifras para el "cluster humano".

Crea un archivo de texto por configuración (1, 4 y 8 personas) con los números
repartidos por participante y la suma correcta para que el instructor verifique.

Uso:
    python generar_hojas.py            # semilla aleatoria
    python generar_hojas.py --semilla 7
"""
import argparse
import random
from pathlib import Path


def repartir(numeros, partes):
    tam = len(numeros) // partes
    return [numeros[i * tam:(i + 1) * tam] for i in range(partes)]


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--semilla", type=int, default=None)
    p.add_argument("--salida", default="hojas")
    args = p.parse_args()

    rng = random.Random(args.semilla)
    numeros = [rng.randint(10, 99) for _ in range(64)]
    salida = Path(args.salida)
    salida.mkdir(exist_ok=True)

    for personas in (1, 4, 8):
        lineas = [f"Configuración: {personas} persona(s)", ""]
        for i, parte in enumerate(repartir(numeros, personas), 1):
            filas = [parte[j:j + 8] for j in range(0, len(parte), 8)]
            lineas.append(f"Participante {i} ({len(parte)} números):")
            lineas += ["  " + "  ".join(f"{n:2d}" for n in fila) for fila in filas]
            lineas.append("  Suma parcial: ________")
            lineas.append("")
        (salida / f"hoja_{personas}_personas.txt").write_text("\n".join(lineas), encoding="utf-8")

    clave = [f"Suma total correcta: {sum(numeros)}", "",
             "Sumas parciales (8 personas): " + ", ".join(str(sum(p)) for p in repartir(numeros, 8))]
    (salida / "clave_instructor.txt").write_text("\n".join(clave), encoding="utf-8")
    print(f"Hojas generadas en {salida.resolve()}")


if __name__ == "__main__":
    main()
