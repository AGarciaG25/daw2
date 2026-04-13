import random

while True:
    contador = 0
    dificultad = input("Seleccionar dificultad (facil, medio, dificil): ").lower()

    while dificultad not in ["facil", "medio", "dificil"]:
        dificultad = input("Seleccionar dificultad (facil, medio, dificil): ").lower()

    if dificultad == "facil":
        numbuscar = random.randint(1, 50)
    elif dificultad == "medio":
        numbuscar = random.randint(1, 100)
    else:
        numbuscar = random.randint(1, 500)

    numuser = int(input("Ingresa un número: "))
    contador += 1

    while numuser != numbuscar:
        if numuser < numbuscar:
            print("Demasiado bajo ⬇")
        else:
            print("Demasiado alto ⬆")

        numuser = int(input("Intenta de nuevo: "))
        contador += 1

    print(f"¡Felicidades! Adivinaste en {contador} intentos.")

    while True:
        repetir = input("¿Quieres jugar otra vez? (y/n): ").lower()
        if repetir in ["y", "n"]:
           break
    if repetir != "y":
        print("Gracias por jugar")
        break
