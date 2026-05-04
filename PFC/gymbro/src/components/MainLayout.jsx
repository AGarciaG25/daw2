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

      </aside>

      <main className="shell-main">
        <Outlet />
      </main>
    </div>
  )
}
