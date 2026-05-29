from django.urls import path
from rest_framework.routers import DefaultRouter

from .views import (
    ExerciseVariationViewSet,
    ExerciseViewSet,
    LoginView,
    MuscleGroupViewSet,
    PasswordChangeView,
    UserProfileView,
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
    path('login/', LoginView.as_view(), name='login'),
    path('profile/', UserProfileView.as_view(), name='profile'),
    path('profile/password/', PasswordChangeView.as_view(), name='profile-password'),
] + router.urls
