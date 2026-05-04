from pathlib import Path
from shutil import copy2
from zipfile import ZipFile

from django.db import transaction
from django.utils.text import slugify

from workouts.models import Exercise, ExerciseMuscleTarget, ExerciseVariation, MuscleGroup


BASE_DIR = Path(__file__).resolve().parent
while BASE_DIR.name != 'gymbro' and BASE_DIR.parent != BASE_DIR:
    BASE_DIR = BASE_DIR.parent

PUBLIC_IMAGE_DIR = BASE_DIR / 'public' / 'exercise-images'
ZIP_PATH = Path(r'D:\Descargas\imagenes_ejercicios_upper_body.zip')


def loose_source(filename):
    return Path(r'D:\Descargas') / filename


def zip_source(member):
    return {'zip_member': member}


EXERCISES = [
    {
        'name': 'Press banca',
        'source': zip_source('01_press_banca.png'),
        'image': 'press-banca.png',
        'description': 'Press horizontal con barra para trabajar principalmente el pecho.',
        'instructions': 'Tumbate en el banco, baja la barra al pecho con control y empuja hasta extender los brazos.',
        'equipment': 'Barra y banco',
        'body_part': 'Pecho',
        'difficulty': Exercise.Difficulty.INTERMEDIATE,
        'is_compound': True,
        'targets': [('Pectorales', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Triceps', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY), ('Hombros', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Press inclinado en maquina',
        'source': zip_source('02_press_inclinado_maquina.png'),
        'image': 'press-inclinado-maquina.png',
        'description': 'Press inclinado guiado para enfatizar la parte superior del pecho.',
        'instructions': 'Ajusta el asiento, empuja los agarres hacia delante y vuelve de forma controlada.',
        'equipment': 'Maquina de press inclinado',
        'body_part': 'Pecho',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': True,
        'targets': [('Pectorales', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Hombros', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY), ('Triceps', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Press militar en maquina',
        'source': zip_source('03_press_militar_maquina.png'),
        'image': 'press-militar-maquina.png',
        'description': 'Press vertical guiado para trabajar hombros y triceps.',
        'instructions': 'Siéntate con la espalda apoyada, empuja los agarres hacia arriba y baja sin perder control.',
        'equipment': 'Maquina de hombros',
        'body_part': 'Hombros',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': True,
        'targets': [('Hombros', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Triceps', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Aperturas en polea',
        'source': zip_source('04_aperturas_polea.png'),
        'image': 'aperturas-polea.png',
        'description': 'Aperturas con poleas para aislar el pecho manteniendo tension constante.',
        'instructions': 'Colocate entre poleas, junta las manos al frente con codos ligeramente flexionados y regresa lento.',
        'equipment': 'Poleas',
        'body_part': 'Pecho',
        'difficulty': Exercise.Difficulty.INTERMEDIATE,
        'is_compound': False,
        'targets': [('Pectorales', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Hombros', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Elevaciones laterales con mancuernas',
        'source': zip_source('05_elevaciones_laterales_mancuernas.png'),
        'image': 'elevaciones-laterales-mancuernas.png',
        'description': 'Elevacion lateral de brazos para enfatizar el deltoides medio.',
        'instructions': 'Eleva las mancuernas hacia los lados hasta la altura de los hombros y baja con control.',
        'equipment': 'Mancuernas',
        'body_part': 'Hombros',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [('Hombros', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY)],
    },
    {
        'name': 'Pajaro con mancuernas',
        'source': zip_source('06_pajaro.png'),
        'image': 'pajaro-mancuernas.png',
        'description': 'Apertura inclinada para trabajar deltoides posterior y parte alta de la espalda.',
        'instructions': 'Inclina el torso, abre los brazos hacia los lados y junta escapulas sin balancear.',
        'equipment': 'Mancuernas',
        'body_part': 'Hombros posteriores',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [('Hombros', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Espalda alta', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Extension de triceps en polea',
        'source': zip_source('07_triceps_polea.png'),
        'image': 'extension-triceps-polea.png',
        'description': 'Extension de codos en polea alta para aislar el triceps.',
        'instructions': 'Mantén los codos cerca del cuerpo, extiende hacia abajo y controla la subida.',
        'equipment': 'Polea',
        'body_part': 'Triceps',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [('Triceps', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY)],
    },
    {
        'name': 'Extension de triceps por encima de la cabeza',
        'source': zip_source('08_triceps_overhead.png'),
        'image': 'extension-triceps-overhead.png',
        'description': 'Extension de triceps sobre la cabeza para enfatizar la cabeza larga.',
        'instructions': 'Lleva el agarre sobre la cabeza, extiende los codos y vuelve lentamente.',
        'equipment': 'Polea',
        'body_part': 'Triceps',
        'difficulty': Exercise.Difficulty.INTERMEDIATE,
        'is_compound': False,
        'targets': [('Triceps', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY)],
    },
    {
        'name': 'Jalon al pecho',
        'source': zip_source('09_jalon_al_pecho.png'),
        'image': 'jalon-al-pecho.png',
        'description': 'Tiron vertical en polea para trabajar dorsales y espalda alta.',
        'instructions': 'Tira de la barra hacia la parte alta del pecho, lleva los codos abajo y controla la subida.',
        'equipment': 'Polea alta',
        'body_part': 'Espalda',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': True,
        'targets': [('Dorsales', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Biceps', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY), ('Espalda alta', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Remo con pecho apoyado',
        'source': zip_source('10_remo_pecho_apoyado.png'),
        'image': 'remo-pecho-apoyado.png',
        'description': 'Remo en banco o maquina con pecho apoyado para trabajar la espalda sin balanceo.',
        'instructions': 'Apoya el pecho, tira de los agarres hacia el torso y junta escapulas.',
        'equipment': 'Maquina de remo',
        'body_part': 'Espalda',
        'difficulty': Exercise.Difficulty.INTERMEDIATE,
        'is_compound': True,
        'targets': [('Dorsales', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Espalda alta', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY), ('Biceps', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Remo sentado',
        'source': zip_source('11_remo_sentado.png'),
        'image': 'remo-sentado.png',
        'description': 'Remo horizontal en polea para dorsales, espalda media y biceps.',
        'instructions': 'Tira del agarre hacia el abdomen manteniendo el torso estable y vuelve con control.',
        'equipment': 'Polea baja',
        'body_part': 'Espalda',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': True,
        'targets': [('Dorsales', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Espalda alta', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY), ('Biceps', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Pullover en polea',
        'source': zip_source('12_pullover_polea.png'),
        'image': 'pullover-polea.png',
        'description': 'Extension de hombro en polea para aislar dorsales.',
        'instructions': 'Con brazos casi extendidos, lleva la barra desde arriba hasta los muslos y controla la vuelta.',
        'equipment': 'Polea',
        'body_part': 'Espalda',
        'difficulty': Exercise.Difficulty.INTERMEDIATE,
        'is_compound': False,
        'targets': [('Dorsales', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY)],
    },
    {
        'name': 'Face pull',
        'source': zip_source('13_pullface.png'),
        'image': 'face-pull.png',
        'description': 'Tiron hacia la cara en polea para deltoides posterior y estabilidad escapular.',
        'instructions': 'Tira de la cuerda hacia la cara separando las manos y manteniendo codos altos.',
        'equipment': 'Polea con cuerda',
        'body_part': 'Hombros posteriores',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [('Hombros', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Espalda alta', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Encogimientos con mancuernas',
        'source': zip_source('14_trapecio_mancuernas.png'),
        'image': 'encogimientos-mancuernas.png',
        'description': 'Elevacion de hombros con mancuernas para trabajar trapecios.',
        'instructions': 'Sujeta las mancuernas a los lados, eleva los hombros hacia arriba y baja lentamente.',
        'equipment': 'Mancuernas',
        'body_part': 'Trapecios',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [('Trapecios', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY)],
    },
    {
        'name': 'Curl de biceps',
        'source': zip_source('15_curl_biceps.png'),
        'image': 'curl-biceps.png',
        'description': 'Flexion de codo para trabajar principalmente el biceps.',
        'instructions': 'Mantén los codos cerca del cuerpo, sube el peso sin balancear y baja controlado.',
        'equipment': 'Mancuernas',
        'body_part': 'Biceps',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [('Biceps', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY)],
    },
    {
        'name': 'Curl martillo con mancuernas',
        'source': zip_source('16_curl_martillo_mancuernas.png'),
        'image': 'curl-martillo-mancuernas.png',
        'description': 'Curl con agarre neutro para biceps, braquial y antebrazo.',
        'instructions': 'Sujeta las mancuernas con agarre neutro, flexiona los codos y baja con control.',
        'equipment': 'Mancuernas',
        'body_part': 'Biceps',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [('Biceps', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Antebrazos', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Sentadilla con barra',
        'source': loose_source('ChatGPT Image 3 may 2026, 20_30_39 (1).png'),
        'image': 'sentadilla-con-barra.png',
        'description': 'Sentadilla trasera con barra para trabajar principalmente cuadriceps y gluteos.',
        'instructions': 'Coloca la barra sobre la parte alta de la espalda, desciende con control y empuja el suelo para subir.',
        'equipment': 'Barra y rack',
        'body_part': 'Piernas',
        'difficulty': Exercise.Difficulty.INTERMEDIATE,
        'is_compound': True,
        'targets': [('Cuadriceps', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Gluteos', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY), ('Isquiotibiales', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Peso muerto rumano con barra',
        'source': loose_source('ChatGPT Image 3 may 2026, 20_30_41 (2).png'),
        'image': 'peso-muerto-rumano-barra.png',
        'description': 'Bisagra de cadera con barra para enfatizar isquiotibiales, gluteos y zona lumbar.',
        'instructions': 'Lleva la cadera atras con espalda neutra y vuelve a subir extendiendo la cadera.',
        'equipment': 'Barra',
        'body_part': 'Cadena posterior',
        'difficulty': Exercise.Difficulty.INTERMEDIATE,
        'is_compound': True,
        'targets': [('Isquiotibiales', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Gluteos', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY), ('Lumbar', MuscleGroup.BodyRegion.CORE, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Prensa de piernas',
        'source': loose_source('ChatGPT Image 3 may 2026, 20_30_42 (3).png'),
        'image': 'prensa-piernas.png',
        'description': 'Empuje de plataforma en prensa para trabajar cuadriceps, gluteos e isquiotibiales.',
        'instructions': 'Empuja la plataforma extendiendo las piernas sin bloquear rodillas y baja con control.',
        'equipment': 'Prensa de piernas',
        'body_part': 'Piernas',
        'difficulty': Exercise.Difficulty.INTERMEDIATE,
        'is_compound': True,
        'targets': [('Cuadriceps', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Gluteos', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY), ('Isquiotibiales', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Curl femoral tumbado en maquina',
        'source': loose_source('ChatGPT Image 3 may 2026, 20_30_42 (4).png'),
        'image': 'curl-femoral-tumbado-maquina.png',
        'description': 'Flexion de rodilla tumbado en maquina para trabajar los isquiotibiales.',
        'instructions': 'Flexiona las rodillas llevando el rodillo hacia los gluteos y baja controlando el peso.',
        'equipment': 'Maquina de curl femoral',
        'body_part': 'Pierna posterior',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [('Isquiotibiales', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY)],
    },
    {
        'name': 'Abduccion de cadera en maquina',
        'source': loose_source('ChatGPT Image 3 may 2026, 20_30_42 (5).png'),
        'image': 'abduccion-cadera-maquina.png',
        'description': 'Apertura de piernas en maquina para trabajar abductores y gluteo medio.',
        'instructions': 'Abre las piernas empujando los soportes hacia fuera y vuelve al centro con control.',
        'equipment': 'Maquina de abductores',
        'body_part': 'Cadera',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [('Abductores', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Gluteos', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
    {
        'name': 'Aduccion de cadera en maquina',
        'source': loose_source('ChatGPT Image 3 may 2026, 20_30_43 (6).png'),
        'image': 'aduccion-cadera-maquina.png',
        'description': 'Cierre de piernas en maquina para trabajar los aductores.',
        'instructions': 'Cierra las piernas contra la resistencia y regresa lentamente a la posicion inicial.',
        'equipment': 'Maquina de aductores',
        'body_part': 'Cadera',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [('Aductores', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY)],
    },
    {
        'name': 'Elevacion de gemelos de pie en maquina',
        'source': loose_source('ChatGPT Image 3 may 2026, 20_30_43 (7).png'),
        'image': 'elevacion-gemelos-pie-maquina.png',
        'description': 'Elevacion de talones en maquina para trabajar principalmente los gemelos.',
        'instructions': 'Eleva los talones hasta contraer los gemelos y desciende de forma controlada.',
        'equipment': 'Maquina de gemelos',
        'body_part': 'Pierna',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [('Gemelos', MuscleGroup.BodyRegion.LOWER_BODY, ExerciseMuscleTarget.Emphasis.PRIMARY)],
    },
    {
        'name': 'Plancha frontal',
        'source': loose_source('ChatGPT Image 3 may 2026, 20_30_43 (8).png'),
        'image': 'plancha-frontal.png',
        'description': 'Ejercicio isometrico de core manteniendo el cuerpo alineado sobre antebrazos y puntas de los pies.',
        'instructions': 'Apoya antebrazos y pies, mantén el abdomen contraido y evita hundir la zona lumbar.',
        'equipment': 'Esterilla',
        'body_part': 'Core',
        'difficulty': Exercise.Difficulty.BEGINNER,
        'is_compound': False,
        'targets': [('Abdominales', MuscleGroup.BodyRegion.CORE, ExerciseMuscleTarget.Emphasis.PRIMARY), ('Hombros', MuscleGroup.BodyRegion.UPPER_BODY, ExerciseMuscleTarget.Emphasis.SECONDARY)],
    },
]


def copy_image(source, destination_name):
    destination = PUBLIC_IMAGE_DIR / destination_name
    if isinstance(source, dict):
      member = source['zip_member']
      with ZipFile(ZIP_PATH) as archive:
          with archive.open(member) as src, destination.open('wb') as dst:
              dst.write(src.read())
    else:
      copy2(source, destination)


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
    if not ZIP_PATH.exists():
        raise FileNotFoundError(f'No existe el ZIP: {ZIP_PATH}')

    PUBLIC_IMAGE_DIR.mkdir(parents=True, exist_ok=True)
    Exercise.objects.all().delete()
    ExerciseVariation.objects.all().delete()

    created = []
    for data in EXERCISES:
        copy_image(data['source'], data['image'])

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
