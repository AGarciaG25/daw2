# GymBro

Proyecto para una app de gimnasio con frontend en React y backend en Django REST.

## Backend Django

La API se ha preparado en `backend/` con estos recursos:

- zonas musculares
- ejercicios
- variaciones de ejercicio
- tablas o rutinas de ejercicios

### Modelo de datos

- `MuscleGroup`: zona muscular como pecho, espalda, cuadriceps o core.
- `Exercise`: ejercicio principal con descripcion, dificultad, material y musculos trabajados.
- `ExerciseVariation`: variaciones de un ejercicio base.
- `WorkoutPlan`: tabla o rutina de entrenamiento.
- `WorkoutPlanItem`: ejercicios concretos dentro de una tabla.

### Puesta en marcha

```bash
cd backend
python -m pip install -r requirements.txt
python manage.py migrate
python manage.py seed_workouts
python manage.py runserver
```

### Endpoints principales

- `GET /api/muscle-groups/`
- `GET /api/exercises/`
- `GET /api/exercises/?muscle_group=pecho`
- `GET /api/variations/?exercise=press-banca`
- `GET /api/workout-plans/`

La API tambien permite crear y editar recursos con `POST`, `PUT`, `PATCH` y `DELETE`.

## Frontend React

El frontend actual sigue disponible en la raiz del proyecto:

```bash
npm install
npm run dev
```
