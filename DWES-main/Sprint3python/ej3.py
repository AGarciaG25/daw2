cuenta = (
    {"nombre": "ana", "saldo": 1200.0},
    {"nombre": "paco", "saldo": 500.0},
    {"nombre": "pepe", "saldo": 2000.0}
)

def consultar(usuario):
    for c in cuenta:
        if c["nombre"] == usuario:
            print(f"El saldo de {usuario} es: {c['saldo']} €")
            break

def ingresar(usuario):
    while True:
        try:
            ingreso = float(input("Indique el importe a ingresar: "))
            if ingreso < 0:
                print("Número no válido.")
                continue
            for c in cuenta:
                if c["nombre"] == usuario:
                    c["saldo"] += ingreso
                    print(f"Se han ingresado {ingreso} € correctamente.")
                    break
            break
        except ValueError:
            print("Error: debes introducir un número válido.")

def retirar(usuario):
    while True:
        try:
            retiro = float(input("Indique el importe a retirar: "))
            if retiro < 0:
                print("Número no válido.")
                continue
            for c in cuenta:
                if c["nombre"] == usuario:
                    if c["saldo"] < retiro:
                        print("Saldo insuficiente.")
                    else:
                        c["saldo"] -= retiro
                        print(f"Se han retirado {retiro} € correctamente.")
                    break
            break
        except ValueError:
            print("Error: debes introducir un número válido.")

while True:
    usuario = input("Ingrese su nombre: ").lower()
    if any(c["nombre"] == usuario for c in cuenta):
        break
    else:
        print("Usuario no encontrado. Intente de nuevo.")

while True:
    print("\n=== MENÚ PRINCIPAL ===")
    print("1. Consultar saldo")
    print("2. Ingresar dinero")
    print("3. Retirar dinero")
    print("4. Salir")

    try:
        opcion = int(input("Indica opción (1 a 4): "))
    except ValueError:
        print("Error: debes introducir un número entero.")
        continue

    if opcion == 1:
        consultar(usuario)
    elif opcion == 2:
        ingresar(usuario)
    elif opcion == 3:
        retirar(usuario)
    elif opcion == 4:
        print("Hasta pronto.")
        break
    else:
        print("Número no válido. Intente nuevamente.")

