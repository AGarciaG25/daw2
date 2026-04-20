import { Routes, Route } from 'react-router-dom'
import MainLayout from './components/MainLayout'
import Login from './components/Auth/Login'
import Register from './components/Auth/Register'

import ExercisesPage from './pages/ExercisesPage'
import WorkoutsPage from './pages/WorkoutsPage'
import ProfilePage from './pages/ProfilePage'

import './App.css'

function App() {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/register" element={<Register />} />

      <Route path="/" element={<MainLayout />}>
        <Route index element={<ExercisesPage />} />
        <Route path="tablas" element={<WorkoutsPage />} />
        <Route path="perfil" element={<ProfilePage />} />
      </Route>
    </Routes>
  )
}

export default App
