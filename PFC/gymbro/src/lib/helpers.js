export const difficultyLabels = {
  principiante: 'Principiante',
  intermedio: 'Intermedio',
  avanzado: 'Avanzado',
}

export const bodyRegionLabels = {
  all: 'Todo el cuerpo',
  tren_superior: 'Tren superior',
  tren_inferior: 'Tren inferior',
  core: 'Core',
  cuerpo_completo: 'Cuerpo completo',
}

export function createWorkoutItem() {
  return {
    id: Math.random().toString(36).slice(2, 9),
    dayLabel: 'Dia 1',
    exercise: '',
    variation: '',
    sets: '3',
    reps: '8-12',
    restSeconds: '90',
    notes: '',
  }
}

export function createInitialWorkoutForm() {
  return {
    name: '',
    goal: '',
    description: '',
    difficulty: 'principiante',
    daysPerWeek: '3',
    estimatedDuration: '60',
    items: [createWorkoutItem()],
  }
}

export function formatDate(value) {
  if (!value) {
    return ''
  }

  return new Intl.DateTimeFormat('es-ES', {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  }).format(new Date(value))
}

export function getMuscleTargetNames(exercise, emphasis) {
  return exercise.muscle_targets
    .filter((target) => target.emphasis === emphasis)
    .map((target) => target.muscle_group_detail.name)
}

export function getBodyRegionCount(muscleGroups, region) {
  return muscleGroups.filter((group) => group.body_region === region).length
}

export function groupWorkoutItems(items) {
  const grouped = new Map()
  const sortedItems = [...items].sort((left, right) => {
    if (left.day_label === right.day_label) {
      return left.order - right.order
    }

    return left.day_label.localeCompare(right.day_label, 'es')
  })

  for (const item of sortedItems) {
    const dayLabel = item.day_label || 'General'

    if (!grouped.has(dayLabel)) {
      grouped.set(dayLabel, [])
    }

    grouped.get(dayLabel).push(item)
  }

  return Array.from(grouped.entries())
}
