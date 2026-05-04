from django.db import migrations


def forwards(apps, schema_editor):
    Exercise = apps.get_model('workouts', 'Exercise')
    for exercise in Exercise.objects.filter(description__contains=' con sin material '):
        exercise.description = exercise.description.replace(' con sin material ', ' sin material ')
        exercise.save(update_fields=['description', 'updated_at'])


class Migration(migrations.Migration):

    dependencies = [
        ('workouts', '0005_spanish_imported_texts'),
    ]

    operations = [
        migrations.RunPython(forwards, migrations.RunPython.noop),
    ]
