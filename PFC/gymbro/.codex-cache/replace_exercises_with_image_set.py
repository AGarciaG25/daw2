from pathlib import Path
from shutil import copy2

from django.db import transaction
from django.utils.text import slugify

from workouts.models import Exercise, ExerciseMuscleTarget, ExerciseVariation, MuscleGroup


BASE_DIR = Path(__file__).resolve().parent
while BASE_DIR.name != 'gymbro' and BASE_DIR.parent != BASE_DIR:
    BASE_DIR = BASE_DIR.parent
PUBLIC_IMAGE_DIR = BASE_DIR / 'public' / 'exercise-images'


EXERCISES = [
    {
        'name': 'Plancha frontal',
        'source': r'D:\Descargas\ChatGPT Image 3 may 2026, 20_30_39 (1).png',
        'image': 'plancha-frontal.png',
        'description': 'Ejercicio isometrico de core manteniendo el cuerpo alineado sobre antebrazos y puntas de los pies.',
        'instructions': (
            'Apoya antebrazos y pies en el suelo.\n'
            'Mantén hombros, cadera y tobillos en linea.\n'
            'Contrae abdomen y gluteos sin hundir la zona lumbar.'
        ),
        'equipment': 'Esterilla',
        'body_part': 'Core',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [
            ('Abdominales', MuscleGroup.BodyRegion.CORE, ExerciseMuscleTarget.Emphasis.PRIMARY),
            ('Hombros', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY),
        ],
    },
    {
        'name': 'Elevacion de gemelos de pie en maquina',
        'source': r'D:\Descargas\ChatGPT Image 3 may 2026, 20_30_41 (2).png',
        'image': 'elevacion-gemelos-pie-maquina.png',
        'description': 'Elevacion de talones en maquina para trabajar principalmente los gemelos.',
        'instructions': (
            'Coloca la parte delantera de los pies sobre la plataforma.\n'
            'Eleva los talones hasta contraer los gemelos.\n'
            'Desciende de forma controlada sin rebotar.'
        ),
        'equipment': 'Maquina de gemelos',
        'body_part': 'Pierna',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [
            ('Gemelos', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY),
        ],
    },
    {
        'name': 'Abduccion de cadera en maquina',
        'source': r'D:\Descargas\ChatGPT Image 3 may 2026, 20_30_42 (3).png',
        'image': 'abduccion-cadera-maquina.png',
        'description': 'Movimiento de apertura de piernas en maquina para enfatizar gluteo medio y abductores.',
        'instructions': (
            'Siéntate con la espalda apoyada y las piernas contra los soportes.\n'
            'Abre las piernas empujando de forma controlada.\n'
            'Vuelve al centro manteniendo tension.'
        ),
        'equipment': 'Maquina de abductores',
        'body_part': 'Cadera',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [
            ('Abductores', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY),
            ('Gluteos', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY),
        ],
    },
    {
        'name': 'Aduccion de cadera en maquina',
        'source': r'D:\Descargas\ChatGPT Image 3 may 2026, 20_30_42 (4).png',
        'image': 'aduccion-cadera-maquina.png',
        'description': 'Movimiento de cierre de piernas en maquina para trabajar los aductores.',
        'instructions': (
            'Siéntate con la espalda apoyada y las piernas abiertas contra los soportes.\n'
            'Cierra las piernas hasta juntar los soportes.\n'
            'Regresa lentamente a la posicion inicial.'
        ),
        'equipment': 'Maquina de aductores',
        'body_part': 'Cadera',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [
            ('Aductores', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY),
        ],
    },
    {
        'name': 'Curl femoral tumbado en maquina',
        'source': r'D:\Descargas\ChatGPT Image 3 may 2026, 20_30_42 (5).png',
        'image': 'curl-femoral-tumbado-maquina.png',
        'description': 'Flexion de rodilla tumbado en maquina para trabajar los isquiotibiales.',
        'instructions': (
            'Túmbate boca abajo con los tobillos bajo el rodillo.\n'
            'Flexiona las rodillas llevando el rodillo hacia los gluteos.\n'
            'Baja controlando el peso.'
        ),
        'equipment': 'Maquina de curl femoral',
        'body_part': 'Pierna posterior',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [
            ('Isquiotibiales', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY),
        ],
    },
    {
        'name': 'Prensa de piernas',
        'source': r'D:\Descargas\ChatGPT Image 3 may 2026, 20_30_43 (6).png',
        'image': 'prensa-piernas.png',
        'description': 'Empuje de plataforma en prensa para trabajar cuadriceps, gluteos e isquiotibiales.',
        'instructions': (
            'Coloca los pies sobre la plataforma a una anchura comoda.\n'
            'Empuja extendiendo las piernas sin bloquear por completo las rodillas.\n'
            'Baja la plataforma con control.'
        ),
        'equipment': 'Prensa de piernas',
        'body_part': 'Piernas',
        'difficulty': Exercise.Difficulty.INTERMEDIATE,
        'is_compound': True,
        'targets': [
            ('Cuadriceps', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY),
            ('Gluteos', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY),
            ('Isquiotibiales', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY),
        ],
    },
    {
        'name': 'Peso muerto rumano con barra',
        'source': r'D:\Descargas\ChatGPT Image 3 may 2026, 20_30_43 (7).png',
        'image': 'peso-muerto-rumano-barra.png',
        'description': 'Bisagra de cadera con barra para enfatizar isquiotibiales, gluteos y zona lumbar.',
        'instructions': (
            'Sujeta la barra delante de los muslos.\n'
            'Lleva la cadera atras manteniendo la espalda neutra.\n'
            'Vuelve a subir extendiendo la cadera.'
        ),
        'equipment': 'Barra',
        'body_part': 'Cadena posterior',
        'difficulty': Exercise.Difficulty.INTERMEDIATE,
        'is_compound': True,
        'targets': [
            ('Isquiotibiales', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY),
            ('Gluteos', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY),
            ('Lumbar', MuscleGroup.BodyRegion.CORE, ExerciseMuscleTarget.Emphasis.SECONDARY),
        ],
    },
    {
        'name': 'Sentadilla con barra',
        'source': r'D:\Descargas\ChatGPT Image 3 may 2026, 20_30_43 (8).png',
        'image': 'sentadilla-con-barra.png',
        'description': 'Sentadilla trasera con barra para trabajar principalmente cuadriceps y gluteos.',
        'instructions': (
            'Coloca la barra sobre la parte alta de la espalda.\n'
            'Desciende flexionando cadera y rodillas con el torso estable.\n'
            'Empuja el suelo para volver a la posicion inicial.'
        ),
        'equipment': 'Barra y rack',
        'body_part': 'Piernas',
        'difficulty': Exercise.Difficulty.INTERMEDIATE,
        'is_compound': True,
        'targets': [
            ('Cuadriceps', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY),
            ('Gluteos', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY),
            ('Isquiotibiales', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY),
        ],
    },
]


def get_or_create_muscle(name, body_region):
    muscle, created = MuscleGroup.objects.get_or_create(
        name=name,
        defaults={
            'slug': slugify(name),
            'description': f'Grupo muscular: {name.lower()}.',
            'body_region': body_region,
        },
    )
    if not created and muscle.body_region != body_region:
        muscle.body_region = body_region
        muscle.save(update_fields=['body_region', 'updated_at'])
    return muscle


@transaction.atomic
def replace_exercises():
    PUBLIC_IMAGE_DIR.mkdir(parents=True, exist_ok=True)

    Exercise.objects.all().delete()
    ExerciseVariation.objects.all().delete()

    created = []
    for data in EXERCISES:
        source = Path(data['source'])
        if not source.exists():
            raise FileNotFoundError(f'No existe la imagen: {source}')

        copy2(source, PUBLIC_IMAGE_DIR / data['image'])

        exercise = Exercise.objects.create(
            name=data['name'],
            description=data['description'],
            instructions=data['instructions'],
            equipment=data['equipment'],
            body_part=data['body_part'],
            demo_gif_path=f'exercise-images/{data["image"]}',
            difficulty=data['difficulty'],
            is_compound=data['is_compound'],
        )

        for muscle_name, body_region, emphasis in data['targets']:
            muscle = get_or_create_muscle(muscle_name, body_region)
            ExerciseMuscleTarget.objects.create(
                exercise=exercise,
                muscle_group=muscle,
                emphasis=emphasis,
            )

        created.append(exercise.name)

    return created


created_names = replace_exercises()
print(f'Reemplazados ejercicios. Total: {len(created_names)}')
print('\n'.join(created_names))
