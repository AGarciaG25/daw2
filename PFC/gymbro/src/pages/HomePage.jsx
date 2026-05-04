import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import WorkoutPlans from '../components/WorkoutPlans'
import { apiFetch } from '../lib/api'

function EmptyWorkoutPlans() {
  return (
    <section className="panel">
      <div className="empty-state">
        <h3>Todavía no tienes tablas creadas</h3>
        <p>Crea tu primera rutina para que aparezca aquí y puedas consultarla desde Inicio.</p>
        <Link className="button button--primary" to="/tablas">
          Crear rutina
        </Link>
      </div>
    </section>
  )
}

export default function HomePage() {
  const [workoutPlans, setWorkoutPlans] = useState([])
  const [selectedWorkoutPlanId, setSelectedWorkoutPlanId] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    const controller = new AbortController()

    async function fetchWorkoutPlans() {
      try {
        const fetchedPlans = await apiFetch('/api/workout-plans/', { signal: controller.signal })
        setWorkoutPlans(fetchedPlans)
        setSelectedWorkoutPlanId((currentValue) => currentValue || fetchedPlans[0]?.id || null)
      } catch (err) {
        if (err.name !== 'AbortError') {
          setError(err.message || 'Error al cargar rutinas.')
        }
      } finally {
        setLoading(false)
      }
    }

    fetchWorkoutPlans()
    return () => controller.abort()
  }, [])

  const selectedWorkoutPlan = workoutPlans.find((plan) => plan.id === selectedWorkoutPlanId)

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
      {workoutPlans.length ? (
        <WorkoutPlans
          workoutPlans={workoutPlans}
          selectedWorkoutPlanId={selectedWorkoutPlanId}
          selectedWorkoutPlan={selectedWorkoutPlan}
          onWorkoutPlanSelect={setSelectedWorkoutPlanId}
          onExerciseSelect={(exerciseId) => console.log('Seleccionado ejercicio para detalles', exerciseId)}
        />
      ) : (
        <EmptyWorkoutPlans />
      )}
    </div>
  )
}
