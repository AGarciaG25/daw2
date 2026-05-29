from django.contrib.auth.models import User
from django.db import OperationalError, ProgrammingError
from drf_spectacular.utils import (
    OpenApiParameter,
    OpenApiResponse,
    OpenApiTypes,
    extend_schema,
    extend_schema_view,
    inline_serializer,
)
from rest_framework import viewsets, generics, permissions, serializers, status
from rest_framework.authtoken.serializers import AuthTokenSerializer
from rest_framework.authtoken.views import ObtainAuthToken
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


@extend_schema(
    summary='Iniciar sesion',
    description='Recibe nombre de usuario y contrasena y devuelve un token de autenticacion.',
    tags=['Autenticacion'],
    request=AuthTokenSerializer,
    responses={
        200: inline_serializer(
            name='TokenLoginResponse',
            fields={'token': serializers.CharField()},
        ),
        400: OpenApiResponse(description='Credenciales invalidas.'),
    },
)
class LoginView(ObtainAuthToken):
    pass


@extend_schema_view(
    list=extend_schema(
        summary='Listar grupos musculares',
        description='Devuelve las zonas musculares disponibles. Permite filtrar por region corporal.',
        tags=['Grupos musculares'],
        parameters=[
            OpenApiParameter(
                name='body_region',
                type=OpenApiTypes.STR,
                location=OpenApiParameter.QUERY,
                description='Region corporal asociada al grupo muscular.',
                required=False,
            ),
        ],
    ),
    retrieve=extend_schema(summary='Obtener un grupo muscular', tags=['Grupos musculares']),
    create=extend_schema(summary='Crear un grupo muscular', tags=['Grupos musculares']),
    update=extend_schema(summary='Actualizar un grupo muscular', tags=['Grupos musculares']),
    partial_update=extend_schema(summary='Actualizar parcialmente un grupo muscular', tags=['Grupos musculares']),
    destroy=extend_schema(summary='Eliminar un grupo muscular', tags=['Grupos musculares']),
)
class MuscleGroupViewSet(viewsets.ModelViewSet):
    queryset = MuscleGroup.objects.all()
    serializer_class = MuscleGroupSerializer

    def get_queryset(self):
        queryset = super().get_queryset()
        body_region = self.request.query_params.get('body_region')

        return apply_filter(queryset, body_region, body_region=body_region)


@extend_schema_view(
    list=extend_schema(
        summary='Listar ejercicios',
        description='Devuelve ejercicios con sus zonas musculares y variaciones. Permite filtrar por musculo y dificultad.',
        tags=['Ejercicios'],
        parameters=[
            OpenApiParameter(
                name='muscle_group',
                type=OpenApiTypes.STR,
                location=OpenApiParameter.QUERY,
                description='ID o slug del grupo muscular.',
                required=False,
            ),
            OpenApiParameter(
                name='difficulty',
                type=OpenApiTypes.STR,
                location=OpenApiParameter.QUERY,
                description='Dificultad del ejercicio.',
                required=False,
            ),
        ],
    ),
    retrieve=extend_schema(summary='Obtener un ejercicio', tags=['Ejercicios']),
    create=extend_schema(summary='Crear un ejercicio', tags=['Ejercicios']),
    update=extend_schema(summary='Actualizar un ejercicio', tags=['Ejercicios']),
    partial_update=extend_schema(summary='Actualizar parcialmente un ejercicio', tags=['Ejercicios']),
    destroy=extend_schema(summary='Eliminar un ejercicio', tags=['Ejercicios']),
)
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


@extend_schema_view(
    list=extend_schema(
        summary='Listar variaciones de ejercicios',
        description='Devuelve variaciones de ejercicios. Permite filtrar por ejercicio base usando ID o slug.',
        tags=['Variaciones'],
        parameters=[
            OpenApiParameter(
                name='exercise',
                type=OpenApiTypes.STR,
                location=OpenApiParameter.QUERY,
                description='ID o slug del ejercicio base.',
                required=False,
            ),
        ],
    ),
    retrieve=extend_schema(summary='Obtener una variacion', tags=['Variaciones']),
    create=extend_schema(summary='Crear una variacion', tags=['Variaciones']),
    update=extend_schema(summary='Actualizar una variacion', tags=['Variaciones']),
    partial_update=extend_schema(summary='Actualizar parcialmente una variacion', tags=['Variaciones']),
    destroy=extend_schema(summary='Eliminar una variacion', tags=['Variaciones']),
)
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


@extend_schema_view(
    list=extend_schema(
        summary='Listar rutinas del usuario',
        description='Devuelve solo las rutinas del usuario autenticado. Permite filtrar por dificultad.',
        tags=['Rutinas'],
        parameters=[
            OpenApiParameter(
                name='difficulty',
                type=OpenApiTypes.STR,
                location=OpenApiParameter.QUERY,
                description='Dificultad de la rutina.',
                required=False,
            ),
        ],
    ),
    retrieve=extend_schema(summary='Obtener una rutina del usuario', tags=['Rutinas']),
    create=extend_schema(summary='Crear una rutina', description='Requiere autenticacion por token.', tags=['Rutinas']),
    update=extend_schema(summary='Actualizar una rutina', description='Requiere autenticacion por token.', tags=['Rutinas']),
    partial_update=extend_schema(summary='Actualizar parcialmente una rutina', description='Requiere autenticacion por token.', tags=['Rutinas']),
    destroy=extend_schema(summary='Eliminar una rutina', description='Requiere autenticacion por token.', tags=['Rutinas']),
)
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


@extend_schema_view(
    list=extend_schema(
        summary='Listar sesiones de entrenamiento',
        description='Devuelve solo las sesiones asociadas a rutinas del usuario autenticado.',
        tags=['Sesiones'],
        parameters=[
            OpenApiParameter('workout_item', OpenApiTypes.INT, OpenApiParameter.QUERY, description='ID del ejercicio dentro de la rutina.'),
            OpenApiParameter('workout_plan', OpenApiTypes.INT, OpenApiParameter.QUERY, description='ID de la rutina.'),
            OpenApiParameter('session_date', OpenApiTypes.DATE, OpenApiParameter.QUERY, description='Fecha de la sesion en formato YYYY-MM-DD.'),
        ],
    ),
    retrieve=extend_schema(summary='Obtener una sesion', tags=['Sesiones']),
    create=extend_schema(summary='Crear una sesion', description='Requiere autenticacion por token.', tags=['Sesiones']),
    update=extend_schema(summary='Actualizar una sesion', description='Requiere autenticacion por token.', tags=['Sesiones']),
    partial_update=extend_schema(summary='Actualizar parcialmente una sesion', description='Requiere autenticacion por token.', tags=['Sesiones']),
    destroy=extend_schema(summary='Eliminar una sesion', description='Requiere autenticacion por token.', tags=['Sesiones']),
)
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


@extend_schema(
    summary='Registrar usuario',
    description='Crea una cuenta de usuario para acceder a las funcionalidades privadas de Gymbro.',
    tags=['Autenticacion'],
)
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

    @extend_schema(
        summary='Obtener perfil del usuario',
        description='Devuelve el nombre de usuario, correo e imagen de perfil del usuario autenticado.',
        tags=['Perfil'],
        responses={200: UserProfileSerializer},
    )
    def get(self, request):
        try:
            profile = self.get_profile()
        except (OperationalError, ProgrammingError):
            return Response(self.get_profile_data())

        serializer = UserProfileSerializer(profile)
        return Response(serializer.data)

    @extend_schema(
        summary='Actualizar perfil del usuario',
        description='Permite cambiar el nombre de usuario y la imagen de perfil. El correo se devuelve como solo lectura.',
        tags=['Perfil'],
        request=UserProfileSerializer,
        responses={
            200: UserProfileSerializer,
            400: OpenApiResponse(description='Datos invalidos o nombre de usuario duplicado.'),
        },
    )
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

    @extend_schema(
        summary='Cambiar contrasena',
        description='Cambia la contrasena del usuario autenticado comprobando primero la contrasena actual.',
        tags=['Perfil'],
        request=PasswordChangeSerializer,
        responses={
            204: OpenApiResponse(description='Contrasena actualizada correctamente.'),
            400: OpenApiResponse(description='La contrasena actual no es correcta o la nueva no es valida.'),
        },
    )
    def post(self, request):
        serializer = PasswordChangeSerializer(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(status=status.HTTP_204_NO_CONTENT)
