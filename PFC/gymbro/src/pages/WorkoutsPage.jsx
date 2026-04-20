import { useEffect, useState } from 'react'
import WorkoutPlans from '../components/WorkoutPlans'
import WorkoutCreator from '../components/WorkoutCreator'
import { apiFetch } from '../lib/api'

export default function WorkoutsPage() {
  const [workoutPlans, setWorkoutPlans] = useState([])
  const [exercises, setExercises] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  
  const [selectedWorkoutPlanId, setSelectedWorkoutPlanId] = useState(null)

  // Empty initial form details for the creator
  const initialForm = {
    name: '',
    goal: '',
    description: '',
    difficulty: 'beginner',
    daysPerWeek: 3,
    estimatedDuration: 45,
    items: [
      {
        id: crypto.randomUUID(),
        dayLabel: 'Dia 1',
        exercise: '',
        variation: '',
        sets: 3,
        reps: '10',
        restSeconds: 60,
        notes: '',
      },
    ],
  }
  const [workoutForm, setWorkoutForm] = useState(initialForm)
  const [formError, setFormError] = useState('')
  const [formSuccess, setFormSuccess] = useState('')
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    const controller = new AbortController()

    async function fetchData() {
      try {
        const [fetchedPlans, fetchedExercises] = await Promise.all([
          apiFetch('/api/workout-plans/', { signal: controller.signal }),
          apiFetch('/api/exercises/', { signal: controller.signal }),
        ])
        setWorkoutPlans(fetchedPlans)
        setExercises(fetchedExercises)
        if (fetchedPlans.length > 0 && !selectedWorkoutPlanId) {
          setSelectedWorkoutPlanId(fetchedPlans[0].id)
        }
      } catch (err) {
        if (err.name !== 'AbortError') {
          setError(err.message || 'Error al cargar rutinas.')
        }
      } finally {
        setLoading(false)
      }
    }

    fetchData()
    return () => controller.abort()
  }, [])

  const selectedWorkoutPlan = workoutPlans.find(plan => plan.id === selectedWorkoutPlanId)

  // Handlers for WorkoutCreator
  function handleFormChange(field, value) {
    setWorkoutForm({ ...workoutForm, [field]: value })
  }

  function handleItemChange(itemId, field, value) {
    setWorkoutForm({
      ...workoutForm,
      items: workoutForm.items.map((item) =>
        item.id === itemId ? { ...item, [field]: value } : item
      ),
    })
  }

  function handleAddItem() {
    setWorkoutForm({
      ...workoutForm,
      items: [
        ...workoutForm.items,
        {
          id: crypto.randomUUID(),
          dayLabel: 'Dia X',
          exercise: '',
          variation: '',
          sets: 3,
          reps: '10',
          restSeconds: 60,
          notes: '',
        },
      ],
    })
  }

  function handleRemoveItem(itemId) {
    if (workoutForm.items.length <= 1) return
    setWorkoutForm({
      ...workoutForm,
      items: workoutForm.items.filter((item) => item.id !== itemId),
    })
  }

  function handleReset() {
    setWorkoutForm(initialForm)
    setFormError('')
    setFormSuccess('')
  }

  async function handleSubmit(e) {
    e.preventDefault()
    setSubmitting(true)
    setFormError('')
    setFormSuccess('')

    try {
      // Map the form correctly to backend specification if needed. 
      // Using generic mapping for item block
      const payload = {
        name: workoutForm.name,
        goal: workoutForm.goal,
        description: workoutForm.description,
        difficulty: workoutForm.difficulty,
        days_per_week: Number(workoutForm.daysPerWeek),
        estimated_duration_minutes: Number(workoutForm.estimatedDuration),
        items: workoutForm.items.map((item, idx) => ({
          order: idx + 1,
          day_label: item.dayLabel,
          exercise: Number(item.exercise),
          variation: item.variation ? Number(item.variation) : null,
          sets: Number(item.sets),
          reps: item.reps,
          rest_seconds: Number(item.restSeconds),
          notes: item.notes,
        })),
      }

      const response = await apiFetch('/api/workout-plans/', {
        method: 'POST',
        body: JSON.stringify(payload),
      })

      setWorkoutPlans([response, ...workoutPlans])
      setSelectedWorkoutPlanId(response.id)
      setFormSuccess('¡Rutina creada con éxito!')
      setWorkoutForm(initialForm)
    } catch (err) {
      setFormError(err.message || 'Hubo un error al guardar.')
    } finally {
      setSubmitting(false)
    }
  }

  if (loading) {
    return <div className="app-shell" style={{ padding: '2rem' }}><h3>Cargando tablas...</h3></div>
  }

  return (
    <div className="app-shell">
      {error && <div className="feedback feedback--error">{error}</div>}
      <WorkoutPlans 
        workoutPlans={workoutPlans}
        selectedWorkoutPlanId={selectedWorkoutPlanId}
        selectedWorkoutPlan={selectedWorkoutPlan}
        onWorkoutPlanSelect={setSelectedWorkoutPlanId}
        onExerciseSelect={(exerciseId) => console.log('Seleccionado ejercicio para detalles', exerciseId)} 
      />
      
      <WorkoutCreator 
        exercises={exercises}
        workoutForm={workoutForm}
        formError={formError}
        formSuccess={formSuccess}
        submitting={submitting}
        onSubmit={handleSubmit}
        onFormChange={handleFormChange}
        onItemChange={handleItemChange}
        onAddItem={handleAddItem}
        onRemoveItem={handleRemoveItem}
        onReset={handleReset}
      />
    </div>
  )
}
