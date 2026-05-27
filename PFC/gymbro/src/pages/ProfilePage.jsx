import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import {
  changePassword,
  getProfile,
  isLoggedIn,
  logout,
  updateProfile,
} from '../lib/api'

const emptyPasswordForm = {
  currentPassword: '',
  newPassword: '',
  confirmPassword: '',
}

const avatarSize = 320
const avatarQuality = 0.86

function notifyProfileUpdated() {
  window.dispatchEvent(new Event('gymbro-profile-updated'))
}

function loadImage(dataUrl) {
  return new Promise((resolve, reject) => {
    const image = new Image()
    image.onload = () => resolve(image)
    image.onerror = () => reject(new Error('No se pudo leer la imagen.'))
    image.src = dataUrl
  })
}

function readFileAsDataUrl(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = () => resolve(String(reader.result || ''))
    reader.onerror = () => reject(new Error('No se pudo leer el archivo.'))
    reader.readAsDataURL(file)
  })
}

async function createAvatarDataUrl(file) {
  const dataUrl = await readFileAsDataUrl(file)
  const image = await loadImage(dataUrl)
  const canvas = document.createElement('canvas')
  const context = canvas.getContext('2d')

  if (!context) {
    throw new Error('No se pudo preparar la imagen.')
  }

  const sourceSize = Math.min(image.naturalWidth, image.naturalHeight)
  const sourceX = (image.naturalWidth - sourceSize) / 2
  const sourceY = (image.naturalHeight - sourceSize) / 2

  canvas.width = avatarSize
  canvas.height = avatarSize
  context.drawImage(image, sourceX, sourceY, sourceSize, sourceSize, 0, 0, avatarSize, avatarSize)

  return canvas.toDataURL('image/jpeg', avatarQuality)
}

export default function ProfilePage() {
  const navigate = useNavigate()
  const hasSession = isLoggedIn()
  const [loading, setLoading] = useState(hasSession)
  const [profileForm, setProfileForm] = useState({
    username: '',
    email: '',
    avatar_data_url: '',
  })
  const [passwordForm, setPasswordForm] = useState(emptyPasswordForm)
  const [profileError, setProfileError] = useState('')
  const [profileSuccess, setProfileSuccess] = useState('')
  const [passwordError, setPasswordError] = useState('')
  const [passwordSuccess, setPasswordSuccess] = useState('')
  const [savingProfile, setSavingProfile] = useState(false)
  const [savingPassword, setSavingPassword] = useState(false)
  const [editingField, setEditingField] = useState(null)

  useEffect(() => {
    let ignore = false

    async function fetchProfile() {
      if (!hasSession) {
        return
      }

      try {
        const profile = await getProfile()
        if (!ignore) {
          setProfileForm({
            username: profile.username || '',
            email: profile.email || '',
            avatar_data_url: profile.avatar_data_url || '',
          })
        }
      } catch (error) {
        if (!ignore) {
          setProfileError(error.message || 'No se pudo cargar el perfil.')
        }
      } finally {
        if (!ignore) {
          setLoading(false)
        }
      }
    }

    fetchProfile()
    return () => {
      ignore = true
    }
  }, [hasSession])

  function handleLogout() {
    logout()
    notifyProfileUpdated()
    navigate('/', { replace: true })
  }

  function goToLogin() {
    navigate('/login')
  }

  function handleProfileChange(field, value) {
    setProfileForm((currentValue) => ({ ...currentValue, [field]: value }))
  }

  function handleEditField(field) {
    setEditingField(field)
    setProfileError('')
    setProfileSuccess('')
    setPasswordError('')
    setPasswordSuccess('')
  }

  async function handleAvatarChange(event) {
    const file = event.target.files?.[0]
    if (!file) {
      return
    }

    if (!file.type.startsWith('image/')) {
      setProfileError('Selecciona un archivo de imagen.')
      return
    }

    try {
      const avatarDataUrl = await createAvatarDataUrl(file)
      handleProfileChange('avatar_data_url', avatarDataUrl)
      setProfileError('')
      setProfileSuccess('')
    } catch (error) {
      setProfileError(error.message || 'No se pudo preparar la imagen.')
    }
  }

  async function handleUsernameSave() {
    setSavingProfile(true)
    setProfileError('')
    setProfileSuccess('')

    try {
      const savedProfile = await updateProfile({ username: profileForm.username })
      setProfileForm({
        username: savedProfile.username || profileForm.username,
        email: savedProfile.email || profileForm.email,
        avatar_data_url: savedProfile.avatar_data_url || profileForm.avatar_data_url,
      })
      setProfileSuccess('Perfil actualizado correctamente.')
      setEditingField(null)
      notifyProfileUpdated()
    } catch (error) {
      setProfileError(error.message || 'No se pudo actualizar el perfil.')
    } finally {
      setSavingProfile(false)
    }
  }

  async function handleAvatarSave() {
    setSavingProfile(true)
    setProfileError('')
    setProfileSuccess('')

    try {
      if (!profileForm.avatar_data_url) {
        throw new Error('Selecciona una imagen antes de guardar.')
      }

      const savedProfile = await updateProfile({ avatar_data_url: profileForm.avatar_data_url })
      setProfileForm({
        username: savedProfile.username || profileForm.username,
        email: savedProfile.email || profileForm.email,
        avatar_data_url: savedProfile.avatar_data_url || '',
      })
      setProfileSuccess('Imagen actualizada correctamente.')
      setEditingField(null)
      notifyProfileUpdated()
    } catch (error) {
      setProfileError(error.message || 'No se pudo actualizar la imagen.')
    } finally {
      setSavingProfile(false)
    }
  }

  function handlePasswordChange(field, value) {
    setPasswordForm((currentValue) => ({ ...currentValue, [field]: value }))
  }

  async function handlePasswordSubmit(event) {
    event.preventDefault()
    setSavingPassword(true)
    setPasswordError('')
    setPasswordSuccess('')

    try {
      if (passwordForm.newPassword !== passwordForm.confirmPassword) {
        throw new Error('La nueva contrasena no coincide.')
      }

      await changePassword(passwordForm.currentPassword, passwordForm.newPassword)
      setPasswordForm(emptyPasswordForm)
      setPasswordSuccess('Contrasena actualizada correctamente.')
      setEditingField(null)
    } catch (error) {
      setPasswordError(error.message || 'No se pudo actualizar la contrasena.')
    } finally {
      setSavingPassword(false)
    }
  }

  if (!hasSession) {
    return (
      <div className="app-shell profile-page">
        <section className="panel profile-panel">
          <div className="empty-state">
            <h3>Estas navegando como invitado</h3>
            <p>Inicia sesion para editar tu perfil.</p>
            <button className="button button--primary" type="button" onClick={goToLogin}>
              Iniciar sesion
            </button>
          </div>
        </section>
      </div>
    )
  }

  if (loading) {
    return (
      <div className="app-shell profile-page">
        <h3>Cargando perfil...</h3>
      </div>
    )
  }

  return (
    <div className="app-shell profile-page">
      <section className="profile-layout">
        <main className="profile-content">
          <header className="profile-content__header" id="datos-personales">
            <div>
              <h2>Datos personales</h2>
            </div>
            <span className="profile-avatar profile-avatar--large">
              {profileForm.avatar_data_url ? (
                <img src={profileForm.avatar_data_url} alt="" />
              ) : (
                'G'
              )}
            </span>
          </header>

          {profileError ? <div className="feedback feedback--error">{profileError}</div> : null}
          {profileSuccess ? <div className="feedback feedback--success">{profileSuccess}</div> : null}

          <div className="profile-row">
            <div className="profile-row__label">Nombre de usuario</div>
            <div className="profile-row__value">
              {editingField === 'username' ? (
                <input
                  type="text"
                  value={profileForm.username}
                  onChange={(event) => handleProfileChange('username', event.target.value)}
                  required
                />
              ) : (
                <span>{profileForm.username}</span>
              )}
            </div>
            <div className="profile-row__actions">
              {editingField === 'username' ? (
                <>
                  <button className="text-button" type="button" onClick={handleUsernameSave} disabled={savingProfile}>
                    {savingProfile ? 'Guardando...' : 'Guardar'}
                  </button>
                  <button className="text-button text-button--muted" type="button" onClick={() => setEditingField(null)}>
                    Cancelar
                  </button>
                </>
              ) : (
                <button className="text-button" type="button" onClick={() => handleEditField('username')}>
                  Editar
                </button>
              )}
            </div>
          </div>

          <div className="profile-row">
            <div className="profile-row__label">Correo</div>
            <div className="profile-row__value">
              <span>{profileForm.email || 'Sin correo registrado'}</span>
            </div>
            <div className="profile-row__actions" />
          </div>

          <div className="profile-row">
            <div className="profile-row__label">Imagen de perfil</div>
            <div className="profile-row__value">
              {editingField === 'avatar' ? (
                <div className="profile-row__stack">
                  <input type="file" accept="image/*" onChange={handleAvatarChange} />
                  {profileForm.avatar_data_url ? (
                    <button
                      className="text-button text-button--muted"
                      type="button"
                      onClick={() => handleProfileChange('avatar_data_url', '')}
                    >
                      Quitar imagen
                    </button>
                  ) : null}
                </div>
              ) : (
                <span>{profileForm.avatar_data_url ? 'Imagen personalizada' : 'Sin imagen personalizada'}</span>
              )}
            </div>
            <div className="profile-row__actions">
              {editingField === 'avatar' ? (
                <>
                  <button className="text-button" type="button" onClick={handleAvatarSave} disabled={savingProfile}>
                    {savingProfile ? 'Guardando...' : 'Guardar'}
                  </button>
                  <button className="text-button text-button--muted" type="button" onClick={() => setEditingField(null)}>
                    Cancelar
                  </button>
                </>
              ) : (
                <button className="text-button" type="button" onClick={() => handleEditField('avatar')}>
                  Editar
                </button>
              )}
            </div>
          </div>

          <section className="profile-section" id="seguridad">
            {passwordError ? <div className="feedback feedback--error">{passwordError}</div> : null}
            {passwordSuccess ? <div className="feedback feedback--success">{passwordSuccess}</div> : null}

            <form className="profile-row" onSubmit={handlePasswordSubmit}>
              <div className="profile-row__label">Contrasena</div>
              <div className="profile-row__value">
                {editingField === 'password' ? (
                  <div className="profile-row__stack">
                    <input
                      type="password"
                      placeholder="Contrasena actual"
                      value={passwordForm.currentPassword}
                      onChange={(event) => handlePasswordChange('currentPassword', event.target.value)}
                      required
                    />
                    <input
                      type="password"
                      placeholder="Nueva contrasena"
                      value={passwordForm.newPassword}
                      onChange={(event) => handlePasswordChange('newPassword', event.target.value)}
                      minLength={5}
                      required
                    />
                    <input
                      type="password"
                      placeholder="Repite la nueva contrasena"
                      value={passwordForm.confirmPassword}
                      onChange={(event) => handlePasswordChange('confirmPassword', event.target.value)}
                      minLength={5}
                      required
                    />
                  </div>
                ) : (
                  <span>Contrasena configurada</span>
                )}
              </div>
              <div className="profile-row__actions">
                {editingField === 'password' ? (
                  <>
                    <button className="text-button" type="submit" disabled={savingPassword}>
                      {savingPassword ? 'Guardando...' : 'Guardar'}
                    </button>
                    <button className="text-button text-button--muted" type="button" onClick={() => setEditingField(null)}>
                      Cancelar
                    </button>
                  </>
                ) : (
                  <button className="text-button" type="button" onClick={() => handleEditField('password')}>
                    Editar
                  </button>
                )}
              </div>
            </form>
          </section>
        </main>
      </section>
    </div>
  )
}
