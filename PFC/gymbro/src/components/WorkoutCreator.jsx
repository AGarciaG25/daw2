import { useDeferredValue, useMemo, useState } from 'react'
import './WorkoutCreator.css'

import { difficultyLabels, getMuscleTargetNames } from '../lib/helpers'

const REST_OPTIONS = [45, 60, 75, 90, 120, 150, 180]
const RIR_OPTIONS = ['', '0', '1', '2', '3', '4+']

function getExercisePreview(exercise) {
  if (!exercise) {
    return ''
  }

  return exercise.demo_gif_url || exercise.demo_frame_urls?.[0] || ''
}

function getExerciseAccent(exercise) {
  const primaryTarget = exercise?.muscle_targets?.find((target) => target.emphasis === 'primary')
  return primaryTarget?.muscle_group_detail?.name || exercise?.body_part || 'Trabajo general'
}

function ExerciseThumb({ exercise, alt }) {
  const previewUrl = getExercisePreview(exercise)
  const initials = exercise?.name
    ?.split(' ')
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('')

  if (previewUrl) {
    return <img src={previewUrl} alt={alt} className="routine-thumb routine-thumb--image" loading="lazy" />
  }

  return (
    <div className="routine-thumb routine-thumb--fallback" aria-hidden="true">
      <span>{initials || 'RT'}</span>
    </div>
  )
}

function WorkoutCreator({
  exercises,
  workoutForm,
  formError,
  formSuccess,
  submitting,
  onSubmit,
  onFormChange,
  onItemChange,
  onAssignExercise,
  onAddItem,
  onRemoveItem,
  onAddSet,
  onSetChange,
  onRemoveSet,
  onReset,
}) {
  const [searchTerm, setSearchTerm] = useState('')
  const deferredSearchTerm = useDeferredValue(searchTerm)

  const normalizedSearch = deferredSearchTerm.trim().toLowerCase()
  const exerciseUsage = useMemo(
    () =>
      workoutForm.items.reduce((accumulator, item) => {
        if (!item.exercise) {
          return accumulator
        }

        accumulator[item.exercise] = (accumulator[item.exercise] || 0) + 1
        return accumulator
      }, {}),
    [workoutForm.items]
  )

  const visibleExercises = useMemo(() => {
    const nextExercises = exercises.filter((exercise) => {
      if (!normalizedSearch) {
        return true
      }

      const searchableText = [
        exercise.name,
        exercise.description,
        exercise.equipment,
        exercise.body_part,
        ...exercise.muscle_targets.map((target) => target.muscle_group_detail.name),
      ]
        .join(' ')
        .toLowerCase()

      return searchableText.includes(normalizedSearch)
    })

    return nextExercises.sort((left, right) => left.name.localeCompare(right.name, 'es'))
  }, [exercises, normalizedSearch])

  return (
    <section id="creador-tabla" className="routine-workspace">
      <div className="routine-workspace__breadcrumbs">
        <span>Library</span>
        <span>/</span>
        <span>Rutinas</span>
        <span>/</span>
        <strong>{workoutForm.name || 'Nueva rutina'}</strong>
      </div>

      <form className="routine-workspace__shell" onSubmit={onSubmit}>
        <section className="routine-editor">
          <header className="routine-editor__header">
            <div className="routine-editor__identity">
              <div className="routine-editor__cover" aria-hidden="true">
                <svg viewBox="0 0 24 24">
                  <path
                    d="M6 7h12a2 2 0 0 1 2 2v6a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2z M8 15l2.8-3.3a1 1 0 0 1 1.6 0l2.1 2.5 1.6-1.8a1 1 0 0 1 1.5 0L19 14"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.6"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  />
                </svg>
              </div>

              <div className="routine-editor__titleblock">
                <input
                  type="text"
                  className="routine-editor__name"
                  value={workoutForm.name}
                  onChange={(event) => onFormChange('name', event.target.value)}
                  placeholder="Mi rutina"
                  required
                />
                <div className="routine-editor__meta">
                  <span>{workoutForm.items.length} ejercicios</span>
                  <span>{workoutForm.estimatedDuration} min</span>
                </div>
              </div>
            </div>

            <div className="routine-editor__actions">
              <button className="routine-action routine-action--primary" type="submit" disabled={submitting}>
                {submitting ? 'Guardando...' : 'Guardar'}
              </button>
              <button className="routine-action" type="button" onClick={onReset}>
                Reiniciar
              </button>
            </div>
          </header>

          <div className="routine-editor__summary">
            <label className="routine-field routine-field--description">
              <textarea
                rows="3"
                placeholder="Describe tu rutina..."
                value={workoutForm.description}
                onChange={(event) => onFormChange('description', event.target.value)}
              />
            </label>

            <div className="routine-editor__settings">
              <label className="routine-field">
                <span>Objetivo</span>
                <input
                  type="text"
                  placeholder="Hipertrofia, fuerza, movilidad..."
                  value={workoutForm.goal}
                  onChange={(event) => onFormChange('goal', event.target.value)}
                  required
                />
              </label>

              <label className="routine-field">
                <span>Dificultad</span>
                <select
                  value={workoutForm.difficulty}
                  onChange={(event) => onFormChange('difficulty', event.target.value)}
                >
                  {Object.entries(difficultyLabels).map(([value, label]) => (
                    <option key={value} value={value}>
                      {label}
                    </option>
                  ))}
                </select>
              </label>

              <label className="routine-field">
                <span>Dias</span>
                <input
                  type="number"
                  min="1"
                  max="7"
                  value={workoutForm.daysPerWeek}
                  onChange={(event) => onFormChange('daysPerWeek', event.target.value)}
                />
              </label>

              <label className="routine-field">
                <span>Duracion</span>
                <input
                  type="number"
                  min="15"
                  step="5"
                  value={workoutForm.estimatedDuration}
                  onChange={(event) => onFormChange('estimatedDuration', event.target.value)}
                />
              </label>
            </div>
          </div>

          {formError ? (
            <div className="feedback feedback--error">
              <strong>No se ha podido guardar la rutina.</strong>
              <span>{formError}</span>
            </div>
          ) : null}

          {formSuccess ? (
            <div className="feedback feedback--success">
              <strong>Rutina guardada.</strong>
              <span>{formSuccess}</span>
            </div>
          ) : null}

          <div className="routine-blocklist__header">
            <div>
              <p className="section-heading__eyebrow">Editor</p>
              <h3>Construye tu sesion ejercicio a ejercicio</h3>
            </div>
            <button className="routine-action" type="button" onClick={() => onAddItem()}>
              + Bloque vacio
            </button>
          </div>

          {workoutForm.items.length ? (
            <div className="routine-blocklist">
              {workoutForm.items.map((item, index) => {
                const selectedExercise = exercises.find(
                  (exercise) => String(exercise.id) === String(item.exercise)
                )
                const variationOptions = selectedExercise?.variations || []
                const primaryMuscles = selectedExercise
                  ? getMuscleTargetNames(selectedExercise, 'primary').slice(0, 2)
                  : []

                return (
                  <article key={item.id} className="routine-block">
                    <header className="routine-block__header">
                      <div className="routine-block__identity">
                        <ExerciseThumb
                          exercise={selectedExercise}
                          alt={selectedExercise ? `Vista previa de ${selectedExercise.name}` : 'Vista previa'}
                        />

                        <div>
                          <strong>
                            {selectedExercise?.name || `Bloque ${index + 1}`}
                          </strong>
                          <p>{primaryMuscles.join(', ') || 'Selecciona un ejercicio de la biblioteca'}</p>
                        </div>
                      </div>

                      <button className="routine-icon-button" type="button" onClick={() => onRemoveItem(item.id)}>
                        ×
                      </button>
                    </header>

                    <div className="routine-block__grid">
                      <label className="routine-field">
                        <span>Dia</span>
                        <input
                          type="text"
                          value={item.dayLabel}
                          onChange={(event) => onItemChange(item.id, 'dayLabel', event.target.value)}
                        />
                      </label>

                      <label className="routine-field routine-field--wide">
                        <span>Ejercicio</span>
                        <select
                          value={item.exercise}
                          onChange={(event) => onAssignExercise(item.id, event.target.value)}
                          required
                        >
                          <option value="">Selecciona un ejercicio</option>
                          {exercises.map((exercise) => (
                            <option key={exercise.id} value={exercise.id}>
                              {exercise.name}
                            </option>
                          ))}
                        </select>
                      </label>

                      <label className="routine-field routine-field--wide">
                        <span>Variacion</span>
                        <select
                          value={item.variation}
                          onChange={(event) => onItemChange(item.id, 'variation', event.target.value)}
                          disabled={!selectedExercise}
                        >
                          <option value="">Version base</option>
                          {variationOptions.map((variation) => (
                            <option key={variation.id} value={variation.id}>
                              {variation.name}
                            </option>
                          ))}
                        </select>
                      </label>
                    </div>

                    <label className="routine-field routine-field--description">
                      <textarea
                        rows="2"
                        placeholder="Add note..."
                        value={item.notes}
                        onChange={(event) => onItemChange(item.id, 'notes', event.target.value)}
                      />
                    </label>

                    <div className="routine-rest">
                      <span>Rest:</span>
                      <select
                        value={item.restSeconds}
                        onChange={(event) => onItemChange(item.id, 'restSeconds', event.target.value)}
                      >
                        {REST_OPTIONS.map((seconds) => (
                          <option key={seconds} value={seconds}>
                            {seconds >= 60 ? `${Math.floor(seconds / 60)}m ${seconds % 60}s` : `${seconds}s`}
                          </option>
                        ))}
                      </select>
                    </div>

                    <div className="routine-set-table">
                      <div className="routine-set-table__header">
                        <span>Set</span>
                        <span>Weight</span>
                        <span>Repetitions</span>
                        <span>RIR</span>
                        <span />
                      </div>

                      {item.setEntries.map((entry, setIndex) => (
                        <div key={entry.id} className="routine-set-table__row">
                          <span className="routine-set-table__index">{setIndex + 1}</span>
                          <input
                            type="text"
                            placeholder="Weight"
                            value={entry.weight}
                            onChange={(event) => onSetChange(item.id, entry.id, 'weight', event.target.value)}
                          />
                          <input
                            type="text"
                            placeholder="10"
                            value={entry.reps}
                            onChange={(event) => onSetChange(item.id, entry.id, 'reps', event.target.value)}
                          />
                          <select
                            value={entry.rir}
                            onChange={(event) => onSetChange(item.id, entry.id, 'rir', event.target.value)}
                          >
                            {RIR_OPTIONS.map((option) => (
                              <option key={option || 'empty'} value={option}>
                                {option || '—'}
                              </option>
                            ))}
                          </select>
                          <button
                            className="routine-icon-button routine-icon-button--danger"
                            type="button"
                            onClick={() => onRemoveSet(item.id, entry.id)}
                            disabled={item.setEntries.length === 1}
                          >
                            ×
                          </button>
                        </div>
                      ))}

                      <button className="routine-add-set" type="button" onClick={() => onAddSet(item.id)}>
                        + Add set
                      </button>
                    </div>

                    <div className="routine-block__footer">
                      <span>{item.setEntries.length} series</span>
                      <span>{getExerciseAccent(selectedExercise)}</span>
                    </div>
                  </article>
                )
              })}
            </div>
          ) : (
            <div className="routine-empty">
              <h3>Tu rutina esta vacia</h3>
              <p>Usa la biblioteca de la derecha para ir agregando ejercicios y montar la sesion.</p>
            </div>
          )}
        </section>

        <aside className="routine-library">
          <header className="routine-library__header">
            <div>
              <p className="section-heading__eyebrow">Biblioteca</p>
              <h3>Elige ejercicios para tu rutina</h3>
            </div>
            <span className="routine-library__count">{visibleExercises.length}</span>
          </header>

          <label className="routine-library__search">
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <path
                d="M10.5 18a7.5 7.5 0 1 1 0-15 7.5 7.5 0 0 1 0 15z M16 16l5 5"
                fill="none"
                stroke="currentColor"
                strokeWidth="1.7"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
            </svg>
            <input
              type="search"
              placeholder="Buscar ejercicio"
              value={searchTerm}
              onChange={(event) => setSearchTerm(event.target.value)}
            />
          </label>

          <div className="routine-library__list">
            {visibleExercises.map((exercise) => {
              const primaryMuscles = getMuscleTargetNames(exercise, 'primary').slice(0, 2)
              const usageCount = exerciseUsage[String(exercise.id)] || 0

              return (
                <article key={exercise.id} className="routine-library__item">
                  <div className="routine-library__item-main">
                    <ExerciseThumb exercise={exercise} alt={`Vista previa de ${exercise.name}`} />
                    <div className="routine-library__item-copy">
                      <strong>{exercise.name}</strong>
                      <span>{primaryMuscles.join(', ') || exercise.body_part || 'Trabajo general'}</span>
                      {usageCount ? <small>En rutina: {usageCount}</small> : null}
                    </div>
                  </div>

                  <button
                    type="button"
                    className="routine-icon-button routine-icon-button--add"
                    onClick={() => onAddItem(String(exercise.id))}
                    aria-label={`Agregar ${exercise.name}`}
                  >
                    +
                  </button>
                </article>
              )
            })}
          </div>
        </aside>
      </form>
    </section>
  )
}

export default WorkoutCreator
