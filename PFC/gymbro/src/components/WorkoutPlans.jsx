import { difficultyLabels, formatDate, groupWorkoutItems } from '../lib/helpers'

function WorkoutPlans({
  workoutPlans,
  selectedWorkoutPlanId,
  selectedWorkoutPlan,
  onWorkoutPlanSelect,
  onExerciseSelect,
}) {
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

      <div className="plans-layout">
        <div className="plans-list">
          {workoutPlans.map((plan) => (
            <button
              key={plan.id}
              type="button"
              className={`plan-card ${selectedWorkoutPlanId === plan.id ? 'plan-card--selected' : ''}`}
              onClick={() => onWorkoutPlanSelect(plan.id)}
            >
              <div className="plan-card__top">
                <span className="tag tag--accent">
                  {difficultyLabels[plan.difficulty] || plan.difficulty}
                </span>
                <small>{plan.days_per_week} dias/semana</small>
              </div>
              <h3>{plan.name}</h3>
              <p>{plan.goal}</p>
              <div className="plan-card__meta">
                <span>{plan.items.length} ejercicios</span>
                <span>{plan.estimated_duration_minutes} min</span>
              </div>
            </button>
          ))}
        </div>

        <aside className="plan-detail">
          {selectedWorkoutPlan ? (
            <>
              <div className="detail-panel__header">
                <div>
                  <p className="section-heading__eyebrow">Detalle de la rutina</p>
                  <h3>{selectedWorkoutPlan.name}</h3>
                </div>
                <span className="detail-panel__date">
                  Creada {formatDate(selectedWorkoutPlan.created_at)}
                </span>
              </div>

              <p className="detail-panel__description">{selectedWorkoutPlan.goal}</p>
              <p className="detail-panel__instructions">{selectedWorkoutPlan.description}</p>

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
                          onClick={() => onExerciseSelect(item.exercise)}
                        >
                          <div>
                            <strong>
                              {item.order}. {item.exercise_detail.name}
                            </strong>
                            <p>
                              {item.variation_detail?.name || 'Version base'} - {item.sets} x {item.reps}
                            </p>
                          </div>
                          <small>{item.rest_seconds}s descanso</small>
                        </button>
                      ))}
                    </div>
                  </section>
                ))}
              </div>
            </>
          ) : (
            <div className="empty-state">
              <h3>Todavia no hay rutinas</h3>
              <p>Crea la primera rutina desde el editor superior.</p>
            </div>
          )}
        </aside>
      </div>
    </section>
  )
}

export default WorkoutPlans
