import { startTransition, useDeferredValue, useEffect, useEffectEvent, useState } from 'react'
import ExerciseExplorer from '../components/ExerciseExplorer'
import { apiFetch } from '../lib/api'

async function requestDashboardData(signal) {
  return Promise.all([
    apiFetch('/api/muscle-groups/', { signal }),
    apiFetch('/api/exercises/', { signal }),
  ])
}

export default function ExercisesPage() {
  const [muscleGroups, setMuscleGroups] = useState([])
  const [exercises, setExercises] = useState([])
  const [selectedBodyRegion, setSelectedBodyRegion] = useState('all')
  const [selectedMuscleSlug, setSelectedMuscleSlug] = useState('')
  const [selectedExerciseId, setSelectedExerciseId] = useState(null)
  const [searchTerm, setSearchTerm] = useState('')
  const [loading, setLoading] = useState(true)
  const [dashboardError, setDashboardError] = useState('')

  const deferredSearchTerm = useDeferredValue(searchTerm)

  function applyDashboardData(nextMuscleGroups, nextExercises) {
    setMuscleGroups(nextMuscleGroups)
    setExercises(nextExercises)

    setSelectedExerciseId((currentValue) => {
      if (nextExercises.some((exercise) => exercise.id === currentValue)) {
        return currentValue
      }
      return nextExercises[0]?.id ?? null
    })
  }

  const loadDashboardOnMount = useEffectEvent(async (signal) => {
    setLoading(true)
    setDashboardError('')

    try {
      const [nextMuscleGroups, nextExercises] = await requestDashboardData(signal)
      applyDashboardData(nextMuscleGroups, nextExercises)
    } catch (error) {
      if (error.name !== 'AbortError') {
        setDashboardError(
          error.message ||
            'No se ha podido conectar con la API. Comprueba que Django este en marcha.'
        )
      }
    } finally {
      setLoading(false)
    }
  })

  useEffect(() => {
    const controller = new AbortController()
    loadDashboardOnMount(controller.signal)
    return () => controller.abort()
  }, [])

  const normalizedSearch = deferredSearchTerm.trim().toLowerCase()
  const filteredExercises = exercises.filter((exercise) => {
    if (selectedBodyRegion !== 'all') {
      const belongsToRegion = exercise.muscle_targets.some(
        (target) => target.muscle_group_detail.body_region === selectedBodyRegion
      )
      if (!belongsToRegion) {
        return false
      }
    }

    if (selectedMuscleSlug) {
      const belongsToMuscle = exercise.muscle_targets.some(
        (target) => target.muscle_group_detail.slug === selectedMuscleSlug
      )
      if (!belongsToMuscle) {
        return false
      }
    }

    if (!normalizedSearch) {
      return true
    }

    const searchableText = [
      exercise.name,
      exercise.description,
      exercise.instructions,
      exercise.equipment,
      ...exercise.muscle_targets.map((target) => target.muscle_group_detail.name),
      ...exercise.variations.map((variation) => variation.name),
    ]
      .join(' ')
      .toLowerCase()

    return searchableText.includes(normalizedSearch)
  })

  const visibleExercises = [...filteredExercises].sort((left, right) =>
    left.name.localeCompare(right.name, 'es')
  )

  useEffect(() => {
    if (!visibleExercises.length) {
      setSelectedExerciseId(null)
      return
    }
    if (!visibleExercises.some((exercise) => exercise.id === selectedExerciseId)) {
      setSelectedExerciseId(visibleExercises[0].id)
    }
  }, [visibleExercises, selectedExerciseId])

  function handleMuscleToggle(muscleGroup) {
    startTransition(() => {
      const isSelected = selectedMuscleSlug === muscleGroup.slug
      setSelectedMuscleSlug(isSelected ? '' : muscleGroup.slug)
      setSelectedBodyRegion(isSelected ? 'all' : muscleGroup.body_region)
    })
  }

  function clearMuscleFilter() {
    setSelectedBodyRegion('all')
    setSelectedMuscleSlug('')
  }

  return (
    <div className="app-shell">
      {dashboardError ? (
        <div className="feedback feedback--error">
          <strong>No se ha podido cargar la API.</strong>
          <span>{dashboardError}</span>
        </div>
      ) : null}
      <ExerciseExplorer
        loading={loading}
        muscleGroups={muscleGroups}
        visibleExercises={visibleExercises}
        selectedMuscleSlug={selectedMuscleSlug}
        selectedExerciseId={selectedExerciseId}
        searchTerm={searchTerm}
        onSearchTermChange={setSearchTerm}
        onMuscleToggle={handleMuscleToggle}
        onExerciseSelect={setSelectedExerciseId}
        onClearMuscleFilter={clearMuscleFilter}
      />
    </div>
  )
}
