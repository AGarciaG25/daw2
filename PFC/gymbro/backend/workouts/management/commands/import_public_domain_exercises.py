import json
import shutil
import urllib.request
from pathlib import Path

from django.conf import settings
from django.core.management.base import BaseCommand, CommandError
from django.db import transaction
from django.utils.text import slugify

from workouts.models import Exercise, ExerciseMuscleTarget, MuscleGroup
from workouts.translations import prettify_spanish, translate_exercise_name
from workouts.translations import build_spanish_description, build_spanish_instructions


CURATED_EXERCISE_IDS = [
    '3_4_Sit-Up',
    'Ab_Crunch_Machine',
    'Ab_Roller',
    'Alternate_Hammer_Curl',
    'Alternate_Heel_Touchers',
    'Alternate_Incline_Dumbbell_Curl',
    'Alternating_Cable_Shoulder_Press',
    'Alternating_Deltoid_Raise',
    'Alternating_Floor_Press',
    'Alternating_Kettlebell_Press',
    'Alternating_Kettlebell_Row',
    'Arnold_Dumbbell_Press',
    'Around_The_Worlds',
    'Back_Flyes_-_With_Bands',
    'Ball_Leg_Curl',
    'Band_Assisted_Pull-Up',
    'Band_Skull_Crusher',
    'Barbell_Incline_Bench_Press_-_Medium_Grip',
    'Barbell_Lunge',
    'Barbell_Shrug',
    'Barbell_Squat',
    'Barbell_Step_Ups',
    'Bench_Dips',
    'Bench_Press_-_With_Bands',
    'Bent_Over_Barbell_Row',
    'Bent_Over_Two-Dumbbell_Row',
    'Butt_Lift_Bridge',
    'Cable_Hammer_Curls_-_Rope_Attachment',
    'Cable_Incline_Triceps_Extension',
    'Cable_Lying_Triceps_Extension',
    'Calf_Press_On_The_Leg_Press_Machine',
    'Chin-Up',
    'Close-Grip_Front_Lat_Pulldown',
    'Glute_Kickback',
    'Monster_Walk',
    'Thigh_Adductor',
]

BODY_REGION_MAP = {
    'abdominals': MuscleGroup.BodyRegion.CORE,
    'abductors': MuscleGroup.BodyRegion.LOWER_BODY,
    'adductors': MuscleGroup.BodyRegion.LOWER_BODY,
    'biceps': MuscleGroup.BodyRegion.UPPER_BODY,
    'calves': MuscleGroup.BodyRegion.LOWER_BODY,
    'chest': MuscleGroup.BodyRegion.UPPER_BODY,
    'forearms': MuscleGroup.BodyRegion.UPPER_BODY,
    'glutes': MuscleGroup.BodyRegion.LOWER_BODY,
    'hamstrings': MuscleGroup.BodyRegion.LOWER_BODY,
    'lats': MuscleGroup.BodyRegion.UPPER_BODY,
    'lower back': MuscleGroup.BodyRegion.CORE,
    'middle back': MuscleGroup.BodyRegion.UPPER_BODY,
    'quadriceps': MuscleGroup.BodyRegion.LOWER_BODY,
    'shoulders': MuscleGroup.BodyRegion.UPPER_BODY,
    'traps': MuscleGroup.BodyRegion.UPPER_BODY,
    'triceps': MuscleGroup.BodyRegion.UPPER_BODY,
}

DIFFICULTY_MAP = {
    'beginner': Exercise.Difficulty.BEGINNER,
    'intermediate': Exercise.Difficulty.INTERMEDIATE,
    'expert': Exercise.Difficulty.ADVANCED,
    'advanced': Exercise.Difficulty.ADVANCED,
}


def prettify(value):
    return prettify_spanish(value)


def guess_body_region(muscle_name):
    return BODY_REGION_MAP.get(str(muscle_name or '').strip().lower(), MuscleGroup.BodyRegion.FULL_BODY)


def build_description(record, name=''):
    primary = prettify((record.get('primaryMuscles') or [''])[0]) or 'varios grupos musculares'
    equipment = prettify(record.get('equipment', ''))
    return build_spanish_description(name or 'ejercicio', equipment, primary)


class Command(BaseCommand):
    help = 'Importa ejercicios extra desde free-exercise-db con animacion por fotogramas.'

    def add_arguments(self, parser):
        parser.add_argument(
            '--json-path',
            default=str(Path(settings.BASE_DIR) / 'data' / 'free-exercise-db.json'),
            help='Ruta local al JSON del dataset.',
        )
        parser.add_argument(
            '--image-base-url',
            default='https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises',
            help='Base URL desde la que descargar los fotogramas del ejercicio.',
        )

    def handle(self, *args, **options):
        json_path = Path(options['json_path'])
        if not json_path.exists():
            raise CommandError(f'No existe el JSON indicado: {json_path}')

        try:
            dataset = json.loads(json_path.read_text(encoding='utf-8'))
        except json.JSONDecodeError as exc:
            raise CommandError(f'No se pudo leer el JSON del dataset: {exc}') from exc

        selected_by_id = {record['id']: record for record in dataset if record.get('id') in CURATED_EXERCISE_IDS}
        missing_ids = [exercise_id for exercise_id in CURATED_EXERCISE_IDS if exercise_id not in selected_by_id]
        if missing_ids:
            raise CommandError(f'Faltan ejercicios en el dataset: {", ".join(missing_ids)}')

        asset_root = Path(settings.BASE_DIR) / 'workouts' / 'static' / 'workouts' / 'exercises'
        asset_root.mkdir(parents=True, exist_ok=True)

        created_count = 0
        updated_count = 0

        with transaction.atomic():
            for exercise_id in CURATED_EXERCISE_IDS:
                created = self._upsert_exercise(
                    selected_by_id[exercise_id],
                    asset_root=asset_root,
                    image_base_url=options['image_base_url'].rstrip('/'),
                )
                if created:
                    created_count += 1
                else:
                    updated_count += 1

        self.stdout.write(
            self.style.SUCCESS(
                f'Importacion completada: {created_count} ejercicios nuevos y {updated_count} actualizados.'
            )
        )

    def _upsert_exercise(self, record, asset_root, image_base_url):
        source_id = record['id']
        external_id = f'free-exercise-db:{source_id}'
        frame_paths = self._download_frames(record, asset_root, image_base_url)

        exercise = Exercise.objects.filter(external_id=external_id).first()
        translated_name = translate_exercise_name(record['name'])

        if exercise is None:
            exercise = Exercise.objects.filter(name__in=[record['name'], translated_name]).first()

        defaults = {
            'name': translated_name,
            'external_id': external_id,
            'description': build_description(record, translated_name),
            'instructions': build_spanish_instructions(translated_name),
            'equipment': prettify(record.get('equipment', '')),
            'body_part': prettify((record.get('primaryMuscles') or [''])[0]),
            'demo_gif_path': '',
            'demo_frame_paths': frame_paths,
            'difficulty': DIFFICULTY_MAP.get(record.get('level'), Exercise.Difficulty.BEGINNER),
            'is_compound': record.get('mechanic') == 'compound',
        }

        created = False
        if exercise is None:
            exercise = Exercise.objects.create(**defaults)
            created = True
        else:
            for field, value in defaults.items():
                setattr(exercise, field, value)
            exercise.save()

        desired_targets = {}
        for emphasis, muscle_names in (
            (ExerciseMuscleTarget.Emphasis.PRIMARY, record.get('primaryMuscles') or []),
            (ExerciseMuscleTarget.Emphasis.SECONDARY, record.get('secondaryMuscles') or []),
        ):
            for muscle_name in muscle_names:
                display_name = prettify(muscle_name)
                if not display_name:
                    continue
                muscle_group = self._get_or_create_muscle_group(
                    display_name,
                    guess_body_region(muscle_name),
                )
                desired_targets[muscle_group.id] = (muscle_group, emphasis)

        exercise.muscle_targets.all().delete()
        if desired_targets:
            ExerciseMuscleTarget.objects.bulk_create(
                [
                    ExerciseMuscleTarget(
                        exercise=exercise,
                        muscle_group=muscle_group,
                        emphasis=emphasis,
                    )
                    for muscle_group, emphasis in desired_targets.values()
                ]
            )

        return created

    def _download_frames(self, record, asset_root, image_base_url):
        frame_paths = []
        exercise_slug = slugify(record['id']) or slugify(record['name']) or 'exercise'

        for index, image_fragment in enumerate((record.get('images') or [])[:2]):
            file_extension = Path(image_fragment).suffix.lower() or '.jpg'
            destination_name = f'{exercise_slug}-{index}{file_extension}'
            destination_path = asset_root / destination_name
            source_url = f'{image_base_url}/{image_fragment}'

            with urllib.request.urlopen(source_url) as source_stream:
                with destination_path.open('wb') as destination_stream:
                    shutil.copyfileobj(source_stream, destination_stream)

            frame_paths.append(f'workouts/exercises/{destination_name}')

        return frame_paths

    @staticmethod
    def _get_or_create_muscle_group(name, body_region):
        description = f'Grupo muscular importado desde free-exercise-db: {name.lower()}.'
        muscle_group, created = MuscleGroup.objects.get_or_create(
            name=name,
            defaults={
                'description': description,
                'body_region': body_region,
            },
        )
        if not created and muscle_group.body_region != body_region:
            muscle_group.body_region = body_region
            muscle_group.save(update_fields=['body_region', 'updated_at'])
        return muscle_group
