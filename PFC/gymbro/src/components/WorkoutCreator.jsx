import { difficultyLabels } from '../lib/helpers'

function WorkoutCreator({
  exercises,
  workoutForm,
  formError,
  formSuccess,
  submitting,
  onSubmit,
  onFormChange,
  onItemChange,
  onAddItem,
  onRemoveItem,
  onReset,
}) {
  return (
    <section id="creador-tabla" className="panel panel--accent">
      <div className="section-heading">
        <div>
          <p className="section-heading__eyebrow">Creador</p>
          <h2>Crear una nueva tabla de ejercicios</h2>
        </div>
        <span className="section-heading__badge">POST /api/workout-plans/</span>
      </div>

      <form className="creator-layout" onSubmit={onSubmit}>
        <div className="creator-main">
          <div className="form-grid">
            <label className="field">
              <span>Nombre de la tabla</span>
              <input
                type="text"
                placeholder="Torso y pierna 4 dias"
                value={workoutForm.name}
                onChange={(event) => onFormChange('name', event.target.value)}
                required
              />
            </label>

            <label className="field">
              <span>Objetivo</span>
              <input
                type="text"
                placeholder="Hipertrofia, fuerza, recomposicion..."
                value={workoutForm.goal}
                onChange={(event) => onFormChange('goal', event.target.value)}
                required
              />
            </label>

            <label className="field field--wide">
              <span>Descripcion</span>
              <textarea
                rows="4"
                placeholder="Explica para quien es la rutina y como se plantea."
                value={workoutForm.description}
                onChange={(event) => onFormChange('description', event.target.value)}
              />
            </label>

            <label className="field">
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

            <label className="field">
              <span>Dias por semana</span>
              <input
                type="number"
                min="1"
                max="7"
                value={workoutForm.daysPerWeek}
                onChange={(event) => onFormChange('daysPerWeek', event.target.value)}
              />
            </label>

            <label className="field">
              <span>Duracion estimada</span>
              <input
                type="number"
                min="15"
                step="5"
                value={workoutForm.estimatedDuration}
                onChange={(event) => onFormChange('estimatedDuration', event.target.value)}
              />
            </label>
          </div>

          <div className="builder">
            <div className="stack__header">
              <h3>Bloques de ejercicios</h3>
              <button className="button button--secondary" type="button" onClick={onAddItem}>
                Agregar ejercicio
              </button>
            </div>

            <div className="builder-list">
              {workoutForm.items.map((item, index) => {
                const selectedExercise = exercises.find(
                  (exercise) => String(exercise.id) === item.exercise
                )
                const variations = selectedExercise?.variations || []

                return (
                  <article key={item.id} className="builder-item">
                    <div className="builder-item__header">
                      <strong>Bloque {index + 1}</strong>
                      <button
                        className="text-button"
                        type="button"
                        onClick={() => onRemoveItem(item.id)}
                        disabled={workoutForm.items.length === 1}
                      >
                        Eliminar
                      </button>
                    </div>

                    <div className="builder-item__grid">
                      <label className="field">
                        <span>Dia</span>
                        <input
                          type="text"
                          value={item.dayLabel}
                          onChange={(event) => onItemChange(item.id, 'dayLabel', event.target.value)}
                        />
                      </label>

                      <label className="field field--wide">
                        <span>Ejercicio</span>
                        <select
                          value={item.exercise}
                          onChange={(event) => onItemChange(item.id, 'exercise', event.target.value)}
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

                      <label className="field field--wide">
                        <span>Variacion</span>
                        <select
                          value={item.variation}
                          onChange={(event) =>
                            onItemChange(item.id, 'variation', event.target.value)
                          }
                          disabled={!selectedExercise}
                        >
                          <option value="">Version base</option>
                          {variations.map((variation) => (
                            <option key={variation.id} value={variation.id}>
                              {variation.name}
                            </option>
                          ))}
                        </select>
                      </label>

                      <label className="field">
                        <span>Series</span>
                        <input
                          type="number"
                          min="1"
                          value={item.sets}
                          onChange={(event) => onItemChange(item.id, 'sets', event.target.value)}
                        />
                      </label>

                      <label className="field">
                        <span>Repeticiones</span>
                        <input
                          type="text"
                          value={item.reps}
                          onChange={(event) => onItemChange(item.id, 'reps', event.target.value)}
                        />
                      </label>

                      <label className="field">
                        <span>Descanso (s)</span>
                        <input
                          type="number"
                          min="0"
                          step="15"
                          value={item.restSeconds}
                          onChange={(event) =>
                            onItemChange(item.id, 'restSeconds', event.target.value)
                          }
                        />
                      </label>

                      <label className="field field--wide">
                        <span>Notas</span>
                        <textarea
                          rows="3"
                          placeholder="Ritmo, tecnica, progresion..."
                          value={item.notes}
                          onChange={(event) => onItemChange(item.id, 'notes', event.target.value)}
                        />
                      </label>
                    </div>
                  </article>
                )
              })}
            </div>
          </div>

          {formError ? (
            <div className="feedback feedback--error">
              <strong>No se ha podido guardar la tabla.</strong>
              <span>{formError}</span>
            </div>
          ) : null}

          {formSuccess ? (
            <div className="feedback feedback--success">
              <strong>Tabla guardada.</strong>
              <span>{formSuccess}</span>
            </div>
          ) : null}

          <div className="form-actions">
            <button className="button button--primary" type="submit" disabled={submitting}>
              {submitting ? 'Guardando...' : 'Guardar tabla'}
            </button>
            <button className="button button--ghost" type="button" onClick={onReset}>
              Reiniciar
            </button>
          </div>
        </div>

        <aside className="creator-side">
          <h3>Que hace este creador</h3>
          <ul className="insight-list">
            <li>Usa los ejercicios y variaciones que ya existen en tu base de datos.</li>
            <li>Agrupa automaticamente los bloques por dia y calcula el orden.</li>
            <li>Al guardar, la nueva tabla aparece arriba en el panel de rutinas.</li>
          </ul>

          <div className="creator-side__tips">
            <h4>Sugerencia de uso</h4>
            <p>
              Si quieres una rutina full body, reparte los bloques entre <strong>Dia 1</strong>,
              <strong> Dia 2</strong> y <strong>Dia 3</strong> para que el panel te la organice
              mejor.
            </p>
          </div>
        </aside>
      </form>
    </section>
  )
}

export default WorkoutCreator
