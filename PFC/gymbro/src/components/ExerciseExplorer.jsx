import { createElement, startTransition, useEffect, useState } from 'react'
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

const diagramViews = [
  {
    label: 'Vista frontal',
    shapes: [
      ['rect', ['trapecios'], { x: 68, y: 58, width: 44, height: 18, rx: 9 }],
      ['path', ['hombros', 'deltoides'], { d: 'M45 78c8-18 24-22 39-14v34H54c-10 0-15-10-9-20zM135 78c-8-18-24-22-39-14v34h30c10 0 15-10 9-20z' }],
      ['path', ['pecho', 'pectorales'], { d: 'M62 86h56l8 58H54z' }],
      ['path', ['abdominales', 'core', 'flexores-de-cadera'], { d: 'M58 148h64l-9 72H67z' }],
      ['path', ['biceps'], { d: 'M42 105c16 0 24 12 20 28l-13 55c-2 9-16 7-15-2zM138 105c-16 0-24 12-20 28l13 55c2 9 16 7 15-2z' }],
      ['path', ['antebrazos'], { d: 'M34 188c10 1 16 6 14 17l-7 52c-1 8-14 7-15-1zM146 188c-10 1-16 6-14 17l7 52c1 8 14 7 15-1z' }],
      ['path', ['cuadriceps'], { d: 'M66 220h22l-4 95c0 11-18 11-20 0l-9-80c-1-8 3-14 11-15zM92 220h22c8 1 12 7 11 15l-9 80c-2 11-20 11-20 0z' }],
      ['path', ['aductores', 'abductores'], { d: 'M80 224h20l-3 78H83z' }],
      ['path', ['gemelos'], { d: 'M62 300h24l-4 45c-1 8-14 8-16 0zM94 300h24l-4 45c-2 8-15 8-16 0z' }],
    ],
  },
  {
    label: 'Vista posterior',
    shapes: [
      ['rect', ['trapecios'], { x: 65, y: 58, width: 50, height: 24, rx: 12 }],
      ['path', ['dorsales', 'espalda-media', 'espalda'], { d: 'M55 82h70l-12 92H67z' }],
      ['path', ['lumbar'], { d: 'M67 176h46l7 38H60z' }],
      ['path', ['gluteos'], { d: 'M58 214h64l-8 44H66z' }],
      ['path', ['triceps'], { d: 'M42 105c16 0 24 12 20 28l-13 55c-2 9-16 7-15-2zM138 105c-16 0-24 12-20 28l13 55c2 9 16 7 15-2z' }],
      ['path', ['antebrazos'], { d: 'M34 188c10 1 16 6 14 17l-7 52c-1 8-14 7-15-1zM146 188c-10 1-16 6-14 17l7 52c1 8 14 7 15-1z' }],
      ['path', ['isquiotibiales'], { d: 'M64 258h24l-4 58c-1 10-17 10-19 0zM92 258h24l-1 58c-2 10-18 10-19 0z' }],
      ['path', ['gemelos'], { d: 'M62 306h24l-4 39c-1 8-14 8-16 0zM94 306h24l-4 39c-2 8-15 8-16 0z' }],
    ],
  },
]

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

function getTargetSlugs(exercise, emphasis) {
  return new Set(
    getTargetsByEmphasis(exercise, emphasis).map((target) => target.muscle_group_detail.slug)
  )
}

function hasAnySlug(slugs, values) {
  return values.some((value) => slugs.has(value))
}

function getZoneClass(primarySlugs, secondarySlugs, slugs) {
  if (hasAnySlug(primarySlugs, slugs)) {
    return 'exercise-body-diagram__zone exercise-body-diagram__zone--primary'
  }

  if (hasAnySlug(secondarySlugs, slugs)) {
    return 'exercise-body-diagram__zone exercise-body-diagram__zone--secondary'
  }

  return 'exercise-body-diagram__zone'
}

function ExerciseBodyDiagram({ exercise }) {
  const primarySlugs = getTargetSlugs(exercise, 'principal')
  const secondarySlugs = getTargetSlugs(exercise, 'secundario')

  return (
    <div className="exercise-body-diagram" aria-label="Zonas musculares trabajadas">
      {diagramViews.map((view) => (
        <svg key={view.label} viewBox="0 0 180 360" role="img" aria-label={view.label}>
          <title>{view.label}</title>
          <circle className="exercise-body-diagram__base" cx="90" cy="34" r="21" />
          {view.shapes.map(([shape, slugs, props]) =>
            createElement(shape, {
              ...props,
              key: `${view.label}-${slugs.join('-')}`,
              className: getZoneClass(primarySlugs, secondarySlugs, slugs),
            })
          )}
        </svg>
      ))}
    </div>
  )
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
              </div>
              <ExerciseIllustration exercise={exercise} large />
            </section>

            <section className="exercise-modal__card exercise-modal__summary" aria-label="Resumen del ejercicio">
              <div className="exercise-modal__section-heading">
                <p className="exercise-modal__section-label">Resumen</p>
                <h3>Informacion clave</h3>
              </div>
              <p>{exercise.description}</p>
              <div className="exercise-modal__meta">
                <span>{difficultyLabels[exercise.difficulty] || exercise.difficulty}</span>
                <span>{exercise.equipment || 'Sin material'}</span>
                <span>{exercise.is_compound ? 'Compuesto' : 'Aislado'}</span>
              </div>
            </section>
          </div>

          <div className="exercise-modal__info-column">
            <section className="exercise-modal__card exercise-modal__body" aria-label="Zonas del cuerpo trabajadas">
              <div className="exercise-modal__section-heading exercise-modal__section-heading--split">
                <div>
                  <p className="exercise-modal__section-label">Activacion</p>
                  <h3>Musculatura implicada</h3>
                </div>
                <div className="exercise-modal__legend">
                  <span><i className="exercise-modal__dot exercise-modal__dot--primary" /> Principal</span>
                  <span><i className="exercise-modal__dot exercise-modal__dot--secondary" /> Secundaria</span>
                </div>
              </div>
              <ExerciseBodyDiagram exercise={exercise} />
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
