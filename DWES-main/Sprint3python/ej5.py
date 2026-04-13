class Tarea:
    def __init__(self, titulo, descripcion):
        self.titulo = titulo
        self.descripcion = descripcion
        self.completada = False

    def get_titulo(self):
        return self.titulo

    def get_descripcion(self):
        return self.descripcion

    def get_completada(self):
        return self.completada

    def set_titulo(self, titulo):
        self.titulo = titulo

    def set_descripcion(self, descripcion):
        self.descripcion = descripcion

    def set_completada(self, completada):
        self.completada = completada

    def mostrar_info(self):
        if self.completada:
            estado = "Completada"
        else:
            estado = "Pendiente"
        print(f"El título es: {self.titulo} estando {estado}")

    def marcar_completada(self):
        self.completada = True
        print("Tarea completada")

    def editar(self, nuevo_titulo, nueva_descripcion):
        self.titulo = nuevo_titulo
        self.descripcion = nueva_descripcion
        print("Se ha modificado la tarea")


def eliminar_tarea(tareas):
    while True:
        titulo = input("Ingrese título de la tarea a eliminar: ").lower().strip()
        if titulo != "":
            break
    for t in tareas:
        if t.get_titulo() == titulo:
            tareas.remove(t)
            print("Tarea eliminada correctamente")
            break
    else:
        print("No se ha encontrado la tarea")


def editar_tarea(tareas):
    while True:
        titulo = input("Ingrese título de la tarea a modificar: ").lower().strip()
        if titulo != "":
            break
    for t in tareas:
        if t.get_titulo() == titulo:
            while True:
                nuevo_titulo = input("Ingrese nuevo título: ").lower().strip()
                if nuevo_titulo != "":
                    break
            while True:
                nueva_descripcion = input("Ingrese nueva descripción: ").lower().strip()
                if nueva_descripcion != "":
                    break
            t.editar(nuevo_titulo, nueva_descripcion)
            break
    else:
        print("No se ha encontrado la tarea")


def completada(tareas):
    while True:
        titulo = input("Ingrese tu título: ").lower().strip()
        if titulo != "":
            break
    for t in tareas:
        if t.get_titulo() == titulo:
            t.marcar_completada()
            break
    else:
        print("No se ha encontrado la tarea")


def mostrar_tareas(tareas):
    if len(tareas) == 0:
        print("No hay tareas en la base de datos")
    else:
        for t in tareas:
            t.mostrar_info()


def crear_tarea(tareas):
    while True:
        titulo = input("Ingrese tu título: ").lower().strip()
        if titulo != "":
            break
    while True:
        descripcion = input("Ingrese tu descripción: ").lower().strip()
        if descripcion != "":
            break
    nueva = Tarea(titulo, descripcion)
    tareas.append(nueva)
    print("Tarea creada correctamente.")


def menu_principal():
    print("\nMenú principal")
    print("1. Crear tarea")
    print("2. Mostrar todas")
    print("3. Marcar como completada")
    print("4. Editar tarea")
    print("5. Eliminar tarea")
    print("6. Salir")


def main():
    tareas = []
    while True:
        menu_principal()
        while True:
            try:
                opcion = int(input("Indica opción (1 a 6): "))
                if 1 <= opcion <= 6:
                    break
                else:
                    print("Número fuera de rango. Intenta de nuevo.")
            except ValueError:
                print("Error: debes introducir un número entero.")

        if opcion == 1:
            crear_tarea(tareas)
        elif opcion == 2:
            mostrar_tareas(tareas)
        elif opcion == 3:
            completada(tareas)
        elif opcion == 4:
            editar_tarea(tareas)
        elif opcion == 5:
            eliminar_tarea(tareas)
        else:
            print("Saliendo del programa...")
            break

if __name__ == "__main__":
    main()


