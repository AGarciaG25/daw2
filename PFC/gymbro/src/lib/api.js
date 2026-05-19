const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || ''
const AUTH_TOKEN_KEY = 'gymbro_token'

function buildApiUrl(path) {
  const baseUrl = API_BASE_URL || window.location.origin
  return new URL(path, baseUrl).toString()
}

function normalizeErrorMessage(payload) {
  if (!payload) {
    return 'No se pudo completar la operacion.'
  }

  if (typeof payload === 'string') {
    return payload
  }

  if (Array.isArray(payload)) {
    return payload.map(normalizeErrorMessage).filter(Boolean).join(' ')
  }

  if (typeof payload === 'object') {
    return Object.entries(payload)
      .map(([key, value]) => {
        const message = normalizeErrorMessage(value)
        if (!message) {
          return ''
        }

        if (key === 'detail' || key === 'non_field_errors') {
          return message
        }

        return `${key.replaceAll('_', ' ')}: ${message}`
      })
      .filter(Boolean)
      .join(' ')
  }

  return String(payload)
}

export async function apiFetch(path, options = {}) {
  const headers = {
    Accept: 'application/json',
    ...(options.headers || {}),
  }

  const token = localStorage.getItem(AUTH_TOKEN_KEY)
  if (token) {
    headers['Authorization'] = `Token ${token}`
  }

  if (options.body && !headers['Content-Type']) {
    headers['Content-Type'] = 'application/json'
  }

  const response = await fetch(buildApiUrl(path), {
    ...options,
    headers,
  })

  if (!response.ok) {
    let payload = null

    try {
      payload = await response.json()
    } catch {
      payload = null
    }

    throw new Error(normalizeErrorMessage(payload))
  }

  if (response.status === 204) {
    return null
  }

  return response.json()
}

export async function login(username, password) {
  const data = await apiFetch('/api/login/', {
    method: 'POST',
    body: JSON.stringify({ username, password }),
  })
  if (data.token) {
    localStorage.setItem(AUTH_TOKEN_KEY, data.token)
  }
  return data
}

export async function register(username, email, password) {
  return apiFetch('/api/register/', {
    method: 'POST',
    body: JSON.stringify({ username, email, password }),
  })
}

export function logout() {
  localStorage.removeItem(AUTH_TOKEN_KEY)
}

export function isLoggedIn() {
  return Boolean(localStorage.getItem(AUTH_TOKEN_KEY))
}
