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


class MuscleGroupViewSet(viewsets.ModelViewSet):
    queryset = MuscleGroup.objects.all()
    serializer_class = MuscleGroupSerializer

    def get_queryset(self):
        queryset = super().get_queryset()
        body_region = self.request.query_params.get('body_region')

        if body_region:
            queryset = queryset.filter(body_region=body_region)

        return queryset


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
            lookup = {'muscle_targets__muscle_group__slug': muscle_group}
            if muscle_group.isdigit():
                lookup = {'muscle_targets__muscle_group__id': muscle_group}
            queryset = queryset.filter(**lookup)

        if difficulty:
            queryset = queryset.filter(difficulty=difficulty)

        return queryset.distinct()


class ExerciseVariationViewSet(viewsets.ModelViewSet):
    serializer_class = ExerciseVariationSerializer

    def get_queryset(self):
        queryset = ExerciseVariation.objects.select_related('base_exercise').all()
        exercise = self.request.query_params.get('exercise')

        if exercise:
            lookup = {'base_exercise__slug': exercise}
            if exercise.isdigit():
                lookup = {'base_exercise__id': exercise}
            queryset = queryset.filter(**lookup)

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

        if difficulty:
            queryset = queryset.filter(difficulty=difficulty)

        return queryset


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

        if workout_item:
            queryset = queryset.filter(workout_item_id=workout_item)

        if workout_plan:
            queryset = queryset.filter(workout_item__workout_plan_id=workout_plan)

        if session_date:
            queryset = queryset.filter(session_date=session_date)

        return queryset

class RegisterView(generics.CreateAPIView):
    serializer_class = UserRegistrationSerializer
    permission_classes = (permissions.AllowAny,)
