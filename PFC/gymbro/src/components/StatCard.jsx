function StatCard({ value, label, tone = 'default' }) {
  return (
    <article className={`stat-card stat-card--${tone}`}>
      <strong>{value}</strong>
      <span>{label}</span>
    </article>
  )
}

export default StatCard
