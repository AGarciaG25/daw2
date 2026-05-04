import { useNavigate } from 'react-router-dom'
import { logout } from '../lib/api'

export default function ProfilePage() {
  const navigate = useNavigate()
  const isLoggedIn = Boolean(localStorage.getItem('gymbro_token'))

  function handleLogout() {
    logout()
    navigate('/')
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
              <h3>{isLoggedIn ? 'Bienvenido a GymBro' : 'Estas navegando como invitado'}</h3>
              <p>
                {isLoggedIn
                  ? 'Has iniciado sesion correctamente. Aqui pronto podras configurar tus preferencias y metricas corporales.'
                  : 'Ya puedes entrar en la web sin iniciar sesion. Si mas adelante quieres identificarte, puedes hacerlo desde la pantalla de acceso.'}
              </p>
            </div>

            {isLoggedIn ? (
              <button
                className="button button--ghost"
                type="button"
                style={{ color: 'var(--danger)', borderColor: 'var(--danger)', width: '100%', justifyContent: 'center' }}
                onClick={handleLogout}
              >
                Cerrar sesion
              </button>
            ) : null}
          </div>
        </div>
      </section>
    </div>
  )
}
