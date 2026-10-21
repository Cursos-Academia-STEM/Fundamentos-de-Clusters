"""Práctica 2 — Presupuesto de potencia del switch PoE.

Potencia total = nodos x consumo máximo por nodo, más un margen de seguridad.
Compara el resultado con el PoE budget del switch y con el estándar por puerto.

Uso:
    python presupuesto_poe.py --nodos 8 --consumo 12 --budget 120
    python presupuesto_poe.py --nodos 6 --consumo 10            # ejercicio de autoevaluación
"""
import argparse

ESTANDARES = {"802.3af (PoE)": 15.4, "802.3at (PoE+)": 30.0}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--nodos", type=int, default=8)
    ap.add_argument("--consumo", type=float, default=12.0, help="W máximos por nodo")
    ap.add_argument("--margen", type=float, default=20.0, help="margen de seguridad en %%")
    ap.add_argument("--budget", type=float, default=None, help="PoE budget del switch en W")
    args = ap.parse_args()

    total = args.nodos * args.consumo
    con_margen = total * (1 + args.margen / 100)
    print(f"Potencia total:   {args.nodos} x {args.consumo:g} W = {total:g} W")
    print(f"Con margen {args.margen:g} %: {total:g} W x {1 + args.margen / 100:g} = {con_margen:.1f} W")

    print("\nEstándar por puerto:")
    for nombre, maximo in ESTANDARES.items():
        estado = "suficiente" if args.consumo <= maximo else "INSUFICIENTE"
        print(f"  {nombre:<15} hasta {maximo:>4} W -> {estado}")

    if args.budget is not None:
        print()
        if args.budget >= con_margen:
            print(f"OK: el switch ({args.budget:g} W) alcanza para el cluster.")
        else:
            nodos_max = int(args.budget // (args.consumo * (1 + args.margen / 100)))
            print(f"ATENCIÓN: el switch ({args.budget:g} W) NO alcanza. Faltan {con_margen - args.budget:.1f} W.")
            print(f"Con margen, solo puede alimentar {nodos_max} nodos a carga máxima.")
            print("Solución: un switch con mayor presupuesto o repartir los nodos en dos switches.")


if __name__ == "__main__":
    main()
