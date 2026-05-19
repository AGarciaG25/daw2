import { Link } from 'react-router-dom'

export default function AuthForm({
  title,
  subtitle,
  fields,
  loading,
  error,
  submitLabel,
  loadingLabel,
  footerText,
  footerLink,
  onSubmit,
}) {
  return (
    <div className="auth-layout">
      <div className="auth-card">
        <div className="auth-header">
          <h1>{title}</h1>
          <p>{subtitle}</p>
        </div>

        {error ? <div className="auth-error">{error}</div> : null}

        <form className="auth-form" onSubmit={onSubmit}>
          {fields.map(({ id, label, ...inputProps }) => (
            <div className="form-group" key={id}>
              <label htmlFor={id}>{label}</label>
              <input id={id} className="form-input" required {...inputProps} />
            </div>
          ))}

          <button type="submit" className="auth-button" disabled={loading}>
            {loading ? loadingLabel : submitLabel}
          </button>
        </form>

        <div className="auth-footer">
          {footerText} <Link to={footerLink.to}>{footerLink.label}</Link>
        </div>
      </div>
    </div>
  )
}
