import json
from pathlib import Path

from django.conf import settings
from django.core.management import call_command
from rest_framework import status
from rest_framework.test import APITestCase

from .models import (
    Exercise,
    ExerciseMuscleTarget,
    ExerciseVariation,
    MuscleGroup,
    WorkoutPlan,
    WorkoutPlanItem,
)


class WorkoutApiTests(APITestCase):
    def setUp(self):
        self.chest = MuscleGroup.objects.create(
            name='Pecho',
            body_region=MuscleGroup.BodyRegion.UPPER_BODY,
        )
        self.shoulders = MuscleGroup.objects.create(
            name='Hombros',
            body_region=MuscleGroup.BodyRegion.UPPER_BODY,
        )
        self.bench_press = Exercise.objects.create(
            name='Press banca',
            description='Ejercicio basico para el pecho.',
            instructions='Manten los hombros atras y controla la bajada.',
            equipment='Barra',
            difficulty=Exercise.Difficulty.INTERMEDIATE,
            is_compound=True,
        )
        ExerciseMuscleTarget.objects.create(
            exercise=self.bench_press,
            muscle_group=self.chest,
            emphasis=ExerciseMuscleTarget.Emphasis.PRIMARY,
        )
        ExerciseMuscleTarget.objects.create(
            exercise=self.bench_press,
            muscle_group=self.shoulders,
            emphasis=ExerciseMuscleTarget.Emphasis.SECONDARY,
        )
        self.incline = ExerciseVariation.objects.create(
            base_exercise=self.bench_press,
            name='Press banca inclinado',
            description='Variante enfocada en la parte superior del pecho.',
            equipment_override='Banco inclinado y barra',
        )
        self.workout_plan = WorkoutPlan.objects.create(
            name='Torso de prueba',
            goal='Ganar fuerza',
            description='Rutina para validar sesiones.',
            difficulty=WorkoutPlan.Difficulty.BEGINNER,
            days_per_week=3,
            estimated_duration_minutes=60,
        )
        self.workout_item = WorkoutPlanItem.objects.create(
            workout_plan=self.workout_plan,
            exercise=self.bench_press,
            variation=self.incline,
            day_label='Dia 1',
            order=1,
            sets=4,
            reps='8-10',
            rest_seconds=90,
            notes='Controla el recorrido.',
        )

    def test_filter_exercises_by_muscle_group_slug(self):
        response = self.client.get('/api/exercises/', {'muscle_group': self.chest.slug})

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['name'], 'Press banca')

    def test_create_workout_plan_with_matching_variation(self):
        payload = {
            'name': 'Torso basico',
            'goal': 'Ganar masa muscular en tren superior',
            'description': 'Rutina simple de ejemplo',
            'difficulty': 'principiante',
            'days_per_week': 3,
            'estimated_duration_minutes': 60,
            'items': [
                {
                    'exercise': self.bench_press.id,
                    'variation': self.incline.id,
                    'day_label': 'Dia 1',
                    'order': 1,
                    'sets': 4,
                    'reps': '8-10',
                    'rest_seconds': 90,
                    'notes': 'Sube el peso si completas todas las repeticiones.',
                }
            ],
        }

        response = self.client.post('/api/workout-plans/', payload, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['items'][0]['variation'], self.incline.id)

    def test_reject_workout_item_when_variation_is_from_other_exercise(self):
        row = Exercise.objects.create(
            name='Remo con barra',
            description='Ejercicio compuesto para espalda.',
            equipment='Barra',
            difficulty=Exercise.Difficulty.INTERMEDIATE,
            is_compound=True,
        )

        payload = {
            'name': 'Rutina invalida',
            'goal': 'No deberia guardarse',
            'description': '',
            'difficulty': 'principiante',
            'days_per_week': 2,
            'estimated_duration_minutes': 45,
            'items': [
                {
                    'exercise': row.id,
                    'variation': self.incline.id,
                    'day_label': 'Dia 1',
                    'order': 1,
                    'sets': 3,
                    'reps': '10',
                    'rest_seconds': 60,
                    'notes': '',
                }
            ],
        }

        response = self.client.post('/api/workout-plans/', payload, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('variation', response.data['items'][0])

    def test_import_sample_set_command_creates_exercise_metadata(self):
        payload = [
            {
                'bodyPart': 'chest',
                'equipment': 'barbell',
                'id': '2001',
                'name': 'barbell incline press',
                'target': 'pectorals',
                'secondaryMuscles': ['triceps', 'shoulders'],
                'instructions': ['Lay back on the bench.', 'Press the bar upward.'],
            }
        ]

        temp_root = Path(settings.BASE_DIR) / 'tmp-test-data'
        temp_root.mkdir(exist_ok=True)
        json_path = temp_root / 'sampleExerciseData.json'

        try:
            json_path.write_text(json.dumps(payload), encoding='utf-8')
            call_command('import_sample_set', str(json_path))
        finally:
            if json_path.exists():
                json_path.unlink()
            if temp_root.exists() and not any(temp_root.iterdir()):
                temp_root.rmdir()

        exercise = Exercise.objects.get(external_id='2001')
        self.assertEqual(exercise.name, 'Press inclinado con barra')
        self.assertEqual(exercise.body_part, 'Pecho')
        self.assertEqual(exercise.equipment, 'Barra')
        self.assertEqual(exercise.difficulty, Exercise.Difficulty.INTERMEDIATE)
        self.assertTrue(exercise.is_compound)
        self.assertEqual(exercise.demo_gif_path, '')
        self.assertEqual(exercise.muscle_targets.count(), 3)

    def test_exercise_api_exposes_demo_frame_urls(self):
        frame_exercise = Exercise.objects.create(
            name='Curl con secuencia',
            description='Ejercicio con dos fotogramas.',
            instructions='Sube y baja controlando el movimiento.',
            equipment='Mancuernas',
            difficulty=Exercise.Difficulty.BEGINNER,
            is_compound=False,
            demo_frame_paths=[
                'workouts/exercises/curl-demo-0.jpg',
                'workouts/exercises/curl-demo-1.jpg',
            ],
        )
        ExerciseMuscleTarget.objects.create(
            exercise=frame_exercise,
            muscle_group=self.shoulders,
            emphasis=ExerciseMuscleTarget.Emphasis.PRIMARY,
        )

        response = self.client.get('/api/exercises/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        exercise_payload = next(item for item in response.data if item['id'] == frame_exercise.id)
        self.assertEqual(
            exercise_payload['demo_frame_urls'],
            [
                '/static/workouts/exercises/curl-demo-0.jpg',
                '/static/workouts/exercises/curl-demo-1.jpg',
            ],
        )

    def test_create_workout_session_with_set_logs(self):
        payload = {
            'workout_item': self.workout_item.id,
            'session_date': '2026-05-05',
            'notes': 'Buen control y ultima serie exigente.',
            'set_logs': [
                {
                    'order': 1,
                    'reps': '10',
                    'weight': '60 kg',
                    'rir': '2',
                    'notes': '',
                },
                {
                    'order': 2,
                    'reps': '9',
                    'weight': '60 kg',
                    'rir': '1',
                    'notes': 'Ultima repeticion lenta.',
                },
            ],
        }

        response = self.client.post('/api/workout-sessions/', payload, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['workout_item'], self.workout_item.id)
        self.assertEqual(len(response.data['set_logs']), 2)
        self.assertEqual(response.data['set_logs'][1]['notes'], 'Ultima repeticion lenta.')

    def test_filter_workout_sessions_by_workout_item(self):
        other_exercise = Exercise.objects.create(
            name='Remo con mancuerna',
            description='Ejercicio para espalda.',
            equipment='Mancuerna',
            difficulty=Exercise.Difficulty.BEGINNER,
            is_compound=True,
        )
        other_item = WorkoutPlanItem.objects.create(
            workout_plan=self.workout_plan,
            exercise=other_exercise,
            day_label='Dia 1',
            order=2,
            sets=3,
            reps='12',
            rest_seconds=75,
            notes='',
        )

        self.client.post(
            '/api/workout-sessions/',
            {
                'workout_item': self.workout_item.id,
                'session_date': '2026-05-05',
                'notes': '',
                'set_logs': [{'order': 1, 'reps': '10', 'weight': '60 kg', 'rir': '2', 'notes': ''}],
            },
            format='json',
        )
        self.client.post(
            '/api/workout-sessions/',
            {
                'workout_item': other_item.id,
                'session_date': '2026-05-06',
                'notes': '',
                'set_logs': [{'order': 1, 'reps': '12', 'weight': '24 kg', 'rir': '2', 'notes': ''}],
            },
            format='json',
        )

        response = self.client.get('/api/workout-sessions/', {'workout_item': self.workout_item.id})

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['workout_item'], self.workout_item.id)
