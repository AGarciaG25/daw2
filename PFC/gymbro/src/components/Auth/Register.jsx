import { useState } from 'react'
import { useNavigate, Link } from 'react-router-dom'
import { register } from '../../lib/api'
import './Auth.css'

export default function Register() {
  const [username, setUsername] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const navigate = useNavigate()

  async function handleSubmit(e) {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      await register(username, email, password)
      navigate('/login')
    } catch (err) {
      setError(err.message || 'No se pudo registrar la cuenta.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="auth-layout">
      <div className="auth-card">
        <div className="auth-header">
          <h1>Crear cuenta</h1>
          <p>Unete a GymBro</p>
        </div>

        {error && <div className="auth-error">{error}</div>}

        <form className="auth-form" onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="username">Usuario</label>
            <input
              id="username"
              type="text"
              className="form-input"
              placeholder="Tu nombre de usuario"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
            />
          </div>
          <div className="form-group">
            <label htmlFor="email">Correo electronico</label>
            <input
              id="email"
              type="email"
              className="form-input"
              placeholder="correo@ejemplo.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          <div className="form-group">
            <label htmlFor="password">Contrasena</label>
            <input
              id="password"
              type="password"
              className="form-input"
              placeholder="••••••••"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>
          <button type="submit" className="auth-button" disabled={loading}>
            {loading ? 'Creando cuenta...' : 'Registrarme'}
          </button>
        </form>

        <div className="auth-footer">
          ¿Ya tienes cuenta?{' '}
          <Link to="/login">Inicia sesion aqui</Link>
        </div>
      </div>
    </div>
  )
}
