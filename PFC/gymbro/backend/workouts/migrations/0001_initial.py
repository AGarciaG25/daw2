# Generado por Django 6.0 el 2026-04-07 09:10

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Exercise',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('name', models.CharField(max_length=140, unique=True)),
                ('slug', models.SlugField(blank=True, max_length=160, unique=True)),
                ('description', models.TextField()),
                ('instructions', models.TextField(blank=True)),
                ('equipment', models.CharField(blank=True, max_length=140)),
                ('difficulty', models.CharField(choices=[('beginner', 'Principiante'), ('intermediate', 'Intermedio'), ('advanced', 'Avanzado')], default='beginner', max_length=20)),
                ('is_compound', models.BooleanField(default=False)),
            ],
            options={
                'verbose_name': 'Ejercicio',
                'verbose_name_plural': 'Ejercicios',
                'ordering': ('name',),
            },
        ),
        migrations.CreateModel(
            name='MuscleGroup',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('name', models.CharField(max_length=120, unique=True)),
                ('slug', models.SlugField(blank=True, max_length=140, unique=True)),
                ('description', models.TextField(blank=True)),
                ('body_region', models.CharField(choices=[('upper_body', 'Tren superior'), ('lower_body', 'Tren inferior'), ('core', 'Core'), ('full_body', 'Cuerpo completo')], default='upper_body', max_length=20)),
            ],
            options={
                'verbose_name': 'Zona muscular',
                'verbose_name_plural': 'Zonas musculares',
                'ordering': ('name',),
            },
        ),
        migrations.CreateModel(
            name='WorkoutPlan',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('name', models.CharField(max_length=140, unique=True)),
                ('slug', models.SlugField(blank=True, max_length=160, unique=True)),
                ('goal', models.CharField(max_length=180)),
                ('description', models.TextField(blank=True)),
                ('difficulty', models.CharField(choices=[('beginner', 'Principiante'), ('intermediate', 'Intermedio'), ('advanced', 'Avanzado')], default='beginner', max_length=20)),
                ('days_per_week', models.PositiveSmallIntegerField(default=3)),
                ('estimated_duration_minutes', models.PositiveSmallIntegerField(default=60)),
            ],
            options={
                'verbose_name': 'Tabla de ejercicios',
                'verbose_name_plural': 'Tablas de ejercicios',
                'ordering': ('name',),
            },
        ),
        migrations.CreateModel(
            name='ExerciseVariation',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('name', models.CharField(max_length=140)),
                ('slug', models.SlugField(blank=True, max_length=160, unique=True)),
                ('description', models.TextField()),
                ('equipment_override', models.CharField(blank=True, max_length=140)),
                ('instructions_override', models.TextField(blank=True)),
                ('base_exercise', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='variations', to='workouts.exercise')),
            ],
            options={
                'verbose_name': 'Variacion',
                'verbose_name_plural': 'Variaciones',
                'ordering': ('base_exercise__name', 'name'),
            },
        ),
        migrations.CreateModel(
            name='ExerciseMuscleTarget',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('emphasis', models.CharField(choices=[('primary', 'Principal'), ('secondary', 'Secundario'), ('stabilizer', 'Estabilizador')], default='primary', max_length=20)),
                ('exercise', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='muscle_targets', to='workouts.exercise')),
                ('muscle_group', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='exercise_targets', to='workouts.musclegroup')),
            ],
            options={
                'verbose_name': 'Relacion ejercicio-zona muscular',
                'verbose_name_plural': 'Relaciones ejercicio-zona muscular',
                'ordering': ('exercise__name', 'muscle_group__name'),
            },
        ),
        migrations.AddField(
            model_name='exercise',
            name='muscle_groups',
            field=models.ManyToManyField(related_name='exercises', through='workouts.ExerciseMuscleTarget', to='workouts.musclegroup'),
        ),
        migrations.CreateModel(
            name='WorkoutPlanItem',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('day_label', models.CharField(blank=True, max_length=80)),
                ('order', models.PositiveIntegerField(default=1)),
                ('sets', models.PositiveSmallIntegerField(default=3)),
                ('reps', models.CharField(default='8-12', max_length=40)),
                ('rest_seconds', models.PositiveSmallIntegerField(default=90)),
                ('notes', models.TextField(blank=True)),
                ('exercise', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='workout_items', to='workouts.exercise')),
                ('variation', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='workout_items', to='workouts.exercisevariation')),
                ('workout_plan', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='items', to='workouts.workoutplan')),
            ],
            options={
                'verbose_name': 'Ejercicio de la tabla',
                'verbose_name_plural': 'Ejercicios de la tabla',
                'ordering': ('day_label', 'order', 'id'),
            },
        ),
        migrations.AddConstraint(
            model_name='exercisevariation',
            constraint=models.UniqueConstraint(fields=('base_exercise', 'name'), name='unique_variation_name_per_exercise'),
        ),
        migrations.AddConstraint(
            model_name='exercisemuscletarget',
            constraint=models.UniqueConstraint(fields=('exercise', 'muscle_group'), name='unique_exercise_muscle_group'),
        ),
        migrations.AddConstraint(
            model_name='workoutplanitem',
            constraint=models.UniqueConstraint(fields=('workout_plan', 'day_label', 'order'), name='unique_workout_plan_day_order'),
        ),
    ]
