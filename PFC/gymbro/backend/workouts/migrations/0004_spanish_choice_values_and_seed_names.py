from django.db import migrations, models
from django.utils.text import slugify


EXERCISE_NAME_MAP = {
    '3/4 Sit Up': 'Abdominal parcial 3/4',
    '90/90 Hamstring': 'Estiramiento de isquios 90/90',
    'Ab Crunch Machine': 'Crunch en maquina abdominal',
    'Ab Roller': 'Rueda abdominal',
    'Adductor': 'Aductor',
    'Adductor/Groin': 'Aductor e ingle',
    'Advanced Kettlebell Windmill': 'Molino avanzado con kettlebell',
    'Air Bike': 'Bicicleta abdominal',
    'All Fours Quad Stretch': 'Estiramiento de cuadriceps a cuatro apoyos',
    'Alternate Hammer Curl': 'Curl martillo alterno',
    'Alternate Heel Touchers': 'Toques alternos de talon',
    'Alternate Incline Dumbbell Curl': 'Curl inclinado alterno con mancuernas',
    'Alternate Leg Diagonal Bound': 'Salto diagonal alterno de pierna',
    'Alternating Cable Shoulder Press': 'Press alterno de hombro en polea',
    'Alternating Deltoid Raise': 'Elevacion alterna de deltoides',
    'Alternating Floor Press': 'Press alterno en el suelo',
    'Alternating Hang Clean': 'Cargada colgante alterna',
    'Alternating Kettlebell Press': 'Press alterno con kettlebell',
    'Alternating Kettlebell Row': 'Remo alterno con kettlebell',
    'Alternating Renegade Row': 'Remo renegado alterno',
    'Ankle Circles': 'Circulos de tobillo',
    'Ankle On The Knee': 'Tobillo sobre rodilla',
    'Anterior Tibialis Smr': 'Liberacion miofascial del tibial anterior',
    'Anti Gravity Press': 'Press antigravedad',
    'Arm Circles': 'Circulos de brazos',
    'Arnold Dumbbell Press': 'Press Arnold con mancuernas',
    'Around The Worlds': 'Alrededor del mundo',
    'Atlas Stone Trainer': 'Entrenador de piedra Atlas',
    'Atlas Stones': 'Piedras Atlas',
    'Axle Deadlift': 'Peso muerto con barra gruesa',
    'Back Flyes With Bands': 'Aperturas posteriores con bandas',
    'Backward Drag': 'Arrastre hacia atras',
    'Backward Medicine Ball Throw': 'Lanzamiento hacia atras con balon medicinal',
    'Balance Board': 'Tabla de equilibrio',
    'Ball Leg Curl': 'Curl femoral con fitball',
    'Band Assisted Pull Up': 'Dominada asistida con banda',
    'Band Good Morning': 'Buenos dias con banda',
    'Band Good Morning (Pull Through)': 'Buenos dias con banda tipo pull through',
    'Band Hip Adductions': 'Aducciones de cadera con banda',
    'Band Pull Apart': 'Separacion de banda',
    'Band Skull Crusher': 'Extension de triceps con banda',
    'Barbell Ab Rollout': 'Rueda abdominal con barra',
    'Barbell Incline Press': 'Press inclinado con barra',
}

MUSCLE_NAME_MAP = {
    'Abdominals': 'Abdominales',
    'Abductors': 'Abductores',
    'Adductors': 'Aductores',
    'Lats': 'Dorsales',
    'Lower Back': 'Lumbar',
    'Middle Back': 'Espalda media',
    'Traps': 'Trapecios',
}

DISPLAY_VALUE_MAP = {
    'Bands': 'Bandas',
    'Body Only': 'Peso corporal',
    'Cable': 'Polea',
    'Exercise Ball': 'Fitball',
    'Foam Roll': 'Rodillo de espuma',
    'Kettlebells': 'Pesas rusas',
    'Machine': 'Maquina',
    'Medicine Ball': 'Balon medicinal',
    'None': 'Sin material',
    'Other': 'Accesorio',
}

MUSCLE_REGION_MAP = {
    'Abdominales': 'core',
    'Abductores': 'tren_inferior',
    'Aductores': 'tren_inferior',
    'Antebrazos': 'tren_superior',
    'Biceps': 'tren_superior',
    'Core': 'core',
    'Cuadriceps': 'tren_inferior',
    'Dorsales': 'tren_superior',
    'Espalda': 'tren_superior',
    'Espalda media': 'tren_superior',
    'Gemelos': 'tren_inferior',
    'Gluteos': 'tren_inferior',
    'Hombros': 'tren_superior',
    'Isquiotibiales': 'tren_inferior',
    'Lumbar': 'core',
    'Pecho': 'tren_superior',
    'Trapecios': 'tren_superior',
    'Triceps': 'tren_superior',
}


def rebuild_slugs(model):
    used = set()
    for obj in model.objects.order_by('id'):
        base_slug = slugify(obj.name) or f'item-{obj.pk}'
        slug = base_slug
        suffix = 2
        while slug in used or model.objects.exclude(pk=obj.pk).filter(slug=slug).exists():
            slug = f'{base_slug}-{suffix}'
            suffix += 1
        used.add(slug)
        model.objects.filter(pk=obj.pk).update(slug=slug)


def forwards(apps, schema_editor):
    Exercise = apps.get_model('workouts', 'Exercise')
    ExerciseMuscleTarget = apps.get_model('workouts', 'ExerciseMuscleTarget')
    ExerciseVariation = apps.get_model('workouts', 'ExerciseVariation')
    MuscleGroup = apps.get_model('workouts', 'MuscleGroup')
    WorkoutPlan = apps.get_model('workouts', 'WorkoutPlan')

    for old, new in EXERCISE_NAME_MAP.items():
        Exercise.objects.filter(name=old).update(name=new)

    for old, new in MUSCLE_NAME_MAP.items():
        MuscleGroup.objects.filter(name=old).update(name=new)

    for old, new in DISPLAY_VALUE_MAP.items():
        Exercise.objects.filter(equipment=old).update(equipment=new)
        Exercise.objects.filter(body_part=old).update(body_part=new)

    Exercise.objects.filter(difficulty='beginner').update(difficulty='principiante')
    Exercise.objects.filter(difficulty='intermediate').update(difficulty='intermedio')
    Exercise.objects.filter(difficulty='advanced').update(difficulty='avanzado')
    WorkoutPlan.objects.filter(difficulty='beginner').update(difficulty='principiante')
    WorkoutPlan.objects.filter(difficulty='intermediate').update(difficulty='intermedio')
    WorkoutPlan.objects.filter(difficulty='advanced').update(difficulty='avanzado')

    MuscleGroup.objects.filter(body_region='upper_body').update(body_region='tren_superior')
    MuscleGroup.objects.filter(body_region='lower_body').update(body_region='tren_inferior')
    MuscleGroup.objects.filter(body_region='full_body').update(body_region='cuerpo_completo')

    for name, region in MUSCLE_REGION_MAP.items():
        MuscleGroup.objects.filter(name=name).update(body_region=region)

    ExerciseMuscleTarget.objects.filter(emphasis='primary').update(emphasis='principal')
    ExerciseMuscleTarget.objects.filter(emphasis='secondary').update(emphasis='secundario')
    ExerciseMuscleTarget.objects.filter(emphasis='stabilizer').update(emphasis='estabilizador')

    rebuild_slugs(Exercise)
    rebuild_slugs(ExerciseVariation)
    rebuild_slugs(MuscleGroup)
    rebuild_slugs(WorkoutPlan)


class Migration(migrations.Migration):

    dependencies = [
        ('workouts', '0003_exercise_demo_frame_paths_alter_exercise_external_id'),
    ]

    operations = [
        migrations.RunPython(forwards, migrations.RunPython.noop),
        migrations.AlterField(
            model_name='exercise',
            name='difficulty',
            field=models.CharField(choices=[('principiante', 'Principiante'), ('intermedio', 'Intermedio'), ('avanzado', 'Avanzado')], default='principiante', max_length=20),
        ),
        migrations.AlterField(
            model_name='exercisemuscletarget',
            name='emphasis',
            field=models.CharField(choices=[('principal', 'Principal'), ('secundario', 'Secundario'), ('estabilizador', 'Estabilizador')], default='principal', max_length=20),
        ),
        migrations.AlterField(
            model_name='musclegroup',
            name='body_region',
            field=models.CharField(choices=[('tren_superior', 'Tren superior'), ('tren_inferior', 'Tren inferior'), ('core', 'Core'), ('cuerpo_completo', 'Cuerpo completo')], default='tren_superior', max_length=20),
        ),
        migrations.AlterField(
            model_name='workoutplan',
            name='difficulty',
            field=models.CharField(choices=[('principiante', 'Principiante'), ('intermedio', 'Intermedio'), ('avanzado', 'Avanzado')], default='principiante', max_length=20),
        ),
    ]
