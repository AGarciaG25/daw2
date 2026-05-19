export const difficultyLabels = {
  principiante: 'Principiante',
  intermedio: 'Intermedio',
  avanzado: 'Avanzado',
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
