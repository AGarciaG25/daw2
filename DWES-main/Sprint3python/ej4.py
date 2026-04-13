def añadir(lista_compra):
    newproducto = input("Introduzca el producto.").lower().strip()
    if (newproducto in lista_compra):

        print(f"El producto {newproducto} ya existe")
    else:
        lista_compra.append(newproducto)
        print(f"Se ha añadido {newproducto} a la lista")

def eliminar(lista_compra):
    newproducto = input("Introduzca el producto.").lower().strip()
    if (newproducto in lista_compra):
        lista_compra.remove(newproducto)
        print(f"El producto {newproducto} ha sido eliminado")
    else:
        print(f"El producto {newproducto} no existe")

def ver (lista_compra):
    if (len(lista_compra) == 0):
        print("No hay elementos en la lista.")
    else:
        lista_compra.sort()
        for producto in lista_compra:
            print(producto)

def vaciar(lista_compra):
    if (len(lista_compra) == 0):
        print("No hay elementos en la lista.")
    else:
        while True:
            conf = input("¿Seguro que pieres eliminarla? (s/n).").lower().strip()
            if conf == "n":
                print("Has cancelado la elimincación.")
                break
            elif conf == "s":
                lista_compra.clear()
                print("La lista ha sido vaciada.")
                break
            else:
                print("Respuesta incorrecta.")

def main():
    lista_compra = []
    while True:
        print("\n=== MENÚ PRINCIPAL ===")
        print("1.Añadir producto.")
        print("2.Eliminar producto.")
        print("3.Ver lista.")
        print("4.Vaciar lista.")
        print("5.Sair.")

        try:
            opcion = int(input("Indica opción (1 a 4): "))
        except ValueError:
            print("Error: debes introducir un número entero.")
            continue

        if opcion == 1:
            añadir(lista_compra)
        elif opcion == 2:
            eliminar(lista_compra)
        elif opcion == 3:
            ver(lista_compra)
        elif opcion == 4:
            vaciar(lista_compra)
        elif opcion == 5:
            print("Hasta pronto.")
            break
        else:
            print("Número no válido. Intente nuevamente.")

main()