from rest_framework import status
from rest_framework.test import APITestCase

from .models import Exercise, ExerciseMuscleTarget, ExerciseVariation, MuscleGroup


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
            'difficulty': 'beginner',
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
            'difficulty': 'beginner',
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
