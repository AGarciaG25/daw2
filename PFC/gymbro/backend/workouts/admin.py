from django.contrib import admin

from .models import (
    Exercise,
    ExerciseMuscleTarget,
    ExerciseVariation,
    MuscleGroup,
    WorkoutPlan,
    WorkoutPlanItem,
)


class ExerciseMuscleTargetInline(admin.TabularInline):
    model = ExerciseMuscleTarget
    extra = 1


class ExerciseVariationInline(admin.TabularInline):
    model = ExerciseVariation
    extra = 1


@admin.register(MuscleGroup)
class MuscleGroupAdmin(admin.ModelAdmin):
    list_display = ('name', 'body_region', 'slug')
    search_fields = ('name', 'description')
    prepopulated_fields = {'slug': ('name',)}


@admin.register(Exercise)
class ExerciseAdmin(admin.ModelAdmin):
    list_display = ('name', 'external_id', 'body_part', 'difficulty', 'equipment', 'is_compound')
    list_filter = ('difficulty', 'is_compound', 'body_part')
    search_fields = ('name', 'external_id', 'description', 'equipment', 'body_part')
    prepopulated_fields = {'slug': ('name',)}
    inlines = [ExerciseMuscleTargetInline, ExerciseVariationInline]


class WorkoutPlanItemInline(admin.TabularInline):
    model = WorkoutPlanItem
    extra = 1


@admin.register(WorkoutPlan)
class WorkoutPlanAdmin(admin.ModelAdmin):
    list_display = ('name', 'difficulty', 'days_per_week', 'estimated_duration_minutes')
    list_filter = ('difficulty',)
    search_fields = ('name', 'goal', 'description')
    prepopulated_fields = {'slug': ('name',)}
    inlines = [WorkoutPlanItemInline]
