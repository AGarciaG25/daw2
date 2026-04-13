
## Convenciones de nombres en PHP

### 1. Variables

- **Estándar**: usa *snake_case* para nombrar variables (por ejemplo, `$nombre_usuario`).
- **Concisión y claridad**: utiliza nombres descriptivos que indiquen claramente el propósito de la variable.
- **Evita abreviaturas ambiguas**: usa abreviaturas solo si son ampliamente reconocibles y no crean confusión (por ejemplo, `$id_usuario` en lugar de `$idu`).
- **Contexto y alcance**: en variables de ámbito global, considera prefijos o sufijos que den contexto, especialmente en proyectos grandes.

#### Ejemplo de variables bien nombradas:

```php
$nombre_usuario = "Juan";      // Claro y fácil de entender
$total_precio = 150.50;        // Uso de snake_case para legibilidad
$es_autenticado = true;        // Prefijo "es" para indicar una variable booleana
```

### 2. Funciones

- **Estándar**: usa *camelCase* para nombrar funciones (por ejemplo, `calcularTotal()`).
- **Verbos descriptivos**: inicia los nombres de funciones con un verbo que describa lo que hace (por ejemplo, `obtenerUsuario`, `crearPedido`, `validarEntrada`).
- **Evita prefijos innecesarios**: en lugar de prefijos como `get` o `set`, opta por nombres descriptivos que indiquen el propósito de la función.
- **Claridad sobre el ámbito**: si una función está destinada a usarse en un módulo o clase específica, utiliza nombres que aclaren su contexto.

#### Ejemplo de funciones bien nombradas:

```php
function calcularTotal($precio, $impuesto) {
    return $precio + ($precio * $impuesto);
}

function obtenerUsuarioPorId($id) {
    // Devuelve el usuario con el ID proporcionado
}

function validarDatosFormulario($datos) {
    // Valida los datos recibidos de un formulario
}
```

### 3. Archivos

- **Estándar**: usa *snake_case* en minúsculas para nombrar archivos, como `formulario_registro.php`.
- **Nombres que reflejen su contenido**: el nombre del archivo debe reflejar claramente su propósito o contenido (por ejemplo, `controlador_usuario.php`, `modelo_producto.php`).
- **Uso de prefijos o sufijos si es necesario**: en estructuras MVC (Modelo-Vista-Controlador), se recomienda agregar prefijos o sufijos como `modelo`, `vista` o `controlador` para distinguir el tipo de archivo.
- **Evita nombres genéricos**: nombres como `funciones.php` o `datos.php` son ambiguos. Es preferible `funciones_usuario.php` o `datos_producto.php`, según corresponda.

#### Ejemplo de nombres de archivo bien estructurados:

- `registro_usuario.php` para un archivo que gestiona el registro de usuarios.
- `controlador_carrito.php` para un archivo que controla la lógica del carrito de compras.
- `vista_detalles_producto.php` para un archivo que muestra la vista de detalles de un producto.
- `modelo_cliente.php` para un archivo que maneja la lógica del modelo de clientes.

### 4. Clases

- **Estándar**: usa *PascalCase* para nombrar clases, donde cada palabra comienza con mayúscula (por ejemplo, `UsuarioController`, `ProductoModel`).
- **Nombres descriptivos**: el nombre de la clase debe representar de manera clara el propósito del objeto o entidad que maneja.
- **Prefijos y sufijos para tipos específicos**: en arquitecturas MVC, considera usar `Controller` o `Model` como sufijo para indicar el propósito de la clase (por ejemplo, `ProductoController` para un controlador de producto y `ProductoModel` para el modelo).

#### Ejemplo de clases bien nombradas:

```php
class UsuarioController {
    // Controlador para gestionar la lógica de usuario
}

class ProductoModel {
    // Modelo que representa la entidad de producto
}

class Carrito {
    // Clase que maneja la lógica del carrito de compras
}
```

### 5. Constantes

- **Estándar**: usa *mayúsculas* y *snake_case* para las constantes globales (por ejemplo, `PI`, `TASA_IVA`).
- **Uso en ámbito global**: limita las constantes globales a aquellas que sean realmente de uso común en varias partes de la aplicación. Si son específicas de una clase, usa `const` dentro de la clase y nómbralas en mayúsculas también.
- **Nombres descriptivos y concisos**: el nombre de la constante debe describir su propósito sin ser excesivamente largo.

#### Ejemplo de constantes bien nombradas:

```php
define("TASA_IVA", 0.21);           // Constante global para IVA
define("LONGITUD_MAXIMA", 255);      // Longitud máxima permitida

class Configuracion {
    const VERSION = '1.0.0';         // Constante de clase para la versión de configuración
    const NOMBRE_SITIO = 'Mi Sitio'; // Constante de clase para el nombre del sitio
}
```

### 6. Buenas prácticas generales para nombres en PHP

- **Mantén la coherencia**: sigue el mismo estilo en todo el proyecto. Si decides usar `snake_case` para variables y `camelCase` para funciones, mantén esa estructura en todos los archivos.
- **Evita abreviaturas y siglas poco comunes**: solo usa abreviaturas o acrónimos si son amplias y comúnmente entendidas.
- **Longitud adecuada**: los nombres deben ser descriptivos pero no excesivamente largos. Prefiere nombres que sean claros sin añadir información innecesaria.
- **Contexto en nombres**: si un nombre puede ser ambiguo, añade contexto. Por ejemplo, en un sistema de gestión de empleados, `nombre_empleado` es mejor que solo `nombre`.

---
