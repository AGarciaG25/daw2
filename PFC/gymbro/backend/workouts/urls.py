from django.urls import path
from rest_framework.routers import DefaultRouter
from rest_framework.authtoken.views import obtain_auth_token

from .views import (
    ExerciseVariationViewSet,
    ExerciseViewSet,
    MuscleGroupViewSet,
    WorkoutExerciseSessionViewSet,
    WorkoutPlanViewSet,
    RegisterView,
)

router = DefaultRouter()

for prefix, viewset, basename in (
    ('muscle-groups', MuscleGroupViewSet, 'muscle-group'),
    ('exercises', ExerciseViewSet, 'exercise'),
    ('variations', ExerciseVariationViewSet, 'variation'),
    ('workout-plans', WorkoutPlanViewSet, 'workout-plan'),
    ('workout-sessions', WorkoutExerciseSessionViewSet, 'workout-session'),
):
    router.register(prefix, viewset, basename=basename)

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', obtain_auth_token, name='login'),
] + router.urls
