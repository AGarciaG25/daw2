from django.core.exceptions import ValidationError
from django.contrib.auth.models import User
from django.db import models
from django.utils import timezone
from django.utils.text import slugify


def build_unique_slug(instance, value):
    base_slug = slugify(value) or 'item'
    slug = base_slug
    model_class = instance.__class__
    suffix = 2

    while model_class.objects.exclude(pk=instance.pk).filter(slug=slug).exists():
        slug = f'{base_slug}-{suffix}'
        suffix += 1

    return slug


class TimeStampedModel(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


class UserProfile(TimeStampedModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    avatar_data_url = models.TextField(blank=True)

    class Meta:
        verbose_name = 'Perfil de usuario'
        verbose_name_plural = 'Perfiles de usuario'

    def __str__(self):
        return f'Perfil de {self.user.username}'


class MuscleGroup(TimeStampedModel):
    class BodyRegion(models.TextChoices):
        UPPER_BODY = 'tren_superior', 'Tren superior'
        LOWER_BODY = 'tren_inferior', 'Tren inferior'
        CORE = 'core', 'Core'
        FULL_BODY = 'cuerpo_completo', 'Cuerpo completo'

    name = models.CharField(max_length=120, unique=True)
    slug = models.SlugField(max_length=140, unique=True, blank=True)
    description = models.TextField(blank=True)
    body_region = models.CharField(
        max_length=20,
        choices=BodyRegion.choices,
        default=BodyRegion.UPPER_BODY,
    )

    class Meta:
        ordering = ('name',)
        verbose_name = 'Zona muscular'
        verbose_name_plural = 'Zonas musculares'

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = build_unique_slug(self, self.name)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.name


class Exercise(TimeStampedModel):
    class Difficulty(models.TextChoices):
        BEGINNER = 'principiante', 'Principiante'
        INTERMEDIATE = 'intermedio', 'Intermedio'
        ADVANCED = 'avanzado', 'Avanzado'

    name = models.CharField(max_length=140, unique=True)
    slug = models.SlugField(max_length=160, unique=True, blank=True)
    external_id = models.CharField(max_length=128, unique=True, blank=True, null=True)
    description = models.TextField()
    instructions = models.TextField(blank=True)
    equipment = models.CharField(max_length=140, blank=True)
    body_part = models.CharField(max_length=80, blank=True)
    demo_gif_path = models.CharField(max_length=255, blank=True)
    demo_frame_paths = models.JSONField(default=list, blank=True)
    difficulty = models.CharField(
        max_length=20,
        choices=Difficulty.choices,
        default=Difficulty.BEGINNER,
    )
    is_compound = models.BooleanField(default=False)
    muscle_groups = models.ManyToManyField(
        MuscleGroup,
        through='ExerciseMuscleTarget',
        related_name='exercises',
    )

    class Meta:
        ordering = ('name',)
        verbose_name = 'Ejercicio'
        verbose_name_plural = 'Ejercicios'

    def save(self, *args, **kwargs):
        if self.external_id == '':
            self.external_id = None
        if not self.slug:
            self.slug = build_unique_slug(self, self.name)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.name


class ExerciseMuscleTarget(models.Model):
    class Emphasis(models.TextChoices):
        PRIMARY = 'principal', 'Principal'
        SECONDARY = 'secundario', 'Secundario'
        STABILIZER = 'estabilizador', 'Estabilizador'

    exercise = models.ForeignKey(
        Exercise,
        on_delete=models.CASCADE,
        related_name='muscle_targets',
    )
    muscle_group = models.ForeignKey(
        MuscleGroup,
        on_delete=models.CASCADE,
        related_name='exercise_targets',
    )
    emphasis = models.CharField(
        max_length=20,
        choices=Emphasis.choices,
        default=Emphasis.PRIMARY,
    )

    class Meta:
        ordering = ('exercise__name', 'muscle_group__name')
        verbose_name = 'Relacion ejercicio-zona muscular'
        verbose_name_plural = 'Relaciones ejercicio-zona muscular'
        constraints = [
            models.UniqueConstraint(
                fields=('exercise', 'muscle_group'),
                name='unique_exercise_muscle_group',
            ),
        ]

    def __str__(self):
        return f'{self.exercise} -> {self.muscle_group} ({self.get_emphasis_display()})'


class ExerciseVariation(TimeStampedModel):
    base_exercise = models.ForeignKey(
        Exercise,
        on_delete=models.CASCADE,
        related_name='variations',
    )
    name = models.CharField(max_length=140)
    slug = models.SlugField(max_length=160, unique=True, blank=True)
    description = models.TextField()
    equipment_override = models.CharField(max_length=140, blank=True)
    instructions_override = models.TextField(blank=True)

    class Meta:
        ordering = ('base_exercise__name', 'name')
        verbose_name = 'Variacion'
        verbose_name_plural = 'Variaciones'
        constraints = [
            models.UniqueConstraint(
                fields=('base_exercise', 'name'),
                name='unique_variation_name_per_exercise',
            ),
        ]

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = build_unique_slug(self, self.name)
        super().save(*args, **kwargs)

    def __str__(self):
        return f'{self.name} ({self.base_exercise})'


class WorkoutPlan(TimeStampedModel):
    class Difficulty(models.TextChoices):
        BEGINNER = 'principiante', 'Principiante'
        INTERMEDIATE = 'intermedio', 'Intermedio'
        ADVANCED = 'avanzado', 'Avanzado'

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='workout_plans',
        null=True,
        blank=True,
    )
    name = models.CharField(max_length=140)
    slug = models.SlugField(max_length=160, unique=True, blank=True)
    goal = models.CharField(max_length=180)
    description = models.TextField(blank=True)
    difficulty = models.CharField(
        max_length=20,
        choices=Difficulty.choices,
        default=Difficulty.BEGINNER,
    )
    days_per_week = models.PositiveSmallIntegerField(default=3)
    estimated_duration_minutes = models.PositiveSmallIntegerField(default=60)

    class Meta:
        ordering = ('name',)
        verbose_name = 'Tabla de ejercicios'
        verbose_name_plural = 'Tablas de ejercicios'

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = build_unique_slug(self, self.name)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.name


class WorkoutPlanItem(models.Model):
    workout_plan = models.ForeignKey(
        WorkoutPlan,
        on_delete=models.CASCADE,
        related_name='items',
    )
    exercise = models.ForeignKey(
        Exercise,
        on_delete=models.CASCADE,
        related_name='workout_items',
    )
    variation = models.ForeignKey(
        ExerciseVariation,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='workout_items',
    )
    day_label = models.CharField(max_length=80, blank=True)
    order = models.PositiveIntegerField(default=1)
    sets = models.PositiveSmallIntegerField(default=3)
    reps = models.CharField(max_length=40, default='8-12')
    rest_seconds = models.PositiveSmallIntegerField(default=90)
    notes = models.TextField(blank=True)

    class Meta:
        ordering = ('day_label', 'order', 'id')
        verbose_name = 'Ejercicio de la tabla'
        verbose_name_plural = 'Ejercicios de la tabla'
        constraints = [
            models.UniqueConstraint(
                fields=('workout_plan', 'day_label', 'order'),
                name='unique_workout_plan_day_order',
            ),
        ]

    def clean(self):
        if self.variation and self.variation.base_exercise_id != self.exercise_id:
            raise ValidationError(
                {'variation': 'La variacion elegida no pertenece al ejercicio indicado.'}
            )

    def __str__(self):
        return f'{self.workout_plan} - {self.day_label or "General"} - {self.exercise}'


class WorkoutExerciseSession(TimeStampedModel):
    workout_item = models.ForeignKey(
        WorkoutPlanItem,
        on_delete=models.CASCADE,
        related_name='sessions',
    )
    session_date = models.DateField(default=timezone.localdate)
    notes = models.TextField(blank=True)

    class Meta:
        ordering = ('-session_date', '-created_at', '-id')
        verbose_name = 'Sesion de ejercicio'
        verbose_name_plural = 'Sesiones de ejercicio'

    def __str__(self):
        return f'{self.workout_item} - {self.session_date}'


class WorkoutExerciseSetLog(models.Model):
    session = models.ForeignKey(
        WorkoutExerciseSession,
        on_delete=models.CASCADE,
        related_name='set_logs',
    )
    order = models.PositiveSmallIntegerField(default=1)
    reps = models.CharField(max_length=20, blank=True)
    weight = models.CharField(max_length=20, blank=True)
    rir = models.CharField(max_length=20, blank=True)
    notes = models.CharField(max_length=160, blank=True)

    class Meta:
        ordering = ('order', 'id')
        verbose_name = 'Serie realizada'
        verbose_name_plural = 'Series realizadas'
        constraints = [
            models.UniqueConstraint(
                fields=('session', 'order'),
                name='unique_session_set_order',
            ),
        ]

    def __str__(self):
        return f'{self.session} - serie {self.order}'
