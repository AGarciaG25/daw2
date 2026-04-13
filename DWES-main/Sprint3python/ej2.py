import random

opciones = ["piedra", "papel", "tijera", "lagarto", "spock"]

diccionario = {
    "tijera": ["papel", "lagarto"],
    "papel": ["piedra", "spock"],
    "piedra": ["lagarto", "tijera"],
    "lagarto": ["spock", "papel"],
    "spock": ["tijera", "piedra"]
}

def vencedor(usuario, maquina):
    if usuario == maquina:
        return 0
    elif maquina in diccionario[usuario]:
        return 1
    else:
        return -1

while True:
    while True:
        try:
            repeticiones = int(input("Indica el número de partidas (impar y >=1): "))
            if repeticiones < 1 or repeticiones % 2 == 0:
                print("El número debe ser mayor o igual a 1 y impar.")
                continue
            break
        except ValueError:
            print("Error: debes introducir un número entero válido.")

    puntos_usuario = 0
    puntos_maquina = 0

    for i in range(1, repeticiones + 1):
        print(f"\nPartida {i} de {repeticiones}")

        while True:
            usuario = input("Elige piedra, papel, tijera, lagarto o spock: ").lower()
            if usuario in opciones:
                break
            print("Opción no válida, inténtalo de nuevo.")

        maquina = random.choice(opciones)
        print(f"La máquina eligió: {maquina}")
        print(f"El usuario eligió: {usuario}")

        resultado = vencedor(usuario, maquina)
        if resultado == -1:
            print("Has perdido.")
            puntos_maquina += 1
        elif resultado == 1:
            print("Has ganado.")
            puntos_usuario += 1
        else:
            print("Has empatado.")

    print(f"\nMarcador final: Usuario {puntos_usuario} - Máquina {puntos_maquina}")

    repetir = input("\n¿Quieres jugar otra vez? (y/n): ").lower()
    if repetir != "y":
        print("Fin del juego")
        break

