import { NavLink, Outlet } from 'react-router-dom'
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
    to: '/',
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

const secondaryLinks = [
  {
    label: 'Progreso',
    path: 'M5 18V6 M5 18h14 M8 14l3-3 2 2 5-6',
  },
  {
    label: 'Avisos',
    path: 'M12 4a4 4 0 0 1 4 4v2.5c0 .8.3 1.6.9 2.1l1.1 1.1H6l1.1-1.1c.6-.5.9-1.3.9-2.1V8a4 4 0 0 1 4-4z M10 18a2 2 0 0 0 4 0',
  },
  {
    label: 'Comunidad',
    path: 'M8 11a3 3 0 1 0 0-6 3 3 0 0 0 0 6z M17 13a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z M3.5 20a4.5 4.5 0 0 1 9 0 M13.5 20a3.5 3.5 0 0 1 7 0',
  },
]

export default function MainLayout() {
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

        <div className="sidebar-group sidebar-group--muted">
          <p className="sidebar-group__title">Panel</p>
          {secondaryLinks.map((link) => (
            <button key={link.label} type="button" className="sidebar-link sidebar-link--static">
              <SidebarIcon path={link.path} />
              <span>{link.label}</span>
            </button>
          ))}
        </div>
      </aside>

      <main className="shell-main">
        <Outlet />
      </main>
    </div>
  )
}
