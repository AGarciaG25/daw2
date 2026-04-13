
# EXAMEN PRÁCTICO

---

# INSTRUCCIONES GENERALES

Se te entrega una API REST funcional desarrollada con Django REST Framework para la gestión de cursos.

El proyecto ya incluye:

* Modelos con relaciones (Curso, Estudiante, Inscripción, etc.)
* Serializadores
* ViewSets registrados mediante router
* Autenticación mediante JWT
* Acciones de negocio ya implementadas

Tu tarea consiste en:

1. Ampliar la API con un sistema de valoraciones.
2. Integrar correctamente esta nueva funcionalidad.
3. Implementar una nueva acción de negocio.
4. Detectar y corregir un fallo existente.
5. Demostrar el funcionamiento mediante capturas justificadas.

No se permite modificar la arquitectura general del proyecto.

---

# FORMATO DE ENTREGA

Debes entregar:

1. Proyecto completo comprimido.
2. Las capturas solicitadas, subidas individualmente a Classroom con el nombre indicado.

**Si no hay capturas o el nombre de la captura no coincide con el formato definido, ese apartado no se corrige.**

En las capturas de Postman debe verse claramente:

* URL
* Método
* Cabecera Authorization (cuando proceda)
* Body (si aplica)
* Status code
* Respuesta JSON

En las capturas de código debe verse el fragmento completo solicitado.

---

# EJERCICIO 1 – Modelo de Valoraciones (2 puntos)

## Se debe:

Crear un modelo `Valoracion` que:

* Se relacione con un curso.
* Se relacione con un estudiante.
* Incluya una puntuación numérica.
* Permita un comentario opcional.
* Registre la fecha automáticamente.
* No permita duplicados para el mismo estudiante y curso.
* Tenga ordenación descendente por fecha.

Aplicar las migraciones necesarias.

---

## Puntuación

* Modelo y relaciones correctas → 1 punto
* Restricción de unicidad correcta → 0,5 puntos
* Migración correcta → 0,5 puntos

---

## Evidencias obligatorias

E1_modelo.png
Modelo completo.

E1_migracion.png
Terminal mostrando los comandos ejecutados y sin errores.

---

# EJERCICIO 2 – Integración en el panel de administración (1 punto)

## Se debe:

* Registrar el modelo.
* Configurar `list_display` con información útil.
* Comprobar que se puede crear una valoración desde el admin.

---

## Puntuación

* Registro correcto → 0,5 puntos
* Configuración coherente del listado → 0,5 puntos

---

## Evidencia obligatoria

E2_admin.png
Captura donde se vea el listado y el formulario.


---

# EJERCICIO 3 – Serializer y validación (2 puntos)

## Se debe:

* Crear el serializer para `Valoracion`.
* Permitir creación mediante IDs.
* Validar que la puntuación esté entre 0 y 5.
* Gestionar correctamente errores.

---

## Puntuación

* Serializer funcional → 1 punto
* Validación correcta → 0,5 puntos
* Representación adecuada en lectura → 0,5 puntos

---

## Evidencias obligatorias

E3_post_ok.png
POST correcto con status 201.

E3_post_error.png
POST con puntuación inválida mostrando status 400.



---

# EJERCICIO 4 – ViewSet y filtro por curso (1,5 puntos)

## Se debe:

* Crear el ViewSet.
* Registrarlo en el router.
* Permitir filtrar por curso mediante query parameter.
* Configurar permisos razonables (por ejemplo, lectura pública y escritura autenticada).

---

## Puntuación

* ViewSet funcional → 0,75 puntos
* Filtro funcionando correctamente → 0,75 puntos

---

## Evidencias obligatorias

E4_sin_filtro.png
GET general

E5_filtro.png
GET filtrado por curso

---

# EJERCICIO 5 – Acción de negocio: cambiar estado de un curso (2 puntos)

## Se debe:

Implementar una acción personalizada en `CursoViewSet`:

POST /cursos/{id}/cambiar_estado/

La acción debe:

* Requerir autenticación.
* Invertir el valor del campo `activo`.
* Guardar el cambio en la base de datos.
* Devolver el nuevo estado.
* Usar códigos HTTP coherentes.

---

## Puntuación

* Uso correcto de `@action` y estructura → 1 punto
* Cambio persistente del estado → 0,5 puntos
* Respuesta y códigos HTTP adecuados → 0,5 puntos

---

## Evidencias obligatorias

E5_sin_token.png
Intento sin autenticación → 401.

E5_cambio_correcto.png
POST con token → 200 mostrando nuevo estado.

E5_comprobacion_get.png
GET posterior mostrando el valor actualizado.


---

# EJERCICIO 6 – Corrección de fallo en ViewSet Curso (1,5 puntos)

Uno de los endpoints del ViewSet Curso devuelve información incompleta.

## Se debe:

1. Detectar qué endpoint no devuelve todos los datos esperados.
2. Identificar el error en el código.
3. Corregirlo.
4. Verificar el resultado.

---

## Puntuación

* Identificación correcta → 0,5 puntos
* Localización del error → 0,5 puntos
* Corrección funcional → 0,5 puntos

---

## Evidencias obligatorias

E6_antes.png
Información mostrada antes de la corrección
E6_después.png
Información mostrada después de la corrección

# Capturas finales

Haz capturas de todos los archivos que has modificado en el proyecto con el formato:

CF_settings.png

...

---

# RESUMEN FINAL

| Ejercicio             | Puntos        |
| --------------------- | ------------- |
| Modelo Valoracion     | 2             |
| Admin                 | 1             |
| Serializer            | 2             |
| ViewSet + filtro      | 1,5           |
| Acción cambiar estado | 2             |
| Corrección de bug     | 1,5           |
| **TOTAL**             | **10 puntos** |

---
