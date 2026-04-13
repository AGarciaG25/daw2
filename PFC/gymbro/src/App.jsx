import { startTransition, useDeferredValue, useEffect, useEffectEvent, useState } from 'react'

import ExerciseExplorer from './components/ExerciseExplorer'
import StatCard from './components/StatCard'
import './App.css'
import { apiFetch } from './lib/api'

async function requestDashboardData(signal) {
  return Promise.all([
    apiFetch('/api/muscle-groups/', { signal }),
    apiFetch('/api/exercises/', { signal }),
  ])
}

function App() {
  const [muscleGroups, setMuscleGroups] = useState([])
  const [exercises, setExercises] = useState([])
  const [selectedBodyRegion, setSelectedBodyRegion] = useState('all')
  const [selectedMuscleSlug, setSelectedMuscleSlug] = useState('')
  const [selectedDifficulty, setSelectedDifficulty] = useState('all')
  const [selectedExerciseType, setSelectedExerciseType] = useState('all')
  const [sortBy, setSortBy] = useState('name')
  const [selectedExerciseId, setSelectedExerciseId] = useState(null)
  const [searchTerm, setSearchTerm] = useState('')
  const [loading, setLoading] = useState(true)
  const [refreshing, setRefreshing] = useState(false)
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

  async function refreshDashboard() {
    setRefreshing(true)
    setDashboardError('')

    try {
      const [nextMuscleGroups, nextExercises] = await requestDashboardData()
      applyDashboardData(nextMuscleGroups, nextExercises)
    } catch (error) {
      setDashboardError(
        error.message || 'No se ha podido conectar con la API. Comprueba que Django este en marcha.'
      )
    } finally {
      setRefreshing(false)
    }
  }

  const visibleMuscleGroups = muscleGroups.filter((group) => {
    if (selectedBodyRegion !== 'all' && group.body_region !== selectedBodyRegion) {
      return false
    }

    return true
  })

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

    if (selectedDifficulty !== 'all' && exercise.difficulty !== selectedDifficulty) {
      return false
    }

    if (selectedExerciseType === 'compound' && !exercise.is_compound) {
      return false
    }

    if (selectedExerciseType === 'isolation' && exercise.is_compound) {
      return false
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

  const visibleExercises = [...filteredExercises].sort((left, right) => {
    if (sortBy === 'variations') {
      return right.variations.length - left.variations.length || left.name.localeCompare(right.name, 'es')
    }

    if (sortBy === 'updated') {
      return new Date(right.updated_at).getTime() - new Date(left.updated_at).getTime()
    }

    return left.name.localeCompare(right.name, 'es')
  })

  useEffect(() => {
    if (!visibleExercises.length) {
      setSelectedExerciseId(null)
      return
    }

    if (!visibleExercises.some((exercise) => exercise.id === selectedExerciseId)) {
      setSelectedExerciseId(visibleExercises[0].id)
    }
  }, [visibleExercises, selectedExerciseId])

  const selectedExercise =
    visibleExercises.find((exercise) => exercise.id === selectedExerciseId) || null
  const totalVariations = exercises.reduce(
    (currentValue, exercise) => currentValue + exercise.variations.length,
    0
  )
  const visibleVariations = visibleExercises.reduce(
    (currentValue, exercise) => currentValue + exercise.variations.length,
    0
  )
  const activeFiltersCount = [
    selectedBodyRegion !== 'all',
    selectedMuscleSlug !== '',
    selectedDifficulty !== 'all',
    selectedExerciseType !== 'all',
    normalizedSearch !== '',
  ].filter(Boolean).length

  function handleRegionChange(region) {
    startTransition(() => {
      setSelectedBodyRegion(region)

      if (region === 'all') {
        return
      }

      const selectedMuscle = muscleGroups.find((group) => group.slug === selectedMuscleSlug)
      if (selectedMuscle && selectedMuscle.body_region !== region) {
        setSelectedMuscleSlug('')
      }
    })
  }

  function handleMuscleToggle(muscleGroup) {
    startTransition(() => {
      setSelectedBodyRegion(muscleGroup.body_region)
      setSelectedMuscleSlug((currentValue) =>
        currentValue === muscleGroup.slug ? '' : muscleGroup.slug
      )
    })
  }

  function resetFilters() {
    setSelectedBodyRegion('all')
    setSelectedMuscleSlug('')
    setSelectedDifficulty('all')
    setSelectedExerciseType('all')
    setSortBy('name')
    setSearchTerm('')
  }

  return (
    <div className="app-shell">
      <header className="hero">
        <div className="hero__copy">
          <p className="eyebrow">GymBro - Buscador de ejercicios</p>
          <h1>Encuentra ejercicios, variaciones y musculos sin depender de las tablas.</h1>
          <p className="hero__lead">
            Este front ahora esta centrado solo en buscar ejercicios. Puedes filtrar por region
            corporal, zona muscular, dificultad y tipo de ejercicio, y ver cada ficha en detalle.
          </p>
          <div className="hero__actions">
            <button
              className="button button--primary"
              type="button"
              onClick={() =>
                document
                  .getElementById('explorador-ejercicios')
                  ?.scrollIntoView({ behavior: 'smooth', block: 'start' })
              }
            >
              Buscar ejercicios
            </button>
            <button
              className="button button--ghost"
              type="button"
              onClick={refreshDashboard}
              disabled={refreshing}
            >
              {refreshing ? 'Actualizando...' : 'Recargar datos'}
            </button>
          </div>
        </div>

        <aside className="hero__summary">
          <div className="hero__summary-head">
            <span>Resumen del buscador</span>
            <small>{refreshing ? 'Sincronizando con la API' : 'Datos desde /api/'}</small>
          </div>
          <div className="stats-grid">
            <StatCard value={muscleGroups.length} label="Zonas musculares" tone="sand" />
            <StatCard value={exercises.length} label="Ejercicios base" tone="clay" />
            <StatCard value={totalVariations} label="Variaciones totales" tone="olive" />
            <StatCard value={visibleExercises.length} label="Resultados visibles" tone="ink" />
          </div>
          <div className="hero__note">
            <strong>Filtros activos:</strong> {activeFiltersCount} - <strong>Variaciones visibles:</strong>{' '}
            {visibleVariations}
          </div>
        </aside>
      </header>

      {dashboardError ? (
        <div className="feedback feedback--error">
          <strong>No se ha podido cargar la API.</strong>
          <span>{dashboardError}</span>
        </div>
      ) : null}

      <main className="dashboard">
        <ExerciseExplorer
          loading={loading}
          muscleGroups={muscleGroups}
          visibleMuscleGroups={visibleMuscleGroups}
          visibleExercises={visibleExercises}
          selectedBodyRegion={selectedBodyRegion}
          selectedMuscleSlug={selectedMuscleSlug}
          selectedDifficulty={selectedDifficulty}
          selectedExerciseType={selectedExerciseType}
          sortBy={sortBy}
          selectedExercise={selectedExercise}
          selectedExerciseId={selectedExerciseId}
          searchTerm={searchTerm}
          totalExercises={exercises.length}
          activeFiltersCount={activeFiltersCount}
          onSearchTermChange={setSearchTerm}
          onRegionChange={handleRegionChange}
          onMuscleToggle={handleMuscleToggle}
          onExerciseSelect={setSelectedExerciseId}
          onDifficultyChange={setSelectedDifficulty}
          onExerciseTypeChange={setSelectedExerciseType}
          onSortChange={setSortBy}
          onClearMuscleFilter={() => setSelectedMuscleSlug('')}
          onResetFilters={resetFilters}
        />
      </main>
    </div>
  )
}

export default App
