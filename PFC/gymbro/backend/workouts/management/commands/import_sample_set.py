import json
import shutil
import zipfile
from pathlib import Path

from django.conf import settings
from django.core.management.base import BaseCommand, CommandError
from django.db import transaction

from workouts.models import Exercise, ExerciseMuscleTarget, MuscleGroup
from workouts.translations import prettify_spanish, translate_exercise_name
from workouts.translations import build_spanish_description, build_spanish_instructions


BODY_REGION_MAP = {
    'abs': MuscleGroup.BodyRegion.CORE,
    'back': MuscleGroup.BodyRegion.UPPER_BODY,
    'biceps': MuscleGroup.BodyRegion.UPPER_BODY,
    'calves': MuscleGroup.BodyRegion.LOWER_BODY,
    'cardio': MuscleGroup.BodyRegion.FULL_BODY,
    'cardiovascular system': MuscleGroup.BodyRegion.FULL_BODY,
    'chest': MuscleGroup.BodyRegion.UPPER_BODY,
    'delts': MuscleGroup.BodyRegion.UPPER_BODY,
    'forearms': MuscleGroup.BodyRegion.UPPER_BODY,
    'glutes': MuscleGroup.BodyRegion.LOWER_BODY,
    'hamstrings': MuscleGroup.BodyRegion.LOWER_BODY,
    'hip flexors': MuscleGroup.BodyRegion.CORE,
    'lower arms': MuscleGroup.BodyRegion.UPPER_BODY,
    'pectorals': MuscleGroup.BodyRegion.UPPER_BODY,
    'quadriceps': MuscleGroup.BodyRegion.LOWER_BODY,
    'shoulders': MuscleGroup.BodyRegion.UPPER_BODY,
    'triceps': MuscleGroup.BodyRegion.UPPER_BODY,
    'upper arms': MuscleGroup.BodyRegion.UPPER_BODY,
    'upper back': MuscleGroup.BodyRegion.UPPER_BODY,
    'waist': MuscleGroup.BodyRegion.CORE,
}

def prettify_name(value):
    return prettify_spanish(value)


def guess_body_region(*values):
    for value in values:
        normalized = str(value).strip().lower()
        if normalized in BODY_REGION_MAP:
            return BODY_REGION_MAP[normalized]
    return MuscleGroup.BodyRegion.FULL_BODY


def infer_is_compound(record):
    body_part = str(record.get('bodyPart', '')).strip().lower()
    target = str(record.get('target', '')).strip().lower()
    secondary_count = len(record.get('secondaryMuscles') or [])
    if body_part == 'cardio' or target == 'cardiovascular system':
        return True
    return secondary_count >= 2


def infer_difficulty(record, is_compound):
    body_part = str(record.get('bodyPart', '')).strip().lower()
    equipment = str(record.get('equipment', '')).strip().lower()
    name = str(record.get('name', '')).strip().lower()
    if any(keyword in name for keyword in ('snatch', 'clean', 'pistol')):
        return Exercise.Difficulty.ADVANCED
    if body_part == 'cardio' or is_compound or equipment in {'barbell', 'kettlebell'}:
        return Exercise.Difficulty.INTERMEDIATE
    return Exercise.Difficulty.BEGINNER


def build_description(record, primary_target, body_part):
    equipment = prettify_name(record.get('equipment', ''))
    return build_spanish_description(record.get('name', 'ejercicio'), equipment, primary_target or body_part)


class Command(BaseCommand):
    help = 'Importa el dataset de ejercicios desde un archivo ZIP o JSON.'

    def add_arguments(self, parser):
        parser.add_argument('source_path', help='Ruta al ZIP o JSON que contiene el dataset.')

    def handle(self, *args, **options):
        source_path = Path(options['source_path']).expanduser()
        if not source_path.exists():
            raise CommandError(f'No existe el archivo indicado: {source_path}')

        records, extracted_assets = self._load_records(source_path)

        created_count = 0
        updated_count = 0

        with transaction.atomic():
            for record in records:
                created = self._upsert_exercise(record, extracted_assets)
                if created:
                    created_count += 1
                else:
                    updated_count += 1

        self.stdout.write(
            self.style.SUCCESS(
                f'Importacion completada: {created_count} ejercicios creados, '
                f'{updated_count} actualizados y {len(extracted_assets)} GIFs preparados.'
            )
        )

    def _load_records(self, source_path):
        if source_path.suffix.lower() == '.json':
            return self._load_json(source_path), set()
        if source_path.suffix.lower() == '.zip':
            return self._load_zip(source_path)
        raise CommandError('El origen debe ser un archivo .zip o .json.')

    def _load_json(self, source_path):
        try:
            data = json.loads(source_path.read_text(encoding='utf-8'))
        except json.JSONDecodeError as exc:
            raise CommandError(f'No se pudo leer el JSON: {exc}') from exc

        if not isinstance(data, list):
            raise CommandError('El JSON debe contener una lista de ejercicios.')
        return data

    def _load_zip(self, source_path):
        extracted_assets = set()
        asset_root = Path(settings.BASE_DIR) / 'workouts' / 'static' / 'workouts' / 'exercises'
        asset_root.mkdir(parents=True, exist_ok=True)

        with zipfile.ZipFile(source_path) as archive:
            json_member = next(
                (
                    member
                    for member in archive.namelist()
                    if member.lower().endswith('.json') and '__macosx/' not in member.lower()
                ),
                None,
            )
            if not json_member:
                raise CommandError('El ZIP no contiene ningun archivo JSON utilizable.')

            try:
                data = json.loads(archive.read(json_member).decode('utf-8'))
            except json.JSONDecodeError as exc:
                raise CommandError(f'No se pudo leer el JSON del ZIP: {exc}') from exc

            if not isinstance(data, list):
                raise CommandError('El JSON del ZIP debe contener una lista de ejercicios.')

            for member in archive.infolist():
                member_name = member.filename
                lowered = member_name.lower()
                if member.is_dir() or '__macosx/' in lowered or lowered.endswith('.ds_store'):
                    continue
                if not lowered.endswith('.gif'):
                    continue

                destination = asset_root / Path(member_name).name
                with archive.open(member) as source_stream:
                    with destination.open('wb') as destination_stream:
                        shutil.copyfileobj(source_stream, destination_stream)
                extracted_assets.add(destination.stem)

        return data, extracted_assets

    def _upsert_exercise(self, record, extracted_assets):
        external_id = str(record.get('id', '')).strip()
        if not external_id:
            raise CommandError('Todos los ejercicios del dataset deben incluir un campo "id".')

        name = translate_exercise_name(prettify_name(record.get('name', '')))
        if not name:
            raise CommandError(f'El ejercicio con id {external_id} no tiene nombre valido.')

        primary_target_name = prettify_name(record.get('target', ''))
        body_part_name = prettify_name(record.get('bodyPart', ''))
        equipment_name = prettify_name(record.get('equipment', ''))
        is_compound = infer_is_compound(record)
        difficulty = infer_difficulty(record, is_compound)
        gif_path = f'workouts/exercises/{external_id}.gif' if external_id in extracted_assets else ''

        exercise = Exercise.objects.filter(external_id=external_id).first()
        if exercise is None:
            exercise = Exercise.objects.filter(name=name).first()

        defaults = {
            'name': name,
            'description': build_description(record, primary_target_name, body_part_name),
            'instructions': build_spanish_instructions(name),
            'equipment': equipment_name,
            'body_part': body_part_name,
            'demo_gif_path': gif_path,
            'difficulty': difficulty,
            'is_compound': is_compound,
            'external_id': external_id,
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

        if primary_target_name:
            muscle_group = self._get_or_create_muscle_group(
                primary_target_name,
                guess_body_region(record.get('target'), record.get('bodyPart')),
            )
            desired_targets[muscle_group.id] = (muscle_group, ExerciseMuscleTarget.Emphasis.PRIMARY)

        for muscle_name in record.get('secondaryMuscles') or []:
            normalized_name = prettify_name(muscle_name)
            if not normalized_name:
                continue
            muscle_group = self._get_or_create_muscle_group(
                normalized_name,
                guess_body_region(muscle_name, record.get('bodyPart')),
            )
            desired_targets.setdefault(
                muscle_group.id,
                (muscle_group, ExerciseMuscleTarget.Emphasis.SECONDARY),
            )

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

    @staticmethod
    def _get_or_create_muscle_group(name, body_region):
        description = f'Grupo muscular importado desde el dataset de ejercicios: {name.lower()}.'
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
