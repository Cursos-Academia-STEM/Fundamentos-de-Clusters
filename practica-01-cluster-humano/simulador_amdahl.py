"""Práctica 1 — Ley de Amdahl.

Calcula la aceleración teórica S(N) = 1 / ((1 - p) + p / N), donde p es la
fracción del trabajo que se puede paralelizar y N el número de nodos.

Uso:
    python simulador_amdahl.py                 # tabla para p = 0.50, 0.75, 0.90, 0.95
    python simulador_amdahl.py --p 0.9 --tiempo 600
"""
import argparse


def aceleracion(p, n):
    return 1 / ((1 - p) + p / n)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--p", type=float, nargs="*", default=[0.50, 0.75, 0.90, 0.95],
                    help="fracción paralelizable (0 a 1)")
    ap.add_argument("--tiempo", type=float, default=None,
                    help="tiempo con 1 nodo, en segundos, para estimar tiempos")
    args = ap.parse_args()

    nodos = [1, 2, 4, 8, 16, 64]
    print("Aceleración según la Ley de Amdahl\n")
    print(f"{'p':>5} | " + " | ".join(f"N={n:<3}" for n in nodos) + " | Límite")
    print("-" * (10 + 8 * len(nodos) + 9))
    for p in args.p:
        fila = " | ".join(f"{aceleracion(p, n):5.2f}" for n in nodos)
        limite = "inf" if p == 1 else f"{1 / (1 - p):.1f}x"
        print(f"{p:>5.2f} | {fila} | {limite}")

    if args.tiempo:
        print(f"\nTiempo estimado partiendo de {args.tiempo:.0f} s con 1 nodo:")
        for p in args.p:
            tiempos = ", ".join(f"N={n}: {args.tiempo / aceleracion(p, n):.0f} s" for n in (4, 8))
            print(f"  p={p:.2f} -> {tiempos}")

    print("\nAnaliza el error del manual: con 4 Raspberry Pi tardas 10 min. ¿Con 8 tardas 5?")
    for p in args.p:
        t1 = 10 * aceleracion(p, 4)
        print(f"  p={p:.2f}: con 8 nodos tardarías {t1 / aceleracion(p, 8):.1f} min")


if __name__ == "__main__":
    main()
