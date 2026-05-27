from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


def assign_existing_plans(apps, schema_editor):
    User = apps.get_model('auth', 'User')
    WorkoutPlan = apps.get_model('workouts', 'WorkoutPlan')
    user = User.objects.order_by('id').first()

    if user:
        WorkoutPlan.objects.filter(user__isnull=True).update(user=user)


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('workouts', '0008_userprofile'),
    ]

    operations = [
        migrations.AddField(
            model_name='workoutplan',
            name='user',
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=django.db.models.deletion.CASCADE,
                related_name='workout_plans',
                to=settings.AUTH_USER_MODEL,
            ),
        ),
        migrations.AlterField(
            model_name='workoutplan',
            name='name',
            field=models.CharField(max_length=140),
        ),
        migrations.RunPython(assign_existing_plans, migrations.RunPython.noop),
    ]
