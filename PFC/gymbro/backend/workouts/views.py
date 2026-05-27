from django.contrib.auth.models import User
from django.db import OperationalError, ProgrammingError
from rest_framework import viewsets, generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView

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
    PasswordChangeSerializer,
    UserProfileSerializer,
    WorkoutExerciseSessionSerializer,
    WorkoutPlanSerializer,
    UserRegistrationSerializer,
)
from .models import UserProfile


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
    permission_classes = (permissions.IsAuthenticated,)

    def get_queryset(self):
        queryset = (
            WorkoutPlan.objects.filter(user=self.request.user)
            .prefetch_related(
                'items__exercise__muscle_targets__muscle_group',
                'items__variation',
            )
        )
        difficulty = self.request.query_params.get('difficulty')

        return apply_filter(queryset, difficulty, difficulty=difficulty)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class WorkoutExerciseSessionViewSet(viewsets.ModelViewSet):
    serializer_class = WorkoutExerciseSessionSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_queryset(self):
        queryset = (
            WorkoutExerciseSession.objects.filter(
                workout_item__workout_plan__user=self.request.user
            )
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


class UserProfileView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get_profile(self):
        profile, _ = UserProfile.objects.get_or_create(user=self.request.user)
        return profile

    def get_profile_data(self, profile=None):
        return {
            'username': self.request.user.username,
            'email': self.request.user.email,
            'avatar_data_url': profile.avatar_data_url if profile else '',
        }

    def get(self, request):
        try:
            profile = self.get_profile()
        except (OperationalError, ProgrammingError):
            return Response(self.get_profile_data())

        serializer = UserProfileSerializer(profile)
        return Response(serializer.data)

    def patch(self, request):
        username = request.data.get('username')
        if username is not None:
            username = str(username).strip()
            if not username:
                return Response(
                    {'username': 'El nombre de usuario no puede estar vacio.'},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            if User.objects.exclude(pk=request.user.pk).filter(username=username).exists():
                return Response(
                    {'username': 'Este nombre de usuario ya esta en uso.'},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            request.user.username = username
            request.user.save(update_fields=['username'])

        try:
            profile = self.get_profile()
        except (OperationalError, ProgrammingError):
            return Response(self.get_profile_data())

        if 'avatar_data_url' in request.data:
            profile.avatar_data_url = request.data.get('avatar_data_url') or ''
            profile.save(update_fields=['avatar_data_url', 'updated_at'])

        return Response(self.get_profile_data(profile))


class PasswordChangeView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request):
        serializer = PasswordChangeSerializer(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(status=status.HTTP_204_NO_CONTENT)
