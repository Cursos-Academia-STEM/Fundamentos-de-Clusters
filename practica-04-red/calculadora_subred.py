"""Práctica 4 — Calculadora de subredes.

Muestra red, máscara, rango de hosts y si una IP pertenece a la subred.
Útil para las subredes /29 de las reglas UFW.

Uso:
    python calculadora_subred.py 192.168.20.16/29
    python calculadora_subred.py 192.168.20.8/29 --ip 192.168.20.13
    python calculadora_subred.py --laboratorio
"""
import argparse
import ipaddress

LABORATORIO = {
    "Red del laboratorio": "192.168.20.0/24",
    "Grupo A": "192.168.20.8/29",
    "Grupo B": "192.168.20.16/29",
}


def describir(cidr, ip=None):
    red = ipaddress.ip_network(cidr, strict=False)
    hosts = list(red.hosts())
    print(f"Subred:        {red}")
    print(f"Máscara:       {red.netmask}  (/{red.prefixlen})")
    print(f"Direcciones:   {red.network_address} a {red.broadcast_address} ({red.num_addresses} en total)")
    if hosts:
        print(f"Hosts útiles:  {hosts[0]} a {hosts[-1]} ({len(hosts)})")
    if ip:
        dentro = ipaddress.ip_address(ip) in red
        print(f"¿{ip} pertenece? {'Sí' if dentro else 'No'}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cidr", nargs="?")
    ap.add_argument("--ip")
    ap.add_argument("--laboratorio", action="store_true")
    args = ap.parse_args()

    if args.laboratorio or not args.cidr:
        for nombre, cidr in LABORATORIO.items():
            print(f"== {nombre} ==")
            describir(cidr)
            print()
    else:
        describir(args.cidr, args.ip)


if __name__ == "__main__":
    main()
