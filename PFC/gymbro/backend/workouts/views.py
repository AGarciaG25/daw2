from rest_framework import viewsets, generics, permissions

from .models import (
    Exercise,
    ExerciseVariation,
    MuscleGroup,
    WorkoutExerciseSession,
    WorkoutPlan,
)
from .serializers import (
    ExerciseSerializer,
    ExerciseVariationSerializer,
    MuscleGroupSerializer,
    WorkoutExerciseSessionSerializer,
    WorkoutPlanSerializer,
    UserRegistrationSerializer,
)


def lookup_by_id_or_slug(value, id_field, slug_field):
    return {id_field if value.isdigit() else slug_field: value}


def apply_filter(queryset, value, **lookup):
    return queryset.filter(**lookup) if value else queryset


class MuscleGroupViewSet(viewsets.ModelViewSet):
    queryset = MuscleGroup.objects.all()
    serializer_class = MuscleGroupSerializer

    def get_queryset(self):
        queryset = super().get_queryset()
        body_region = self.request.query_params.get('body_region')

        return apply_filter(queryset, body_region, body_region=body_region)


class ExerciseViewSet(viewsets.ModelViewSet):
    serializer_class = ExerciseSerializer

    def get_queryset(self):
        queryset = (
            Exercise.objects.all()
            .prefetch_related('muscle_targets__muscle_group', 'variations')
        )
        muscle_group = self.request.query_params.get('muscle_group')
        difficulty = self.request.query_params.get('difficulty')

        if muscle_group:
            queryset = queryset.filter(
                **lookup_by_id_or_slug(
                    muscle_group,
                    'muscle_targets__muscle_group__id',
                    'muscle_targets__muscle_group__slug',
                )
            )

        return apply_filter(queryset, difficulty, difficulty=difficulty).distinct()


class ExerciseVariationViewSet(viewsets.ModelViewSet):
    serializer_class = ExerciseVariationSerializer

    def get_queryset(self):
        queryset = ExerciseVariation.objects.select_related('base_exercise').all()
        exercise = self.request.query_params.get('exercise')

        if exercise:
            queryset = queryset.filter(
                **lookup_by_id_or_slug(exercise, 'base_exercise__id', 'base_exercise__slug')
            )

        return queryset


class WorkoutPlanViewSet(viewsets.ModelViewSet):
    serializer_class = WorkoutPlanSerializer

    def get_queryset(self):
        queryset = (
            WorkoutPlan.objects.all()
            .prefetch_related(
                'items__exercise__muscle_targets__muscle_group',
                'items__variation',
            )
        )
        difficulty = self.request.query_params.get('difficulty')

        return apply_filter(queryset, difficulty, difficulty=difficulty)


class WorkoutExerciseSessionViewSet(viewsets.ModelViewSet):
    serializer_class = WorkoutExerciseSessionSerializer

    def get_queryset(self):
        queryset = (
            WorkoutExerciseSession.objects.all()
            .select_related(
                'workout_item__exercise',
                'workout_item__variation',
                'workout_item__workout_plan',
            )
            .prefetch_related('set_logs')
        )
        workout_item = self.request.query_params.get('workout_item')
        workout_plan = self.request.query_params.get('workout_plan')
        session_date = self.request.query_params.get('session_date')

        queryset = apply_filter(queryset, workout_item, workout_item_id=workout_item)
        queryset = apply_filter(queryset, workout_plan, workout_item__workout_plan_id=workout_plan)
        return apply_filter(queryset, session_date, session_date=session_date)


class RegisterView(generics.CreateAPIView):
    serializer_class = UserRegistrationSerializer
    permission_classes = (permissions.AllowAny,)
