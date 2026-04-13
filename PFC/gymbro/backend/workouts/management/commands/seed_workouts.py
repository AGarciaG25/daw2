from django.core.management.base import BaseCommand

from workouts.models import (
    Exercise,
    ExerciseMuscleTarget,
    ExerciseVariation,
    MuscleGroup,
    WorkoutPlan,
    WorkoutPlanItem,
)


class Command(BaseCommand):
    help = 'Carga datos de ejemplo para la API del gym.'

    def handle(self, *args, **options):
        muscle_groups = {
            'Pecho': MuscleGroup.objects.get_or_create(
                name='Pecho',
                defaults={
                    'description': 'Zona muscular del tren superior centrada en empujes.',
                    'body_region': MuscleGroup.BodyRegion.UPPER_BODY,
                },
            )[0],
            'Espalda': MuscleGroup.objects.get_or_create(
                name='Espalda',
                defaults={
                    'description': 'Grupo muscular principal de tiron.',
                    'body_region': MuscleGroup.BodyRegion.UPPER_BODY,
                },
            )[0],
            'Hombros': MuscleGroup.objects.get_or_create(
                name='Hombros',
                defaults={
                    'description': 'Deltoides anterior, medio y posterior.',
                    'body_region': MuscleGroup.BodyRegion.UPPER_BODY,
                },
            )[0],
            'Cuadriceps': MuscleGroup.objects.get_or_create(
                name='Cuadriceps',
                defaults={
                    'description': 'Zona frontal del muslo.',
                    'body_region': MuscleGroup.BodyRegion.LOWER_BODY,
                },
            )[0],
            'Gluteos': MuscleGroup.objects.get_or_create(
                name='Gluteos',
                defaults={
                    'description': 'Cadena posterior de la cadera.',
                    'body_region': MuscleGroup.BodyRegion.LOWER_BODY,
                },
            )[0],
            'Core': MuscleGroup.objects.get_or_create(
                name='Core',
                defaults={
                    'description': 'Zona media para estabilizacion.',
                    'body_region': MuscleGroup.BodyRegion.CORE,
                },
            )[0],
        }

        exercises = {
            'Press banca': Exercise.objects.get_or_create(
                name='Press banca',
                defaults={
                    'description': 'Ejercicio compuesto para desarrollar el pecho.',
                    'instructions': 'Activa escapulas y controla la bajada.',
                    'equipment': 'Barra y banco',
                    'difficulty': Exercise.Difficulty.INTERMEDIATE,
                    'is_compound': True,
                },
            )[0],
            'Sentadilla': Exercise.objects.get_or_create(
                name='Sentadilla',
                defaults={
                    'description': 'Patron basico para tren inferior.',
                    'instructions': 'Manten el tronco firme y las rodillas alineadas.',
                    'equipment': 'Barra o peso corporal',
                    'difficulty': Exercise.Difficulty.BEGINNER,
                    'is_compound': True,
                },
            )[0],
            'Plancha': Exercise.objects.get_or_create(
                name='Plancha',
                defaults={
                    'description': 'Ejercicio isometrico para el core.',
                    'instructions': 'Manten el cuerpo recto sin hundir la cadera.',
                    'equipment': 'Ninguno',
                    'difficulty': Exercise.Difficulty.BEGINNER,
                    'is_compound': False,
                },
            )[0],
        }

        targets = [
            ('Press banca', 'Pecho', ExerciseMuscleTarget.Emphasis.PRIMARY),
            ('Press banca', 'Hombros', ExerciseMuscleTarget.Emphasis.SECONDARY),
            ('Sentadilla', 'Cuadriceps', ExerciseMuscleTarget.Emphasis.PRIMARY),
            ('Sentadilla', 'Gluteos', ExerciseMuscleTarget.Emphasis.SECONDARY),
            ('Plancha', 'Core', ExerciseMuscleTarget.Emphasis.PRIMARY),
        ]

        for exercise_name, muscle_name, emphasis in targets:
            ExerciseMuscleTarget.objects.get_or_create(
                exercise=exercises[exercise_name],
                muscle_group=muscle_groups[muscle_name],
                defaults={'emphasis': emphasis},
            )

        incline_press = ExerciseVariation.objects.get_or_create(
            base_exercise=exercises['Press banca'],
            name='Press banca inclinado',
            defaults={
                'description': 'Variante del press banca con mas enfasis en la parte superior del pecho.',
                'equipment_override': 'Banco inclinado y barra',
                'instructions_override': 'Manten el banco entre 30 y 45 grados.',
            },
        )[0]

        goblet_squat = ExerciseVariation.objects.get_or_create(
            base_exercise=exercises['Sentadilla'],
            name='Sentadilla goblet',
            defaults={
                'description': 'Variante accesible de sentadilla con mancuerna o kettlebell.',
                'equipment_override': 'Mancuerna o kettlebell',
                'instructions_override': 'Lleva el peso pegado al pecho durante todo el recorrido.',
            },
        )[0]

        plank_elbows = ExerciseVariation.objects.get_or_create(
            base_exercise=exercises['Plancha'],
            name='Plancha sobre codos',
            defaults={
                'description': 'Version clasica de plancha con apoyo de antebrazos.',
                'equipment_override': 'Esterilla',
            },
        )[0]

        workout_plan = WorkoutPlan.objects.get_or_create(
            name='Full body inicial',
            defaults={
                'goal': 'Crear una rutina equilibrada para empezar en el gimnasio.',
                'description': 'Tabla simple para tres dias por semana.',
                'difficulty': WorkoutPlan.Difficulty.BEGINNER,
                'days_per_week': 3,
                'estimated_duration_minutes': 55,
            },
        )[0]

        items = [
            (1, exercises['Sentadilla'], goblet_squat, 'Dia 1', 4, '10-12', 90),
            (2, exercises['Press banca'], incline_press, 'Dia 1', 4, '8-10', 90),
            (3, exercises['Plancha'], plank_elbows, 'Dia 1', 3, '30-45 segundos', 45),
        ]

        for order, exercise, variation, day_label, sets, reps, rest_seconds in items:
            WorkoutPlanItem.objects.get_or_create(
                workout_plan=workout_plan,
                day_label=day_label,
                order=order,
                defaults={
                    'exercise': exercise,
                    'variation': variation,
                    'sets': sets,
                    'reps': reps,
                    'rest_seconds': rest_seconds,
                    'notes': 'Dato de ejemplo cargado automaticamente.',
                },
            )

        self.stdout.write(self.style.SUCCESS('Datos de ejemplo creados o actualizados correctamente.'))
