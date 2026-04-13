import { startTransition } from 'react'

import {
  bodyRegionLabels,
  difficultyLabels,
  formatDate,
  getBodyRegionCount,
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
}) {
  return (
    <section id="explorador-ejercicios" className="panel">
      <div className="section-heading">
        <div>
          <p className="section-heading__eyebrow">Buscador</p>
          <h2>Biblioteca de ejercicios</h2>
        </div>
        <span className="section-heading__badge">
          {loading ? 'Cargando...' : `${visibleExercises.length} de ${totalExercises} ejercicios`}
        </span>
      </div>

      <div className="catalog-layout">
        <aside className="filters-panel">
          <div className="stack">
            <div className="stack__header">
              <h3>Busqueda rapida</h3>
              <button className="text-button" type="button" onClick={onResetFilters}>
                Limpiar filtros
              </button>
            </div>

            <label className="field">
              <span>Buscar por nombre, material o variacion</span>
              <input
                type="search"
                placeholder="Press banca, sentadilla, plancha..."
                value={searchTerm}
                onChange={(event) => onSearchTermChange(event.target.value)}
              />
            </label>

            <div className="filter-grid">
              <label className="field">
                <span>Dificultad</span>
                <select
                  value={selectedDifficulty}
                  onChange={(event) => onDifficultyChange(event.target.value)}
                >
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
                <select
                  value={selectedExerciseType}
                  onChange={(event) => onExerciseTypeChange(event.target.value)}
                >
                  {Object.entries(exerciseTypeLabels).map(([value, label]) => (
                    <option key={value} value={value}>
                      {label}
                    </option>
                  ))}
                </select>
              </label>

              <label className="field field--wide">
                <span>Ordenar por</span>
                <select value={sortBy} onChange={(event) => onSortChange(event.target.value)}>
                  {Object.entries(sortLabels).map(([value, label]) => (
                    <option key={value} value={value}>
                      {label}
                    </option>
                  ))}
                </select>
              </label>
            </div>
          </div>

          <div className="stack">
            <div className="stack__header">
              <h3>Regiones corporales</h3>
              <span className="filters-panel__meta">{activeFiltersCount} filtros activos</span>
            </div>
            <div className="chip-row">
              {Object.entries(bodyRegionLabels).map(([value, label]) => (
                <button
                  key={value}
                  type="button"
                  className={`chip ${selectedBodyRegion === value ? 'chip--active' : ''}`}
                  onClick={() => onRegionChange(value)}
                >
                  <span>{label}</span>
                  {value !== 'all' ? (
                    <small>{getBodyRegionCount(muscleGroups, value)}</small>
                  ) : (
                    <small>{muscleGroups.length}</small>
                  )}
                </button>
              ))}
            </div>
          </div>

          <div className="stack">
            <div className="stack__header">
              <h3>Zonas musculares</h3>
              <button className="text-button" type="button" onClick={onClearMuscleFilter}>
                Quitar zona
              </button>
            </div>

            <div className="muscle-grid">
              {visibleMuscleGroups.map((group) => (
                <button
                  key={group.id}
                  type="button"
                  className={`muscle-card ${
                    selectedMuscleSlug === group.slug ? 'muscle-card--selected' : ''
                  }`}
                  onClick={() => onMuscleToggle(group)}
                >
                  <strong>{group.name}</strong>
                  <span>{bodyRegionLabels[group.body_region]}</span>
                  <small>{group.exercise_count} ejercicios</small>
                </button>
              ))}
            </div>
          </div>
        </aside>

        <div className="catalog-content">
          <div className="results-column">
            <div className="results-summary">
              <p>
                Usa los filtros para encontrar ejercicios concretos por musculo, dificultad o tipo.
              </p>
              <strong>{visibleExercises.length} resultados listos para explorar</strong>
            </div>

            <div className="exercise-grid">
              {visibleExercises.map((exercise) => {
                const primaryMuscles = getMuscleTargetNames(exercise, 'primary')

                return (
                  <button
                    key={exercise.id}
                    type="button"
                    className={`exercise-card ${
                      selectedExerciseId === exercise.id ? 'exercise-card--selected' : ''
                    }`}
                    onClick={() =>
                      startTransition(() => {
                        onExerciseSelect(exercise.id)
                      })
                    }
                  >
                    <div className="exercise-card__top">
                      <span className="tag tag--muted">
                        {difficultyLabels[exercise.difficulty] || exercise.difficulty}
                      </span>
                      {exercise.is_compound ? (
                        <span className="tag tag--accent">Compuesto</span>
                      ) : (
                        <span className="tag tag--soft">Aislado</span>
                      )}
                    </div>
                    <h3>{exercise.name}</h3>
                    <p>{exercise.description}</p>
                    <div className="pill-row">
                      {primaryMuscles.map((muscleName) => (
                        <span key={muscleName} className="pill">
                          {muscleName}
                        </span>
                      ))}
                    </div>
                    <div className="exercise-card__meta">
                      <span>{exercise.equipment || 'Sin material especifico'}</span>
                      <strong>{exercise.variations.length} variaciones</strong>
                    </div>
                  </button>
                )
              })}

              {!loading && !visibleExercises.length ? (
                <div className="empty-state">
                  <h3>No hay ejercicios con esos filtros</h3>
                  <p>Prueba otra combinacion de region, dificultad, busqueda o tipo.</p>
                </div>
              ) : null}
            </div>
          </div>

          <aside className="detail-panel">
            {selectedExercise ? (
              <>
                <div className="detail-panel__header">
                  <div>
                    <p className="section-heading__eyebrow">Ficha del ejercicio</p>
                    <h3>{selectedExercise.name}</h3>
                  </div>
                  <span className="detail-panel__date">
                    Alta {formatDate(selectedExercise.created_at)}
                  </span>
                </div>

                <p className="detail-panel__description">{selectedExercise.description}</p>

                <div className="detail-stat-grid">
                  <div className="detail-stat">
                    <span>Dificultad</span>
                    <strong>
                      {difficultyLabels[selectedExercise.difficulty] || selectedExercise.difficulty}
                    </strong>
                  </div>
                  <div className="detail-stat">
                    <span>Material</span>
                    <strong>{selectedExercise.equipment || 'No indicado'}</strong>
                  </div>
                </div>

                <div className="stack">
                  <div className="stack__header">
                    <h4>Musculos que trabaja</h4>
                  </div>
                  <div className="target-stack">
                    {['primary', 'secondary', 'stabilizer'].map((emphasis) => {
                      const labelMap = {
                        primary: 'Principal',
                        secondary: 'Secundario',
                        stabilizer: 'Estabilizador',
                      }
                      const muscles = selectedExercise.muscle_targets.filter(
                        (target) => target.emphasis === emphasis
                      )

                      if (!muscles.length) {
                        return null
                      }

                      return (
                        <div key={emphasis} className="target-group">
                          <span>{labelMap[emphasis]}</span>
                          <div className="pill-row">
                            {muscles.map((target) => (
                              <button
                                key={target.id}
                                type="button"
                                className="pill pill--interactive"
                                onClick={() => onMuscleToggle(target.muscle_group_detail)}
                              >
                                {target.muscle_group_detail.name}
                              </button>
                            ))}
                          </div>
                        </div>
                      )
                    })}
                  </div>
                </div>

                <div className="stack">
                  <div className="stack__header">
                    <h4>Como ejecutarlo</h4>
                  </div>
                  <p className="detail-panel__instructions">
                    {selectedExercise.instructions || 'Este ejercicio no tiene instrucciones aun.'}
                  </p>
                </div>

                <div className="stack">
                  <div className="stack__header">
                    <h4>Variaciones disponibles</h4>
                  </div>
                  <div className="variation-list">
                    {selectedExercise.variations.length ? (
                      selectedExercise.variations.map((variation) => (
                        <article key={variation.id} className="variation-card">
                          <div className="variation-card__head">
                            <strong>{variation.name}</strong>
                            <span>{variation.equipment_override || selectedExercise.equipment}</span>
                          </div>
                          <p>{variation.description}</p>
                          {variation.instructions_override ? (
                            <small>{variation.instructions_override}</small>
                          ) : null}
                        </article>
                      ))
                    ) : (
                      <p className="detail-panel__description">
                        Este ejercicio base todavia no tiene variaciones registradas.
                      </p>
                    )}
                  </div>
                </div>
              </>
            ) : (
              <div className="empty-state">
                <h3>Selecciona un ejercicio</h3>
                <p>Haz clic en una tarjeta para ver sus musculos, instrucciones y variaciones.</p>
              </div>
            )}
          </aside>
        </div>
      </div>
    </section>
  )
}

export default ExerciseExplorer
