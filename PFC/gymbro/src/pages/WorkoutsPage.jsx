import { useEffect, useState } from 'react'
import WorkoutCreator from '../components/WorkoutCreator'
import { apiFetch } from '../lib/api'

function createSetEntry(overrides = {}) {
  return {
    id: crypto.randomUUID(),
    weight: '',
    reps: '10',
    rir: '',
    ...overrides,
  }
}

function createWorkoutItem(overrides = {}) {
  return {
    id: crypto.randomUUID(),
    dayLabel: 'Día 1',
    exercise: '',
    variation: '',
    restSeconds: 90,
    notes: '',
    setEntries: [createSetEntry(), createSetEntry(), createSetEntry()],
    ...overrides,
  }
}

function createWorkoutForm() {
  return {
    name: `Mi rutina ${new Intl.DateTimeFormat('es-ES').format(new Date())}`,
    goal: '',
    description: '',
    difficulty: 'principiante',
    daysPerWeek: 3,
    estimatedDuration: 45,
    items: [],
  }
}

function buildRepsSummary(setEntries) {
  const reps = setEntries.map((entry) => String(entry.reps || '').trim()).filter(Boolean)

  if (!reps.length) {
    return '10'
  }

  if (reps.every((value) => value === reps[0])) {
    return reps[0]
  }

  return reps.join('/').slice(0, 40)
}

function buildItemNotes(item) {
  const setDetails = item.setEntries
    .map((entry, index) => {
      const weight = String(entry.weight || '').trim()
      const rir = String(entry.rir || '').trim()
      const details = [weight && `peso ${weight}`, rir && `RIR ${rir}`].filter(Boolean)

      if (!details.length) {
        return ''
      }

      return `S${index + 1}: ${details.join(', ')}`
    })
    .filter(Boolean)

  return [String(item.notes || '').trim(), setDetails.length ? `Detalle series: ${setDetails.join(' | ')}` : '']
    .filter(Boolean)
    .join('\n')
}

export default function WorkoutsPage() {
  const [exercises, setExercises] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [workoutForm, setWorkoutForm] = useState(() => createWorkoutForm())
  const [formError, setFormError] = useState('')
  const [formSuccess, setFormSuccess] = useState('')
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    const controller = new AbortController()

    async function fetchData() {
      try {
        const fetchedExercises = await apiFetch('/api/exercises/', { signal: controller.signal })
        setExercises(fetchedExercises)
      } catch (err) {
        if (err.name !== 'AbortError') {
          setError(err.message || 'Error al cargar ejercicios.')
        }
      } finally {
        setLoading(false)
      }
    }

    fetchData()
    return () => controller.abort()
  }, [])

  function handleFormChange(field, value) {
    setWorkoutForm((currentValue) => ({ ...currentValue, [field]: value }))
  }

  function updateItems(updater) {
    setWorkoutForm((currentValue) => ({
      ...currentValue,
      items: currentValue.items.map(updater),
    }))
  }

  function handleItemChange(itemId, field, value) {
    updateItems((item) => (item.id === itemId ? { ...item, [field]: value } : item))
  }

  function handleAssignExercise(itemId, exerciseId) {
    updateItems((item) =>
      item.id === itemId ? { ...item, exercise: exerciseId, variation: '' } : item
    )
  }

  function handleAddItem(exerciseId = '') {
    setWorkoutForm((currentValue) => ({
      ...currentValue,
      items: [
        ...currentValue.items,
        createWorkoutItem({
          dayLabel: currentValue.items.at(-1)?.dayLabel || 'Día 1',
          exercise: exerciseId ? String(exerciseId) : '',
        }),
      ],
    }))
  }

  function handleRemoveItem(itemId) {
    setWorkoutForm((currentValue) => ({
      ...currentValue,
      items: currentValue.items.filter((item) => item.id !== itemId),
    }))
  }

  function handleAddSet(itemId) {
    updateItems((item) =>
      item.id === itemId
        ? { ...item, setEntries: [...item.setEntries, createSetEntry()] }
        : item
    )
  }

  function handleSetChange(itemId, setId, field, value) {
    updateItems((item) =>
      item.id === itemId
        ? {
            ...item,
            setEntries: item.setEntries.map((entry) =>
              entry.id === setId ? { ...entry, [field]: value } : entry
            ),
          }
        : item
    )
  }

  function handleRemoveSet(itemId, setId) {
    updateItems((item) =>
      item.id === itemId && item.setEntries.length > 1
        ? { ...item, setEntries: item.setEntries.filter((entry) => entry.id !== setId) }
        : item
    )
  }

  function handleReset() {
    setWorkoutForm(createWorkoutForm())
    setFormError('')
    setFormSuccess('')
  }

  async function handleSubmit(event) {
    event.preventDefault()
    setSubmitting(true)
    setFormError('')
    setFormSuccess('')

    try {
      if (!workoutForm.items.length) {
        throw new Error('Agrega al menos un ejercicio antes de guardar la rutina.')
      }

      const invalidItem = workoutForm.items.find((item) => !item.exercise)
      if (invalidItem) {
        throw new Error('Todos los bloques deben tener un ejercicio seleccionado.')
      }

      const payload = {
        name: workoutForm.name,
        goal: workoutForm.goal,
        description: workoutForm.description,
        difficulty: workoutForm.difficulty,
        days_per_week: Number(workoutForm.daysPerWeek),
        estimated_duration_minutes: Number(workoutForm.estimatedDuration),
        items: workoutForm.items.map((item, index) => ({
          order: index + 1,
          day_label: item.dayLabel,
          exercise: Number(item.exercise),
          variation: item.variation ? Number(item.variation) : null,
          sets: item.setEntries.length,
          reps: buildRepsSummary(item.setEntries),
          rest_seconds: Number(item.restSeconds),
          notes: buildItemNotes(item),
        })),
      }

      await apiFetch('/api/workout-plans/', {
        method: 'POST',
        body: JSON.stringify(payload),
      })

      setFormSuccess('Rutina creada con éxito.')
      setWorkoutForm(createWorkoutForm())
    } catch (err) {
      setFormError(err.message || 'Hubo un error al guardar.')
    } finally {
      setSubmitting(false)
    }
  }

  if (loading) {
    return (
      <div className="app-shell" style={{ padding: '2rem' }}>
        <h3>Cargando tablas...</h3>
      </div>
    )
  }

  return (
    <div className="app-shell">
      {error ? <div className="feedback feedback--error">{error}</div> : null}

      <WorkoutCreator
        exercises={exercises}
        workoutForm={workoutForm}
        formError={formError}
        formSuccess={formSuccess}
        submitting={submitting}
        onSubmit={handleSubmit}
        onFormChange={handleFormChange}
        onItemChange={handleItemChange}
        onAssignExercise={handleAssignExercise}
        onAddItem={handleAddItem}
        onRemoveItem={handleRemoveItem}
        onAddSet={handleAddSet}
        onSetChange={handleSetChange}
        onRemoveSet={handleRemoveSet}
        onReset={handleReset}
      />
    </div>
  )
}
