import { useState } from 'react'
import { api } from '../api'
import { useAuth } from '../context/AuthContext'

export default function Profile() {
  const { user, login } = useAuth()
  const isAdmin = user.role_title === 'Администратор'
  const [form, setForm] = useState({
    name: user.name || '', email: user.email || '',
    phone: user.phone || '', default_address: user.default_address || '',
  })
  const [pwd, setPwd] = useState({ old: '', new1: '', new2: '' })
  const [msg, setMsg] = useState('')
  const [error, setError] = useState('')
  const [saving, setSaving] = useState(false)
  const [changing, setChanging] = useState(false)

  const nameRegex = /^[А-Яа-яЁёA-Za-z\s-]+$/
  const phoneRegex = /^\+?[0-9\s\-\(\)]{10,20}$/

  function update(key, value) { setForm(p => ({ ...p, [key]: value })) }

  async function saveProfile(e) {
    e.preventDefault()
    setMsg(''); setError('')
    if (!form.name.trim() || !form.email.trim()) return setError('Имя и email обязательны.')
    if (!nameRegex.test(form.name)) return setError('ФИО должно содержать только буквы.')
    if (form.phone && !phoneRegex.test(form.phone)) return setError('Неверный формат телефона.')
    setSaving(true)
    try {
      await api.updateProfile(user.id, form)
      login({ ...user, ...form })
      setMsg('Данные сохранены.')
    } catch (err) { setError(err.message) }
    finally { setSaving(false) }
  }

  async function savePassword(e) {
    e.preventDefault()
    setMsg(''); setError('')
    if (pwd.new1.length < 6) return setError('Пароль должен быть не короче 6 символов.')
    if (pwd.new1 !== pwd.new2) return setError('Пароли не совпадают.')
    setChanging(true)
    try {
      await api.changePassword(user.id, pwd.old, pwd.new1)
      setPwd({ old: '', new1: '', new2: '' })
      setMsg('Пароль изменён.')
    } catch (err) { setError(err.message) }
    finally { setChanging(false) }
  }

  return (
    <section>
      <h1>Личный кабинет</h1>
      {msg && <div className="success-box">{msg}</div>}
      {error && <div className="error">{error}</div>}

      <form className="service-form" onSubmit={saveProfile}>
        <h3>Личные данные</h3>
        <input placeholder="ФИО" value={form.name} onChange={(e) => update('name', e.target.value)} />
        <input placeholder="Email" value={form.email} onChange={(e) => update('email', e.target.value)} />
        <input placeholder="Телефон" value={form.phone} onChange={(e) => update('phone', e.target.value)} />
        {!isAdmin && (
          <input placeholder="Адрес по умолчанию" value={form.default_address}
                 onChange={(e) => update('default_address', e.target.value)} />
        )}
        <button disabled={saving}>{saving ? 'Сохранение...' : 'Сохранить'}</button>
      </form>

      <form className="service-form" onSubmit={savePassword}>
        <h3>Смена пароля</h3>
        <input type="password" placeholder="Старый пароль"
               value={pwd.old} onChange={(e) => setPwd(p => ({ ...p, old: e.target.value }))} />
        <input type="password" placeholder="Новый пароль"
               value={pwd.new1} onChange={(e) => setPwd(p => ({ ...p, new1: e.target.value }))} />
        <input type="password" placeholder="Повторите новый пароль"
               value={pwd.new2} onChange={(e) => setPwd(p => ({ ...p, new2: e.target.value }))} />
        <button disabled={changing}>{changing ? 'Изменение...' : 'Сменить пароль'}</button>
      </form>
    </section>
  )
}