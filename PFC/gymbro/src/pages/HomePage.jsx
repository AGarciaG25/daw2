import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import WorkoutPlans from '../components/WorkoutPlans'
import { apiFetch, isLoggedIn } from '../lib/api'

function EmptyWorkoutPlans({ hasSession }) {
  return (
    <section className="panel">
      <div className="empty-state">
        <h3>{hasSession ? 'Todavía no tienes tablas creadas' : 'Inicia sesión para ver tus tablas'}</h3>
        <p>
          {hasSession
            ? 'Crea tu primera rutina para que aparezca aquí y puedas consultarla desde Inicio.'
            : 'Tus rutinas se guardan en tu cuenta y solo se muestran cuando has iniciado sesión.'}
        </p>
        <Link className="button button--primary" to={hasSession ? '/tablas' : '/login'}>
          {hasSession ? 'Crear rutina' : 'Iniciar sesión'}
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
  const hasSession = isLoggedIn()

  useEffect(() => {
    const controller = new AbortController()

    async function fetchWorkoutPlans() {
      if (!isLoggedIn()) {
        setWorkoutPlans([])
        setSelectedWorkoutPlanId(null)
        setLoading(false)
        return
      }

      try {
        const fetchedPlans = await apiFetch('/api/workout-plans/', { signal: controller.signal })
        setWorkoutPlans(fetchedPlans)
        setSelectedWorkoutPlanId((currentValue) =>
          fetchedPlans.some((plan) => plan.id === currentValue) ? currentValue : null
        )
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

  function handleWorkoutPlanSelect(planId) {
    setSelectedWorkoutPlanId((currentValue) => (currentValue === planId ? null : planId))
  }

  async function handleWorkoutPlanDelete(planId) {
    await apiFetch(`/api/workout-plans/${planId}/`, { method: 'DELETE' })
    setWorkoutPlans((currentPlans) => currentPlans.filter((plan) => plan.id !== planId))
    setSelectedWorkoutPlanId((currentValue) => (currentValue === planId ? null : currentValue))
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
      {workoutPlans.length ? (
        <WorkoutPlans
          workoutPlans={workoutPlans}
          selectedWorkoutPlanId={selectedWorkoutPlanId}
          selectedWorkoutPlan={selectedWorkoutPlan}
          onWorkoutPlanSelect={handleWorkoutPlanSelect}
          onWorkoutPlanDelete={handleWorkoutPlanDelete}
        />
      ) : (
        <EmptyWorkoutPlans hasSession={hasSession} />
      )}
    </div>
  )
}
