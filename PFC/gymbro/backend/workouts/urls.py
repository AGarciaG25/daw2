from rest_framework.routers import DefaultRouter

from .views import (
    ExerciseVariationViewSet,
    ExerciseViewSet,
    MuscleGroupViewSet,
    WorkoutPlanViewSet,
)

router = DefaultRouter()
router.register('muscle-groups', MuscleGroupViewSet, basename='muscle-group')
router.register('exercises', ExerciseViewSet, basename='exercise')
router.register('variations', ExerciseVariationViewSet, basename='variation')
router.register('workout-plans', WorkoutPlanViewSet, basename='workout-plan')

urlpatterns = router.urls
