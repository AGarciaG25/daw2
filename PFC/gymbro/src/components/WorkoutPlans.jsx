import { useEffect, useState } from 'react'
import WorkoutSessionPanel from './WorkoutSessionPanel'
import { difficultyLabels, formatDate, groupWorkoutItems } from '../lib/helpers'

function WorkoutItemModal({ workoutItem, onClose }) {
  useEffect(() => {
    function handleKeyDown(event) {
      if (event.key === 'Escape') {
        onClose()
      }
    }

    document.addEventListener('keydown', handleKeyDown)
    return () => document.removeEventListener('keydown', handleKeyDown)
  }, [onClose])

  if (!workoutItem) {
    return null
  }

  return (
    <div className="session-modal" role="dialog" aria-modal="true" aria-labelledby="session-modal-title">
      <button type="button" className="session-modal__backdrop" aria-label="Cerrar seguimiento" onClick={onClose} />
      <article className="session-modal__panel">
        <header className="session-modal__header">
          <div>
            <h2 id="session-modal-title">{workoutItem.exercise_detail.name}</h2>
          </div>
          <button type="button" className="session-modal__close" aria-label="Cerrar" onClick={onClose}>
            <span aria-hidden="true">x</span>
          </button>
        </header>

        <WorkoutSessionPanel workoutItem={workoutItem} />
      </article>
    </div>
  )
}

function WorkoutPlans({
  workoutPlans,
  selectedWorkoutPlanId,
  selectedWorkoutPlan,
  onWorkoutPlanSelect,
  onWorkoutPlanDelete,
}) {
  const [selectedWorkoutItemId, setSelectedWorkoutItemId] = useState(null)
  const [deleteCandidate, setDeleteCandidate] = useState(null)
  const [deletingPlanId, setDeletingPlanId] = useState(null)
  const [deleteError, setDeleteError] = useState('')

  const selectedWorkoutItem =
    selectedWorkoutPlan?.items.find((item) => item.id === selectedWorkoutItemId) || null

  function handlePlanSelect(planId) {
    setSelectedWorkoutItemId(null)
    onWorkoutPlanSelect(planId)
  }

  function handleWorkoutItemOpen(item) {
    setSelectedWorkoutItemId(item.id)
  }

  function handleWorkoutItemClose() {
    setSelectedWorkoutItemId(null)
  }

  function handleDeleteRequest(plan) {
    setDeleteCandidate(plan)
    setDeleteError('')
  }

  function handleDeleteCancel() {
    if (deletingPlanId) {
      return
    }

    setDeleteCandidate(null)
    setDeleteError('')
  }

  async function handleDeleteConfirm() {
    if (!deleteCandidate || !onWorkoutPlanDelete) {
      return
    }

    setDeletingPlanId(deleteCandidate.id)
    setDeleteError('')

    try {
      await onWorkoutPlanDelete(deleteCandidate.id)
      setDeleteCandidate(null)
    } catch (error) {
      setDeleteError(error.message || 'No se pudo eliminar la rutina.')
    } finally {
      setDeletingPlanId(null)
    }
  }

  return (
    <section className="panel">
      <div className="section-heading">
        <div>
          <p className="section-heading__eyebrow">Rutinas</p>
          <h2>Rutinas guardadas</h2>
        </div>
        <span className="section-heading__badge">
          {workoutPlans.length} {workoutPlans.length === 1 ? 'rutina' : 'rutinas'}
        </span>
      </div>

      {!selectedWorkoutPlan ? (
        <>
          <p className="plans-layout__hint">
            Selecciona una rutina para ver toda la informacion completa.
          </p>

          <div className="plans-list">
            {workoutPlans.map((plan) => (
              <article
                key={plan.id}
                className={`plan-card ${selectedWorkoutPlanId === plan.id ? 'plan-card--selected' : ''}`}
              >
                <button
                  type="button"
                  className="plan-card__select"
                  onClick={() => handlePlanSelect(plan.id)}
                >
                  <div className="plan-card__top">
                    <span className="tag tag--accent">
                      {difficultyLabels[plan.difficulty] || plan.difficulty}
                    </span>
                    <small>{plan.days_per_week} dias/semana</small>
                  </div>

                  <div className="plan-card__body">
                    <h3>{plan.name}</h3>
                    <div className="plan-card__meta">
                      <span>{plan.items.length} ejercicios</span>
                      <span>{plan.estimated_duration_minutes} min</span>
                    </div>
                  </div>

                  <small className="plan-card__hint">Pulsa para ver detalle</small>
                </button>

                {onWorkoutPlanDelete ? (
                  <button
                    type="button"
                    className="plan-card__delete"
                    aria-label={`Eliminar rutina ${plan.name}`}
                    onClick={() => handleDeleteRequest(plan)}
                  >
                    Eliminar
                  </button>
                ) : null}
              </article>
            ))}
          </div>
        </>
      ) : (
        <div className="plan-detail plan-detail--expanded">
          <div className="detail-panel__header detail-panel__header--expanded">
            <div>
              <h3>{selectedWorkoutPlan.name}</h3>
            </div>
            <div className="detail-panel__actions">
              <span className="detail-panel__date">
                Creada {formatDate(selectedWorkoutPlan.created_at)}
              </span>
              <button
                type="button"
                className="detail-panel__minimize"
                aria-label="Minimizar rutina"
                onClick={() => handlePlanSelect(selectedWorkoutPlan.id)}
              >
                <span aria-hidden="true" />
              </button>
            </div>
          </div>

          <div className="detail-stat-grid">
            <div className="detail-stat">
              <span>Dias por semana</span>
              <strong>{selectedWorkoutPlan.days_per_week}</strong>
            </div>
            <div className="detail-stat">
              <span>Duracion estimada</span>
              <strong>{selectedWorkoutPlan.estimated_duration_minutes} min</strong>
            </div>
          </div>

          <div className="day-stack">
            {groupWorkoutItems(selectedWorkoutPlan.items).map(([dayLabel, items]) => (
              <section key={dayLabel} className="day-card">
                <header className="day-card__header">
                  <h4>{dayLabel}</h4>
                  <span>{items.length} bloques</span>
                </header>

                <div className="day-card__items">
                  {items.map((item) => (
                    <button
                      key={item.id}
                      type="button"
                      className="plan-item"
                      onClick={() => handleWorkoutItemOpen(item)}
                    >
                      <div>
                        <strong>
                          {item.order}. {item.exercise_detail.name}
                        </strong>
                        <p>
                          {item.variation_detail?.name || 'Version base'} - {item.sets} x {item.reps}
                        </p>
                      </div>
                      <div className="plan-item__meta">
                        <small>{item.rest_seconds}s descanso</small>
                      </div>
                    </button>
                  ))}
                </div>
              </section>
            ))}
          </div>
        </div>
      )}

      <WorkoutItemModal workoutItem={selectedWorkoutItem} onClose={handleWorkoutItemClose} />

      {deleteCandidate ? (
        <div className="confirm-modal" role="dialog" aria-modal="true" aria-labelledby="delete-plan-title">
          <button
            type="button"
            className="confirm-modal__backdrop"
            aria-label="Cancelar eliminacion"
            onClick={handleDeleteCancel}
          />
          <article className="confirm-modal__panel">
            <h3 id="delete-plan-title">Eliminar rutina</h3>
            <p>
              Vas a eliminar "{deleteCandidate.name}". Esta accion no se puede deshacer.
            </p>
            {deleteError ? <div className="feedback feedback--error">{deleteError}</div> : null}
            <div className="confirm-modal__actions">
              <button
                type="button"
                className="button button--ghost"
                onClick={handleDeleteCancel}
                disabled={Boolean(deletingPlanId)}
              >
                Cancelar
              </button>
              <button
                type="button"
                className="button button--danger"
                onClick={handleDeleteConfirm}
                disabled={Boolean(deletingPlanId)}
              >
                {deletingPlanId ? 'Eliminando...' : 'Eliminar'}
              </button>
            </div>
          </article>
        </div>
      ) : null}
    </section>
  )
}

export default WorkoutPlans
