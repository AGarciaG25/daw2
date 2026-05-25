import { startTransition, useEffect, useState } from 'react'
import './ExerciseExplorer.css'
import MuscleBodyMap from './MuscleBodyMap'

import {
  difficultyLabels,
  getMuscleTargetNames,
} from '../lib/helpers'

const accentByRegion = {
  tren_inferior: 'exercise-card--legs',
  core: 'exercise-card--core',
  cuerpo_completo: 'exercise-card--full',
}

function cx(...classes) {
  return classes.filter(Boolean).join(' ')
}

function getExerciseAccent(exercise) {
  const primaryMuscle = exercise.muscle_targets.find((target) => target.emphasis === 'principal')
  return accentByRegion[primaryMuscle?.muscle_group_detail?.body_region] || 'exercise-card--upper'
}

function ExerciseIllustration({ exercise, large = false }) {
  const initials = exercise.name
    .split(' ')
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('')

  const muscles = getMuscleTargetNames(exercise, 'principal').slice(0, 2)
  const frameUrls = exercise.demo_frame_urls || []
  const visualSizeClass = large && 'exercise-illustration__visual--large'

  return (
    <div className="exercise-illustration">
      {exercise.demo_gif_url ? (
        <div className={cx('exercise-illustration__visual', visualSizeClass)}>
          <img
            src={exercise.demo_gif_url}
            alt={`Demostracion de ${exercise.name}`}
            loading="lazy"
          />
        </div>
      ) : frameUrls.length ? (
        <div className={cx('exercise-illustration__visual', 'exercise-illustration__sequence', visualSizeClass)}>
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
        <div className={cx('exercise-illustration__visual', 'exercise-illustration__figure', visualSizeClass)}>
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

function getTargetsByEmphasis(exercise, emphasis) {
  return exercise.muscle_targets.filter((target) => target.emphasis === emphasis)
}

function ExerciseTargetList({ title, targets, emptyText }) {
  return (
    <div className="exercise-modal__target-group">
      <h3>{title}</h3>
      {targets.length ? (
        <ul>
          {targets.map((target) => (
            <li key={target.id}>{target.muscle_group_detail.name}</li>
          ))}
        </ul>
      ) : (
        <p>{emptyText}</p>
      )}
    </div>
  )
}

function ExerciseDetailModal({ exercise, onClose }) {
  const primaryTargets = getTargetsByEmphasis(exercise, 'principal')
  const secondaryTargets = getTargetsByEmphasis(exercise, 'secundario')

  useEffect(() => {
    function handleKeyDown(event) {
      if (event.key === 'Escape') {
        onClose()
      }
    }

    document.addEventListener('keydown', handleKeyDown)
    return () => document.removeEventListener('keydown', handleKeyDown)
  }, [onClose])

  return (
    <div className="exercise-modal" role="dialog" aria-modal="true" aria-labelledby="exercise-modal-title">
      <button type="button" className="exercise-modal__backdrop" aria-label="Cerrar detalle" onClick={onClose} />
      <article className="exercise-modal__panel">
        <header className="exercise-modal__header">
          <div>
            <p className="section-heading__eyebrow">Detalle del ejercicio</p>
            <h2 id="exercise-modal-title">{exercise.name}</h2>
          </div>
          <button type="button" className="exercise-modal__close" aria-label="Cerrar" onClick={onClose} />
        </header>

        <div className="exercise-modal__grid">
          <div className="exercise-modal__visual-column">
            <section className="exercise-modal__card exercise-modal__video" aria-label="Demostracion del ejercicio">
              <div className="exercise-modal__section-heading">
                <p className="exercise-modal__section-label">Demostracion</p>
                <h3>Vista del movimiento</h3>
              </div>
              <ExerciseIllustration exercise={exercise} large />
            </section>
          </div>

          <div className="exercise-modal__info-column">
            <section className="exercise-modal__card exercise-modal__summary" aria-label="Resumen del ejercicio">
              <div className="exercise-modal__section-heading">
                <p className="exercise-modal__section-label">Resumen</p>
                <h3>Informacion clave</h3>
              </div>
              <div className="exercise-modal__meta">
                <span>{difficultyLabels[exercise.difficulty] || exercise.difficulty}</span>
                <span>{exercise.equipment || 'Sin material'}</span>
                <span>{exercise.is_compound ? 'Compuesto' : 'Aislado'}</span>
              </div>
              <p>{exercise.description}</p>
              {exercise.instructions ? (
                <div className="exercise-modal__instructions">
                  <h3>Ejecucion</h3>
                  <p>{exercise.instructions}</p>
                </div>
              ) : null}
            </section>

            <section className="exercise-modal__card exercise-modal__targets-card" aria-label="Detalle de zonas trabajadas">
              <div className="exercise-modal__section-heading">
                <p className="exercise-modal__section-label">Detalle</p>
                <h3>Zonas trabajadas</h3>
              </div>
              <div className="exercise-modal__targets">
                <ExerciseTargetList
                  title="Partes principales"
                  targets={primaryTargets}
                  emptyText="No hay zona principal registrada."
                />
                <ExerciseTargetList
                  title="Partes secundarias"
                  targets={secondaryTargets}
                  emptyText="No hay zonas secundarias registradas."
                />
              </div>
            </section>
          </div>
        </div>
      </article>
    </div>
  )
}

function ExerciseExplorer({
  loading,
  muscleGroups,
  visibleExercises,
  selectedMuscleSlug,
  selectedExerciseId,
  searchTerm,
  onSearchTermChange,
  onMuscleToggle,
  onExerciseSelect,
  onClearMuscleFilter,
}) {
  const [modalExercise, setModalExercise] = useState(null)

  return (
    <section id="explorador-ejercicios" className="library-shell">
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
      </div>

      <MuscleBodyMap
        muscleGroups={muscleGroups}
        selectedMuscleSlug={selectedMuscleSlug}
        onMuscleToggle={onMuscleToggle}
        onClear={onClearMuscleFilter}
      />

      <section className="exercise-library-grid">
        {visibleExercises.map((exercise) => {
          const primaryMuscles = getMuscleTargetNames(exercise, 'principal').slice(0, 2)

          return (
            <button
              key={exercise.id}
              type="button"
              className={cx(
                'exercise-card',
                'exercise-card--visual',
                getExerciseAccent(exercise),
                selectedExerciseId === exercise.id && 'exercise-card--selected'
              )}
              onClick={() =>
                startTransition(() => {
                  onExerciseSelect(exercise.id)
                  setModalExercise(exercise)
                })
              }
            >
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

      {modalExercise ? (
        <ExerciseDetailModal exercise={modalExercise} onClose={() => setModalExercise(null)} />
      ) : null}
    </section>
  )
}

export default ExerciseExplorer
