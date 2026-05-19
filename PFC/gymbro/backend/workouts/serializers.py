from django.contrib.auth.models import User
from django.templatetags.static import static
from django.db import transaction
from rest_framework import serializers

from .models import (
    Exercise,
    ExerciseMuscleTarget,
    ExerciseVariation,
    MuscleGroup,
    WorkoutExerciseSession,
    WorkoutExerciseSetLog,
    WorkoutPlan,
    WorkoutPlanItem,
)


def compact_detail(obj, *fields):
    return {'id': obj.id, **{field: getattr(obj, field) for field in fields}}


def update_instance(instance, validated_data):
    for attr, value in validated_data.items():
        setattr(instance, attr, value)
    instance.save()
    return instance


class MuscleGroupSerializer(serializers.ModelSerializer):
    exercise_count = serializers.SerializerMethodField()

    class Meta:
        model = MuscleGroup
        fields = (
            'id',
            'name',
            'slug',
            'description',
            'body_region',
            'exercise_count',
            'created_at',
            'updated_at',
        )
        read_only_fields = ('slug', 'created_at', 'updated_at')

    def get_exercise_count(self, obj):
        return obj.exercises.count()


class ExerciseMuscleTargetSerializer(serializers.ModelSerializer):
    muscle_group_detail = MuscleGroupSerializer(source='muscle_group', read_only=True)

    class Meta:
        model = ExerciseMuscleTarget
        fields = ('id', 'muscle_group', 'muscle_group_detail', 'emphasis')


class ExerciseVariationSerializer(serializers.ModelSerializer):
    base_exercise_detail = serializers.SerializerMethodField()

    class Meta:
        model = ExerciseVariation
        fields = (
            'id',
            'base_exercise',
            'base_exercise_detail',
            'name',
            'slug',
            'description',
            'equipment_override',
            'instructions_override',
            'created_at',
            'updated_at',
        )
        read_only_fields = ('slug', 'created_at', 'updated_at')

    def get_base_exercise_detail(self, obj):
        return compact_detail(obj.base_exercise, 'name', 'slug')


class ExerciseSerializer(serializers.ModelSerializer):
    muscle_targets = ExerciseMuscleTargetSerializer(many=True, required=False)
    variations = ExerciseVariationSerializer(many=True, read_only=True)
    demo_gif_url = serializers.SerializerMethodField()
    demo_frame_urls = serializers.SerializerMethodField()

    class Meta:
        model = Exercise
        fields = (
            'id',
            'name',
            'slug',
            'external_id',
            'description',
            'instructions',
            'equipment',
            'body_part',
            'demo_gif_path',
            'demo_frame_paths',
            'demo_gif_url',
            'demo_frame_urls',
            'difficulty',
            'is_compound',
            'muscle_targets',
            'variations',
            'created_at',
            'updated_at',
        )
        read_only_fields = ('slug', 'created_at', 'updated_at', 'variations')

    @transaction.atomic
    def create(self, validated_data):
        muscle_targets = validated_data.pop('muscle_targets', [])
        exercise = Exercise.objects.create(**validated_data)
        self._save_muscle_targets(exercise, muscle_targets)
        return exercise

    @transaction.atomic
    def update(self, instance, validated_data):
        muscle_targets = validated_data.pop('muscle_targets', None)

        update_instance(instance, validated_data)

        if muscle_targets is not None:
            instance.muscle_targets.all().delete()
            self._save_muscle_targets(instance, muscle_targets)

        return instance

    @staticmethod
    def _save_muscle_targets(exercise, muscle_targets):
        ExerciseMuscleTarget.objects.bulk_create(
            [ExerciseMuscleTarget(exercise=exercise, **target) for target in muscle_targets]
        )

    def get_demo_gif_url(self, obj):
        return static(obj.demo_gif_path) if obj.demo_gif_path else ''

    def get_demo_frame_urls(self, obj):
        return [static(path) for path in (obj.demo_frame_paths or []) if path]


class WorkoutPlanItemSerializer(serializers.ModelSerializer):
    exercise_detail = serializers.SerializerMethodField()
    variation_detail = serializers.SerializerMethodField()

    class Meta:
        model = WorkoutPlanItem
        fields = (
            'id',
            'exercise',
            'exercise_detail',
            'variation',
            'variation_detail',
            'day_label',
            'order',
            'sets',
            'reps',
            'rest_seconds',
            'notes',
        )

    def validate(self, attrs):
        exercise = attrs.get('exercise') or getattr(self.instance, 'exercise', None)
        variation = attrs.get('variation') or getattr(self.instance, 'variation', None)

        if variation and exercise and variation.base_exercise_id != exercise.id:
            raise serializers.ValidationError(
                {'variation': 'La variacion elegida no pertenece al ejercicio indicado.'}
            )

        return attrs

    def get_exercise_detail(self, obj):
        primary_targets = obj.exercise.muscle_targets.select_related('muscle_group').filter(
            emphasis=ExerciseMuscleTarget.Emphasis.PRIMARY
        )
        return {
            **compact_detail(obj.exercise, 'name', 'slug'),
            'primary_muscles': [target.muscle_group.name for target in primary_targets],
        }

    def get_variation_detail(self, obj):
        if not obj.variation:
            return None

        return compact_detail(obj.variation, 'name', 'slug')


class WorkoutExerciseSetLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkoutExerciseSetLog
        fields = (
            'id',
            'order',
            'reps',
            'weight',
            'rir',
            'notes',
        )


class WorkoutExerciseSessionSerializer(serializers.ModelSerializer):
    set_logs = WorkoutExerciseSetLogSerializer(many=True, required=False)
    workout_item_detail = serializers.SerializerMethodField()

    class Meta:
        model = WorkoutExerciseSession
        fields = (
            'id',
            'workout_item',
            'workout_item_detail',
            'session_date',
            'notes',
            'set_logs',
            'created_at',
            'updated_at',
        )
        read_only_fields = ('created_at', 'updated_at')

    @transaction.atomic
    def create(self, validated_data):
        set_logs = validated_data.pop('set_logs', [])
        session = WorkoutExerciseSession.objects.create(**validated_data)
        self._save_set_logs(session, set_logs)
        return session

    @transaction.atomic
    def update(self, instance, validated_data):
        set_logs = validated_data.pop('set_logs', None)

        update_instance(instance, validated_data)

        if set_logs is not None:
            instance.set_logs.all().delete()
            self._save_set_logs(instance, set_logs)

        return instance

    def validate(self, attrs):
        set_logs = attrs.get('set_logs')

        if set_logs:
            seen_orders = set()
            for set_log in set_logs:
                order = set_log.get('order')
                if order in seen_orders:
                    raise serializers.ValidationError(
                        {'set_logs': 'No puede haber dos series con el mismo orden.'}
                    )
                seen_orders.add(order)

        return attrs

    @staticmethod
    def _save_set_logs(session, set_logs):
        WorkoutExerciseSetLog.objects.bulk_create(
            [WorkoutExerciseSetLog(session=session, **set_log) for set_log in set_logs]
        )

    def get_workout_item_detail(self, obj):
        return {
            'id': obj.workout_item_id,
            'day_label': obj.workout_item.day_label,
            'exercise_name': obj.workout_item.exercise.name,
            'variation_name': obj.workout_item.variation.name if obj.workout_item.variation else '',
            'planned_sets': obj.workout_item.sets,
            'planned_reps': obj.workout_item.reps,
            'planned_rest_seconds': obj.workout_item.rest_seconds,
        }


class WorkoutPlanSerializer(serializers.ModelSerializer):
    items = WorkoutPlanItemSerializer(many=True, required=False)

    class Meta:
        model = WorkoutPlan
        fields = (
            'id',
            'name',
            'slug',
            'goal',
            'description',
            'difficulty',
            'days_per_week',
            'estimated_duration_minutes',
            'items',
            'created_at',
            'updated_at',
        )
        read_only_fields = ('slug', 'created_at', 'updated_at')

    @transaction.atomic
    def create(self, validated_data):
        items = validated_data.pop('items', [])
        workout_plan = WorkoutPlan.objects.create(**validated_data)
        self._save_items(workout_plan, items)
        return workout_plan

    @transaction.atomic
    def update(self, instance, validated_data):
        items = validated_data.pop('items', None)

        update_instance(instance, validated_data)

        if items is not None:
            instance.items.all().delete()
            self._save_items(instance, items)

        return instance

    @staticmethod
    def _save_items(workout_plan, items):
        seen_positions = set()
        workout_items = []

        for item in items:
            position = (item.get('day_label', ''), item['order'])
            if position in seen_positions:
                raise serializers.ValidationError(
                    {'items': 'No puede haber dos ejercicios con el mismo dia y orden.'}
                )
            seen_positions.add(position)

            workout_item = WorkoutPlanItem(workout_plan=workout_plan, **item)
            workout_item.full_clean()
            workout_items.append(workout_item)

        WorkoutPlanItem.objects.bulk_create(workout_items)


class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('username', 'email', 'password')

    def create(self, validated_data):
        return User.objects.create_user(
            username=validated_data['username'],
            email=validated_data.get('email', ''),
            password=validated_data['password']
        )

