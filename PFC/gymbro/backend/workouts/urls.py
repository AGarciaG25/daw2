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
router.register('muscle-groups', MuscleGroupViewSet, basename='muscle-group')
router.register('exercises', ExerciseViewSet, basename='exercise')
router.register('variations', ExerciseVariationViewSet, basename='variation')
router.register('workout-plans', WorkoutPlanViewSet, basename='workout-plan')
router.register('workout-sessions', WorkoutExerciseSessionViewSet, basename='workout-session')

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', obtain_auth_token, name='login'),
] + router.urls
