import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { login } from '../../lib/api'
import AuthForm from './AuthForm'
import './Auth.css'

export default function Login() {
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const navigate = useNavigate()

  async function handleSubmit(event) {
    event.preventDefault()
    setError('')
    setLoading(true)

    try {
      await login(username, password)
      navigate('/')
    } catch (err) {
      setError(err.message || 'No se pudo iniciar sesion. Revisa tus credenciales.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <AuthForm
      title="GymBro"
      subtitle="Inicia sesion para continuar"
      loading={loading}
      error={error}
      submitLabel="Entrar"
      loadingLabel="Iniciando sesion..."
      footerText="No tienes cuenta?"
      footerLink={{ to: '/register', label: 'Registrate aqui' }}
      onSubmit={handleSubmit}
      fields={[
        {
          id: 'username',
          label: 'Usuario',
          type: 'text',
          placeholder: 'Tu nombre de usuario',
          value: username,
          onChange: (event) => setUsername(event.target.value),
        },
        {
          id: 'password',
          label: 'Contrasena',
          type: 'password',
          placeholder: '********',
          value: password,
          onChange: (event) => setPassword(event.target.value),
        },
      ]}
    />
  )
}
