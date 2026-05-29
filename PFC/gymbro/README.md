# GymBro

GymBro es una aplicacion de gimnasio con frontend en React y backend en Django REST Framework. Permite consultar ejercicios, filtrar por zonas musculares, crear rutinas de entrenamiento, guardar sesiones y gestionar el perfil del usuario.

## Requisitos

Antes de instalar el proyecto es necesario tener:

- Python 3.12
- Node.js y npm
- Git

## Estructura del proyecto

```text
gymbro/
├── backend/              # API REST Django
│   ├── config/           # Configuracion principal de Django
│   ├── data/             # Datos importables del proyecto
│   ├── workouts/         # App principal: modelos, vistas, serializers y comandos
│   ├── manage.py
│   └── requirements.txt
├── public/               # Recursos publicos del frontend
├── src/                  # Aplicacion React
├── package.json
└── README.md
```

## Instalacion desde cero

Clonar el repositorio y entrar en la carpeta del proyecto:

```powershell
git clone https://github.com/AGarciaG25/daw2.git
cd daw2\PFC\gymbro
```

## Backend Django

Entrar en la carpeta del backend:

```powershell
cd backend
```

Crear el entorno virtual:

```powershell
python -m venv venv
```

Instalar las dependencias:

```powershell
.\venv\Scripts\python.exe -m pip install --upgrade pip
.\venv\Scripts\python.exe -m pip install -r requirements.txt
```

Crear la base de datos y aplicar migraciones:

```powershell
.\venv\Scripts\python.exe manage.py migrate
```

Cargar datos iniciales de ejemplo:

```powershell
.\venv\Scripts\python.exe manage.py seed_workouts
```

Opcionalmente, para importar el dataset completo incluido en el proyecto:

```powershell
.\venv\Scripts\python.exe manage.py import_sample_set .\data\free-exercise-db.json
```

Arrancar el backend:

```powershell
.\venv\Scripts\python.exe manage.py runserver
```

El backend queda disponible en:

```text
http://127.0.0.1:8000/
```

## Frontend React

En otra terminal, desde la raiz del proyecto `gymbro/`, instalar dependencias:

```powershell
npm install
```

Arrancar el frontend:

```powershell
npm run dev
```

Vite mostrara una URL similar a:

```text
http://127.0.0.1:5173/
```

## Base de datos

El proyecto utiliza SQLite durante el desarrollo. La base de datos local se genera automaticamente en:

```text
backend/db.sqlite3
```

Ese archivo no se sube al repositorio porque es un archivo generado. Para reconstruir la base de datos desde cero hay que ejecutar:

```powershell
cd backend
.\venv\Scripts\python.exe manage.py migrate
.\venv\Scripts\python.exe manage.py seed_workouts
```

No hay que restaurar ningun archivo `.sql` externo. Los datos iniciales se cargan mediante los comandos de Django y el archivo:

```text
backend/data/free-exercise-db.json
```

## Documentacion de la API

El proyecto incluye documentacion OpenAPI con Swagger UI.

Con el backend arrancado:

```text
http://127.0.0.1:8000/api/docs/
```

El schema OpenAPI esta disponible en:

```text
http://127.0.0.1:8000/api/schema/
```

La autenticacion se realiza con token. En las peticiones protegidas se usa la cabecera:

```text
Authorization: Token <token>
```

## Endpoints principales

```text
POST /api/register/
POST /api/login/
GET  /api/profile/
PATCH /api/profile/
POST /api/profile/password/
GET  /api/muscle-groups/
GET  /api/exercises/
GET  /api/exercises/?muscle_group=pecho
GET  /api/variations/?exercise=press-banca
GET  /api/workout-plans/
POST /api/workout-plans/
GET  /api/workout-sessions/
```

## Comprobaciones

Comprobar backend:

```powershell
cd backend
.\venv\Scripts\python.exe manage.py check
```

Comprobar frontend:

```powershell
npm run build
```

## Archivos que no se suben al repositorio

Estos archivos se generan localmente y no son necesarios para entregar el proyecto:

```text
backend/venv/
node_modules/
dist/
backend/db.sqlite3
*.rar
```

Para una instalacion limpia solo son necesarios el codigo fuente, `backend/requirements.txt`, `package.json`, `package-lock.json`, las migraciones de Django y los datos incluidos en `backend/data/`.
