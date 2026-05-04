from django.db import migrations


def forwards(apps, schema_editor):
    Exercise = apps.get_model('workouts', 'Exercise')
    MuscleGroup = apps.get_model('workouts', 'MuscleGroup')

    for exercise in Exercise.objects.exclude(external_id__isnull=True).exclude(external_id=''):
        targets = [
            target.muscle_group.name
            for target in exercise.muscle_targets.select_related('muscle_group').all()[:2]
        ]
        target_fragment = f' enfocado en {", ".join(targets).lower()}' if targets else ''
        equipment_fragment = f' con {exercise.equipment.lower()}' if exercise.equipment else ''
        exercise.description = (
            f'Ejercicio{target_fragment}{equipment_fragment} para incluir en una rutina de fuerza '
            'o acondicionamiento.'
        )
        exercise.instructions = (
            f'Realiza {exercise.name.lower()} con una postura estable y movimiento controlado.\n'
            'Ajusta la carga a tu nivel, respira de forma constante y detente si aparece dolor.'
        )
        exercise.save(update_fields=['description', 'instructions', 'updated_at'])

    for muscle_group in MuscleGroup.objects.all():
        muscle_group.description = f'Grupo muscular: {muscle_group.name.lower()}.'
        muscle_group.save(update_fields=['description', 'updated_at'])


class Migration(migrations.Migration):

    dependencies = [
        ('workouts', '0004_spanish_choice_values_and_seed_names'),
    ]

    operations = [
        migrations.RunPython(forwards, migrations.RunPython.noop),
    ]
