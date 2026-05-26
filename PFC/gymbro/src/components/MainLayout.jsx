import { useState } from 'react'
import { NavLink, Outlet, useNavigate } from 'react-router-dom'
import { isLoggedIn, logout } from '../lib/api'
import './MainLayout.css'

function SidebarIcon({ path }) {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true" className="sidebar-icon">
      <path d={path} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  )
}

const mainLinks = [
  {
    to: '/',
    label: 'Inicio',
    path: 'M4 10.5 12 4l8 6.5V20H4z M9.5 20v-5h5v5',
  },
  {
    to: '/ejercicios',
    label: 'Ejercicios',
    path: 'M6 7h4M14 17h4M8 5l8 14M16 5 8 19',
  },
  {
    to: '/tablas',
    label: 'Rutinas',
    path: 'M5 6.5 10 5v13.5l-5 1z M10 5l9 1v13.5l-9-1z',
  },
  {
    to: '/perfil',
    label: 'Perfil',
    path: 'M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8z M5 20a7 7 0 0 1 14 0',
  },
]

export default function MainLayout() {
  const navigate = useNavigate()
  const [hasSession, setHasSession] = useState(() => isLoggedIn())

  function handleLogout() {
    logout()
    setHasSession(false)
    navigate('/', { replace: true })
  }

  return (
    <div className="shell-layout">
      <aside className="shell-sidebar">
        <div className="shell-brand">
          <span className="shell-brand__badge">G</span>
          <div>
            <strong>GYMBRO</strong>
            <small>Biblioteca fitness</small>
          </div>
        </div>

        <nav className="sidebar-group">
          {mainLinks.map((link) => (
            <NavLink
              key={`${link.label}-${link.to}`}
              to={link.to}
              end={link.to === '/'}
              className={({ isActive }) => `sidebar-link ${isActive ? 'sidebar-link--active' : ''}`}
            >
              <SidebarIcon path={link.path} />
              <span>{link.label}</span>
            </NavLink>
          ))}
        </nav>

        <div className="sidebar-session">
          <div className="sidebar-session__copy">
            <strong>{hasSession ? 'Sesion activa' : 'Modo invitado'}</strong>
          </div>
          {hasSession ? (
            <button className="sidebar-logout" type="button" onClick={handleLogout}>
              <SidebarIcon path="M10 6H6a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h4 M14 8l4 4-4 4 M9 12h9" />
              <span>Salir</span>
            </button>
          ) : (
            <div className="sidebar-auth-actions">
              <NavLink className="sidebar-auth-link sidebar-auth-link--primary" to="/login">
                Iniciar sesion
              </NavLink>
            </div>
          )}
        </div>
      </aside>

      <main className="shell-main">
        <Outlet />
      </main>
    </div>
  )
}
