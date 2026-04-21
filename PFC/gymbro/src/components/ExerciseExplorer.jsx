import { startTransition, useState } from 'react'
import './ExerciseExplorer.css'
import MuscleBodyMap from './MuscleBodyMap'

import {
  bodyRegionLabels,
  difficultyLabels,
  getMuscleTargetNames,
} from '../lib/helpers'

const exerciseTypeLabels = {
  all: 'Todos',
  compound: 'Compuestos',
  isolation: 'Aislados',
}

const sortLabels = {
  name: 'Nombre',
  variations: 'Mas variaciones',
  updated: 'Mas recientes',
}

function getExerciseAccent(exercise) {
  const primaryMuscle = exercise.muscle_targets.find((target) => target.emphasis === 'primary')
  const region = primaryMuscle?.muscle_group_detail?.body_region

  if (region === 'lower_body') {
    return 'exercise-card--legs'
  }

  if (region === 'core') {
    return 'exercise-card--core'
  }

  if (region === 'full_body') {
    return 'exercise-card--full'
  }

  return 'exercise-card--upper'
}

function ExerciseIllustration({ exercise, large = false }) {
  const initials = exercise.name
    .split(' ')
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('')

  const muscles = getMuscleTargetNames(exercise, 'primary').slice(0, 2)
  const frameUrls = exercise.demo_frame_urls || []

  return (
    <div className="exercise-illustration">
      {exercise.demo_gif_url ? (
        <div className={`exercise-illustration__media ${large ? 'exercise-illustration__media--large' : ''}`}>
          <img
            src={exercise.demo_gif_url}
            alt={`Demostracion de ${exercise.name}`}
            loading="lazy"
          />
        </div>
      ) : frameUrls.length ? (
        <div
          className={`exercise-illustration__sequence ${
            large ? 'exercise-illustration__sequence--large' : ''
          }`}
        >
          <img
            src={frameUrls[0]}
            alt={`Demostracion inicial de ${exercise.name}`}
            className="exercise-illustration__frame exercise-illustration__frame--base"
            loading="lazy"
          />
          {frameUrls[1] ? (
            <img
              src={frameUrls[1]}
              alt={`Demostracion final de ${exercise.name}`}
              className="exercise-illustration__frame exercise-illustration__frame--alt"
              loading="lazy"
            />
          ) : null}
        </div>
      ) : (
        <div className="exercise-illustration__figure">
          <span>{initials || 'EX'}</span>
        </div>
      )}
      <div className="exercise-illustration__targets">
        {muscles.map((muscle) => (
          <span key={muscle}>{muscle}</span>
        ))}
      </div>
    </div>
  )
}

function ExerciseExplorer({
  loading,
  muscleGroups,
  visibleMuscleGroups,
  visibleExercises,
  selectedBodyRegion,
  selectedMuscleSlug,
  selectedDifficulty,
  selectedExerciseType,
  sortBy,
  selectedExercise,
  selectedExerciseId,
  searchTerm,
  totalExercises,
  activeFiltersCount,
  onSearchTermChange,
  onRegionChange,
  onMuscleToggle,
  onExerciseSelect,
  onDifficultyChange,
  onExerciseTypeChange,
  onSortChange,
  onClearMuscleFilter,
  onResetFilters,
  refreshing,
  onRefresh,
}) {
  const [showFilters, setShowFilters] = useState(false)

  return (
    <section id="explorador-ejercicios" className="library-shell">
      <header className="library-topbar">
        <div>
          <p className="section-heading__eyebrow">Buscador de ejercicios</p>
          <h1>Encuentra ejercicios con una estructura mas visual</h1>
        </div>
        <div className="library-stats">
          <span>{muscleGroups.length} grupos</span>
          <span>{visibleExercises.length} visibles</span>
          <span>{activeFiltersCount} filtros</span>
        </div>
      </header>

      <div className="library-searchbar">
        <label className="library-searchbar__input">
          <svg viewBox="0 0 24 24" aria-hidden="true">
            <path d="M10.5 18a7.5 7.5 0 1 1 0-15 7.5 7.5 0 0 1 0 15z M16 16l5 5" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round" />
          </svg>
          <input
            type="search"
            placeholder="Buscar ejercicios"
            value={searchTerm}
            onChange={(event) => onSearchTermChange(event.target.value)}
          />
        </label>

        <button type="button" className="library-icon-button" onClick={() => setShowFilters((value) => !value)}>
          <svg viewBox="0 0 24 24" aria-hidden="true">
            <path d="M4 7h16 M7 12h10 M10 17h4" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
          </svg>
          <span>Filtros</span>
        </button>
      </div>

      <MuscleBodyMap
        muscleGroups={muscleGroups}
        selectedMuscleSlug={selectedMuscleSlug}
        onMuscleToggle={onMuscleToggle}
        onClear={onClearMuscleFilter}
      />

      <div className="muscle-rail">
        <button
          type="button"
          className={`muscle-pill ${selectedBodyRegion === 'all' && !selectedMuscleSlug ? 'muscle-pill--active' : ''}`}
          onClick={() => onRegionChange('all')}
        >
          <strong>Todo</strong>
          <small>{totalExercises}</small>
        </button>

        {visibleMuscleGroups.map((group) => (
          <button
            key={group.id}
            type="button"
            className={`muscle-pill ${selectedMuscleSlug === group.slug ? 'muscle-pill--active' : ''}`}
            onClick={() => onMuscleToggle(group)}
          >
            <strong>{group.name}</strong>
            <small>{group.exercise_count}</small>
          </button>
        ))}
      </div>

      {showFilters ? (
        <section className="advanced-filters">
          <div className="advanced-filters__grid">
            <label className="field">
              <span>Region</span>
              <select value={selectedBodyRegion} onChange={(event) => onRegionChange(event.target.value)}>
                {Object.entries(bodyRegionLabels).map(([value, label]) => (
                  <option key={value} value={value}>
                    {label}
                  </option>
                ))}
              </select>
            </label>

            <label className="field">
              <span>Dificultad</span>
              <select value={selectedDifficulty} onChange={(event) => onDifficultyChange(event.target.value)}>
                <option value="all">Todas</option>
                {Object.entries(difficultyLabels).map(([value, label]) => (
                  <option key={value} value={value}>
                    {label}
                  </option>
                ))}
              </select>
            </label>

            <label className="field">
              <span>Tipo</span>
              <select value={selectedExerciseType} onChange={(event) => onExerciseTypeChange(event.target.value)}>
                {Object.entries(exerciseTypeLabels).map(([value, label]) => (
                  <option key={value} value={value}>
                    {label}
                  </option>
                ))}
              </select>
            </label>

            <label className="field">
              <span>Orden</span>
              <select value={sortBy} onChange={(event) => onSortChange(event.target.value)}>
                {Object.entries(sortLabels).map(([value, label]) => (
                  <option key={value} value={value}>
                    {label}
                  </option>
                ))}
              </select>
            </label>
          </div>

          <div className="advanced-filters__actions">
            <button type="button" className="button button--ghost" onClick={onClearMuscleFilter}>
              Quitar zona muscular
            </button>
            <button type="button" className="button button--ghost" onClick={onResetFilters}>
              Limpiar filtros
            </button>
            <button type="button" className="button button--primary" onClick={onRefresh} disabled={refreshing}>
              {refreshing ? 'Actualizando...' : 'Recargar'}
            </button>
          </div>
        </section>
      ) : null}

      {selectedExercise ? (
        <section className="exercise-spotlight">
          <div className="exercise-spotlight__layout">
            <div>
              <p className="section-heading__eyebrow">Ejercicio seleccionado</p>
              <h2>{selectedExercise.name}</h2>
              <p>{selectedExercise.description}</p>
              <div className="exercise-spotlight__meta">
                <span>{difficultyLabels[selectedExercise.difficulty] || selectedExercise.difficulty}</span>
                <span>{selectedExercise.equipment || 'Sin material especificado'}</span>
                <span>{selectedExercise.variations.length} variaciones</span>
              </div>
            </div>

            <ExerciseIllustration exercise={selectedExercise} large />
          </div>
        </section>
      ) : null}

      <section className="exercise-library-grid">
        {visibleExercises.map((exercise) => {
          const primaryMuscles = getMuscleTargetNames(exercise, 'primary').slice(0, 2)

          return (
            <button
              key={exercise.id}
              type="button"
              className={`exercise-card exercise-card--visual ${getExerciseAccent(exercise)} ${
                selectedExerciseId === exercise.id ? 'exercise-card--selected' : ''
              }`}
              onClick={() =>
                startTransition(() => {
                  onExerciseSelect(exercise.id)
                })
              }
            >
              <div className="exercise-card__icons">
                <span className="exercise-card__bookmark">+</span>
                <span className="exercise-card__hint">?</span>
              </div>

              <ExerciseIllustration exercise={exercise} />

              <div className="exercise-card__content">
                <h3>{exercise.name}</h3>
                <p>{primaryMuscles.join(', ') || 'Trabajo general'}</p>
                <div className="exercise-card__footer">
                  <span className="tag tag--muted">
                    {exercise.is_compound ? 'Compuesto' : 'Aislado'}
                  </span>
                  <span className="tag tag--soft">
                    {difficultyLabels[exercise.difficulty] || exercise.difficulty}
                  </span>
                </div>
              </div>
            </button>
          )
        })}

        {!loading && !visibleExercises.length ? (
          <div className="empty-state">
            <h3>No hay ejercicios con esos filtros</h3>
            <p>Prueba otra combinacion de busqueda, region o dificultad.</p>
          </div>
        ) : null}
      </section>
    </section>
  )
}

export default ExerciseExplorer
