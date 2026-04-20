from django.contrib.auth.models import User
from django.db import transaction
from rest_framework import serializers

from .models import (
    Exercise,
    ExerciseMuscleTarget,
    ExerciseVariation,
    MuscleGroup,
    WorkoutPlan,
    WorkoutPlanItem,
)


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
        return {
            'id': obj.base_exercise_id,
            'name': obj.base_exercise.name,
            'slug': obj.base_exercise.slug,
        }


class ExerciseSerializer(serializers.ModelSerializer):
    muscle_targets = ExerciseMuscleTargetSerializer(many=True, required=False)
    variations = ExerciseVariationSerializer(many=True, read_only=True)

    class Meta:
        model = Exercise
        fields = (
            'id',
            'name',
            'slug',
            'description',
            'instructions',
            'equipment',
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

        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        if muscle_targets is not None:
            instance.muscle_targets.all().delete()
            self._save_muscle_targets(instance, muscle_targets)

        return instance

    @staticmethod
    def _save_muscle_targets(exercise, muscle_targets):
        ExerciseMuscleTarget.objects.bulk_create(
            [ExerciseMuscleTarget(exercise=exercise, **target) for target in muscle_targets]
        )


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
            'id': obj.exercise_id,
            'name': obj.exercise.name,
            'slug': obj.exercise.slug,
            'primary_muscles': [target.muscle_group.name for target in primary_targets],
        }

    def get_variation_detail(self, obj):
        if not obj.variation:
            return None

        return {
            'id': obj.variation_id,
            'name': obj.variation.name,
            'slug': obj.variation.slug,
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

        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

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
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data.get('email', ''),
            password=validated_data['password']
        )
        return user

