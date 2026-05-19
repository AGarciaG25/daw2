import { useNavigate } from 'react-router-dom'
import { isLoggedIn, logout } from '../lib/api'

export default function ProfilePage() {
  const navigate = useNavigate()
  const hasSession = isLoggedIn()

  function handleLogout() {
    logout()
    navigate('/', { replace: true })
  }

  function goToLogin() {
    navigate('/login')
  }

  return (
    <div className="app-shell" style={{ padding: '2rem', display: 'flex', justifyContent: 'center' }}>
      <section className="panel" style={{ maxWidth: '600px', width: '100%' }}>
        <div className="section-heading">
          <div>
            <p className="section-heading__eyebrow">Ajustes</p>
            <h2>Mi Perfil</h2>
          </div>
        </div>

        <div style={{ marginTop: '2rem', display: 'flex', flexDirection: 'column', gap: '1rem' }}>
          <div className="empty-state">
            <div style={{ padding: '2rem', background: 'var(--surface-soft)', borderRadius: '8px', marginBottom: '1rem' }}>
              <h3>{hasSession ? 'Bienvenido a GymBro' : 'Estas navegando como invitado'}</h3>
              <p>
                {hasSession
                  ? 'Has iniciado sesion correctamente. Aqui pronto podras configurar tus preferencias y metricas corporales.'
                  : 'Puedes usar la web sin iniciar sesion. Si quieres guardar datos personales, inicia sesion cuando lo necesites.'}
              </p>
            </div>

            {hasSession ? (
              <button
                className="button button--ghost"
                type="button"
                style={{ color: 'var(--danger)', borderColor: 'var(--danger)', width: '100%', justifyContent: 'center' }}
                onClick={handleLogout}
              >
                Cerrar sesion
              </button>
            ) : (
              <button
                className="button button--primary"
                type="button"
                style={{ width: '100%', justifyContent: 'center' }}
                onClick={goToLogin}
              >
                Iniciar sesion
              </button>
            )}
          </div>
        </div>
      </section>
    </div>
  )
}
