import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { register } from '../../lib/api'
import AuthForm from './AuthForm'
import './Auth.css'

export default function Register() {
  const [username, setUsername] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const navigate = useNavigate()

  async function handleSubmit(event) {
    event.preventDefault()
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
    <AuthForm
      title="Crear cuenta"
      subtitle="Unete a GymBro"
      loading={loading}
      error={error}
      submitLabel="Registrarme"
      loadingLabel="Creando cuenta..."
      footerText="Ya tienes cuenta?"
      footerLink={{ to: '/login', label: 'Inicia sesion aqui' }}
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
          id: 'email',
          label: 'Correo electronico',
          type: 'email',
          placeholder: 'correo@ejemplo.com',
          value: email,
          onChange: (event) => setEmail(event.target.value),
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
