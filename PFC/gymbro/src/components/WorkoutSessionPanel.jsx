import { useEffect, useMemo, useState } from 'react'
import { apiFetch } from '../lib/api'
import { formatDate } from '../lib/helpers'

const weekDayLabels = ['L', 'M', 'X', 'J', 'V', 'S', 'D']

function cx(...classes) {
  return classes.filter(Boolean).join(' ')
}

function getTodayIso() {
  const now = new Date()
  const adjusted = new Date(now.getTime() - now.getTimezoneOffset() * 60000)
  return adjusted.toISOString().slice(0, 10)
}

function createSetLog(order) {
  return {
    id: crypto.randomUUID(),
    order,
    reps: '',
    weight: '',
    rir: '',
    notes: '',
  }
}

function createSessionForm(workoutItem, session = null) {
  if (session) {
    return {
      sessionDate: session.session_date,
      notes: session.notes || '',
      setLogs: (session.set_logs || []).length
        ? session.set_logs.map((setLog, index) => ({
            id: String(setLog.id || crypto.randomUUID()),
            order: index + 1,
            reps: setLog.reps || '',
            weight: setLog.weight || '',
            rir: setLog.rir || '',
            notes: setLog.notes || '',
          }))
        : [createSetLog(1)],
    }
  }

  const plannedSets = Math.max(Number(workoutItem?.sets) || 1, 1)

  return {
    sessionDate: getTodayIso(),
    notes: '',
    setLogs: Array.from({ length: plannedSets }, (_, index) => createSetLog(index + 1)),
  }
}

function toDateFromIso(value) {
  return new Date(`${value}T12:00:00`)
}

function getMonthStart(value) {
  const baseDate = value ? toDateFromIso(value) : toDateFromIso(getTodayIso())
  return new Date(baseDate.getFullYear(), baseDate.getMonth(), 1)
}

function formatMonthLabel(date) {
  return new Intl.DateTimeFormat('es-ES', { month: 'long', year: 'numeric' }).format(date)
}

function formatLongDate(value) {
  return new Intl.DateTimeFormat('es-ES', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
  }).format(toDateFromIso(value))
}

function buildCalendarDays(monthCursor) {
  const year = monthCursor.getFullYear()
  const month = monthCursor.getMonth()
  const firstDay = new Date(year, month, 1)
  const daysInMonth = new Date(year, month + 1, 0).getDate()
  const startOffset = (firstDay.getDay() + 6) % 7
  const totalCells = startOffset + daysInMonth > 35 ? 42 : 35
  const startDate = new Date(year, month, 1 - startOffset)

  return Array.from({ length: totalCells }, (_, index) => {
    const date = new Date(startDate)
    date.setDate(startDate.getDate() + index)

    const iso = [
      date.getFullYear(),
      String(date.getMonth() + 1).padStart(2, '0'),
      String(date.getDate()).padStart(2, '0'),
    ].join('-')

    return {
      iso,
      label: date.getDate(),
      isCurrentMonth: date.getMonth() === month,
      isToday: iso === getTodayIso(),
    }
  })
}

function normalizeSetLogs(setLogs) {
  return setLogs.map((setLog, index) => ({
    order: index + 1,
    reps: String(setLog.reps || '').trim(),
    weight: String(setLog.weight || '').trim(),
    rir: String(setLog.rir || '').trim(),
    notes: String(setLog.notes || '').trim(),
  }))
}

function sortSessionsDesc(sessions) {
  return [...sessions].sort((left, right) => {
    if (left.session_date !== right.session_date) {
      return right.session_date.localeCompare(left.session_date)
    }

    return right.id - left.id
  })
}

export default function WorkoutSessionPanel({ workoutItem }) {
  const [sessions, setSessions] = useState([])
  const [loading, setLoading] = useState(false)
  const [editingSessionId, setEditingSessionId] = useState(null)
  const [error, setError] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [submitError, setSubmitError] = useState('')
  const [submitSuccess, setSubmitSuccess] = useState('')
  const [sessionForm, setSessionForm] = useState(() => createSessionForm(null))
  const [selectedDate, setSelectedDate] = useState(getTodayIso())
  const [monthCursor, setMonthCursor] = useState(getMonthStart())

  useEffect(() => {
    if (!workoutItem) {
      setSessions([])
      setEditingSessionId(null)
      setError('')
      setSubmitError('')
      setSubmitSuccess('')
      setSessionForm(createSessionForm(null))
      setSelectedDate(getTodayIso())
      setMonthCursor(getMonthStart())
      return
    }

    let ignore = false

    async function loadSessions() {
      setLoading(true)
      setEditingSessionId(null)
      setError('')
      setSubmitError('')
      setSubmitSuccess('')
      setSessionForm(createSessionForm(workoutItem))

      try {
        const data = await apiFetch(`/api/workout-sessions/?workout_item=${workoutItem.id}`)

        if (ignore) {
          return
        }

        const nextSessions = sortSessionsDesc(data)
        const preferredDate = nextSessions[0]?.session_date || getTodayIso()

        setSessions(nextSessions)
        setSelectedDate(preferredDate)
        setMonthCursor(getMonthStart(preferredDate))
      } catch (requestError) {
        if (!ignore) {
          setError(requestError.message || 'No se pudo cargar el historial de sesiones.')
        }
      } finally {
        if (!ignore) {
          setLoading(false)
        }
      }
    }

    loadSessions()

    return () => {
      ignore = true
    }
  }, [workoutItem])

  const sessionsByDate = useMemo(() => {
    const grouped = new Map()

    for (const session of sessions) {
      const currentSessions = grouped.get(session.session_date) || []
      currentSessions.push(session)
      grouped.set(session.session_date, currentSessions)
    }

    return grouped
  }, [sessions])

  const calendarDays = useMemo(() => buildCalendarDays(monthCursor), [monthCursor])
  const selectedDateSessions = sessionsByDate.get(selectedDate) || []

  function updateSessionForm(updater) {
    setSessionForm((currentValue) => ({
      ...currentValue,
      ...(typeof updater === 'function' ? updater(currentValue) : updater),
    }))
  }

  function handleSetLogChange(setLogId, field, value) {
    updateSessionForm((currentValue) => ({
      setLogs: currentValue.setLogs.map((setLog) =>
        setLog.id === setLogId ? { ...setLog, [field]: value } : setLog
      ),
    }))
  }

  function handleAddSetLog() {
    updateSessionForm((currentValue) => ({
      setLogs: [...currentValue.setLogs, createSetLog(currentValue.setLogs.length + 1)],
    }))
  }

  function handleRemoveSetLog(setLogId) {
    setSessionForm((currentValue) => {
      if (currentValue.setLogs.length === 1) {
        return currentValue
      }

      const nextLogs = currentValue.setLogs
        .filter((setLog) => setLog.id !== setLogId)
        .map((setLog, index) => ({ ...setLog, order: index + 1 }))

      return {
        ...currentValue,
        setLogs: nextLogs,
      }
    })
  }

  function handleEditSession(session) {
    setEditingSessionId(session.id)
    setSessionForm(createSessionForm(workoutItem, session))
    setSelectedDate(session.session_date)
    setMonthCursor(getMonthStart(session.session_date))
    setSubmitError('')
    setSubmitSuccess('')
  }

  function handleCancelEdit() {
    setEditingSessionId(null)
    setSessionForm(createSessionForm(workoutItem))
    setSubmitError('')
    setSubmitSuccess('')
  }

  async function handleSubmit(event) {
    event.preventDefault()

    if (!workoutItem) {
      return
    }

    setSubmitting(true)
    setSubmitError('')
    setSubmitSuccess('')

    try {
      const method = editingSessionId ? 'PUT' : 'POST'
      const url = editingSessionId
        ? `/api/workout-sessions/${editingSessionId}/`
        : '/api/workout-sessions/'
      const savedSession = await apiFetch(url, {
        method,
        body: JSON.stringify({
          workout_item: workoutItem.id,
          session_date: sessionForm.sessionDate,
          notes: sessionForm.notes.trim(),
          set_logs: normalizeSetLogs(sessionForm.setLogs),
        }),
      })

      setSessions((currentValue) => {
        const nextSessions = editingSessionId
          ? currentValue.map((session) => (session.id === savedSession.id ? savedSession : session))
          : [savedSession, ...currentValue]

        return sortSessionsDesc(nextSessions)
      })
      setSelectedDate(savedSession.session_date)
      setMonthCursor(getMonthStart(savedSession.session_date))
      setEditingSessionId(null)
      setSessionForm(createSessionForm(workoutItem))
      setSubmitSuccess(
        editingSessionId ? 'Sesion actualizada correctamente.' : 'Sesion guardada correctamente.'
      )
    } catch (requestError) {
      setSubmitError(requestError.message || 'No se pudo guardar la sesion.')
    } finally {
      setSubmitting(false)
    }
  }

  if (!workoutItem) {
    return (
      <section className="session-workspace">
        <div className="session-workspace__empty">
          <p className="section-heading__eyebrow">Seguimiento</p>
          <h3>Selecciona un ejercicio de la rutina</h3>
          <p>
            Cuando elijas un ejercicio podras guardar sesiones, registrar series y revisar el
            historial en el calendario.
          </p>
        </div>
      </section>
    )
  }

  return (
    <section className="session-workspace">
      <div className="session-workspace__status">
        <span className="section-heading__badge">
          {sessions.length} {sessions.length === 1 ? 'sesion' : 'sesiones'}
        </span>
      </div>

      {error ? <div className="feedback feedback--error"><span>{error}</span></div> : null}
      {submitError ? <div className="feedback feedback--error"><span>{submitError}</span></div> : null}
      {submitSuccess ? <div className="feedback feedback--success"><span>{submitSuccess}</span></div> : null}

      <div className="session-layout">
        <form className="session-card session-form" onSubmit={handleSubmit}>
          <div className="session-card__header">
            <div>
              <p className="section-heading__eyebrow">
                {editingSessionId ? 'Editar sesion' : 'Nueva sesion'}
              </p>
              <h3>{editingSessionId ? 'Modificar entrenamiento' : 'Registrar entrenamiento'}</h3>
            </div>
            {editingSessionId ? (
              <button type="button" className="button button--ghost" onClick={handleCancelEdit}>
                Cancelar edicion
              </button>
            ) : null}
          </div>

          <div className="form-grid session-form__grid">
            <label className="field">
              <span>Fecha</span>
              <input
                type="date"
                value={sessionForm.sessionDate}
                onChange={(event) => updateSessionForm({ sessionDate: event.target.value })}
              />
            </label>

            <label className="field field--wide">
              <span>Notas de la sesion</span>
              <textarea
                rows="3"
                value={sessionForm.notes}
                onChange={(event) => updateSessionForm({ notes: event.target.value })}
                placeholder="Sensaciones, tecnica, molestias o progresos."
              />
            </label>
          </div>

          <div className="session-sets">
            <div className="session-sets__header">
              <h4>Series realizadas</h4>
              <button type="button" className="text-button" onClick={handleAddSetLog}>
                Anadir serie
              </button>
            </div>

            <div className="session-sets__list">
              {sessionForm.setLogs.map((setLog, index) => (
                <div key={setLog.id} className="session-set">
                  <div className="session-set__label">
                    <strong>Serie {index + 1}</strong>
                    <button
                      type="button"
                      className="text-button"
                      onClick={() => handleRemoveSetLog(setLog.id)}
                      disabled={sessionForm.setLogs.length === 1}
                    >
                      Quitar
                    </button>
                  </div>

                  <div className="session-set__grid">
                    <label className="field">
                      <span>Reps</span>
                      <input
                        type="text"
                        value={setLog.reps}
                        placeholder={workoutItem.reps}
                        onChange={(event) => handleSetLogChange(setLog.id, 'reps', event.target.value)}
                      />
                    </label>

                    <label className="field">
                      <span>Peso</span>
                      <input
                        type="text"
                        value={setLog.weight}
                        placeholder="Ej. 60 kg"
                        onChange={(event) =>
                          handleSetLogChange(setLog.id, 'weight', event.target.value)
                        }
                      />
                    </label>

                    <label className="field">
                      <span>RIR</span>
                      <input
                        type="text"
                        value={setLog.rir}
                        placeholder="Ej. 2"
                        onChange={(event) => handleSetLogChange(setLog.id, 'rir', event.target.value)}
                      />
                    </label>

                    <label className="field field--wide">
                      <span>Notas</span>
                      <input
                        type="text"
                        value={setLog.notes}
                        placeholder="Opcional"
                        onChange={(event) =>
                          handleSetLogChange(setLog.id, 'notes', event.target.value)
                        }
                      />
                    </label>
                  </div>
                </div>
              ))}
            </div>
          </div>

          <div className="form-actions">
            <button type="submit" className="button button--primary" disabled={submitting}>
              {submitting
                ? 'Guardando...'
                : editingSessionId
                  ? 'Guardar cambios'
                  : 'Guardar sesion'}
            </button>
          </div>
        </form>

        <div className="session-card session-history">
          <div className="session-card__header session-card__header--calendar">
            <div>
              <p className="section-heading__eyebrow">Calendario</p>
              <h3>Historial de sesiones</h3>
            </div>
            <div className="session-calendar__controls">
              <button
                type="button"
                className="session-calendar__nav"
                aria-label="Mes anterior"
                onClick={() =>
                  setMonthCursor(
                    (currentValue) =>
                      new Date(currentValue.getFullYear(), currentValue.getMonth() - 1, 1)
                  )
                }
              >
                <span aria-hidden="true">‹</span>
              </button>
              <span className="session-calendar__month">{formatMonthLabel(monthCursor)}</span>
              <button
                type="button"
                className="session-calendar__nav"
                aria-label="Mes siguiente"
                onClick={() =>
                  setMonthCursor(
                    (currentValue) =>
                      new Date(currentValue.getFullYear(), currentValue.getMonth() + 1, 1)
                  )
                }
              >
                <span aria-hidden="true">›</span>
              </button>
            </div>
          </div>

          <div className="session-calendar">
            <div className="session-calendar__weekdays">
              {weekDayLabels.map((label) => (
                <span key={label}>{label}</span>
              ))}
            </div>

            <div className="session-calendar__grid">
              {calendarDays.map((day) => {
                const daySessions = sessionsByDate.get(day.iso) || []

                return (
                  <button
                    key={day.iso}
                    type="button"
                    className={cx(
                      'session-calendar__day',
                      !day.isCurrentMonth && 'session-calendar__day--muted',
                      day.isToday && 'session-calendar__day--today',
                      selectedDate === day.iso && 'session-calendar__day--selected',
                      daySessions.length && 'session-calendar__day--has-sessions'
                    )}
                    onClick={() => setSelectedDate(day.iso)}
                  >
                    <span>{day.label}</span>
                    {daySessions.length ? (
                      <small>{daySessions.length}</small>
                    ) : (
                      <small aria-hidden="true">&nbsp;</small>
                    )}
                  </button>
                )
              })}
            </div>
          </div>

          <div className="session-day-detail">
            <div className="session-day-detail__header">
              <h4>{formatLongDate(selectedDate)}</h4>
              <span>{selectedDateSessions.length} registros</span>
            </div>

            {loading ? <p className="session-day-detail__empty">Cargando historial...</p> : null}

            {!loading && selectedDateSessions.length ? (
              <div className="session-log-list">
                {selectedDateSessions.map((session) => (
                  <article key={session.id} className="session-log">
                    <div className="session-log__meta">
                      <div className="session-log__meta-copy">
                        <strong>{formatDate(session.session_date)}</strong>
                        <span>{session.set_logs.length} series</span>
                      </div>
                      <button
                        type="button"
                        className="text-button"
                        onClick={() => handleEditSession(session)}
                      >
                        Editar
                      </button>
                    </div>

                    {session.notes ? <p>{session.notes}</p> : null}

                    <div className="session-log__sets">
                      {session.set_logs.map((setLog) => (
                        <div key={setLog.id} className="session-log__set">
                          <strong>S{setLog.order}</strong>
                          <span>{setLog.reps || '-' } reps</span>
                          <span>{setLog.weight || '-' } peso</span>
                          <span>RIR {setLog.rir || '-'}</span>
                        </div>
                      ))}
                    </div>
                  </article>
                ))}
              </div>
            ) : null}

            {!loading && !selectedDateSessions.length ? (
              <p className="session-day-detail__empty">
                No hay sesiones guardadas para este dia.
              </p>
            ) : null}
          </div>
        </div>
      </div>
    </section>
  )
}
