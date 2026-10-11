import { useEffect, useState } from 'react'
import { api } from '../api'
import { useAuth } from '../context/AuthContext'

export default function UsersList() {
  const { user } = useAuth()
  const [users, setUsers] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  async function load() {
    try {
      setLoading(true)
      setUsers(await api.users(user.id))
    } catch (err) { setError(err.message) }
    finally { setLoading(false) }
  }
  useEffect(() => { load() }, [])

  async function changeDiscount(u, value) {
    try {
      await api.updateUser(u.id, { discount_percent: value, role_id: u.role_id }, user.id)
      load()
    } catch (err) { setError(err.message) }
  }

  async function changeRole(u, role_id) {
    try {
      await api.updateUser(u.id, { discount_percent: u.discount_percent, role_id }, user.id)
      load()
    } catch (err) { setError(err.message) }
  }

  async function removeUser(u) {
    if (!confirm(`Удалить пользователя ${u.email}? Действие необратимо.`)) return
    try {
      await api.deleteUser(u.id, user.id)
      load()
    } catch (err) { setError(err.message) }
  }

  if (loading) return <div className="state">Загрузка пользователей...</div>

  return (
    <section>
      <h1>Пользователи</h1>
      {error && <div className="error">{error}</div>}
      <div className="admin-table">
        {users.map(u => (
          <div className="service-row" key={u.id}>
            <span><b>{u.name}</b><small>{u.email}</small></span>
            <span>{u.phone || '—'}</span>
            <select value={u.role_id} onChange={(e) => changeRole(u, Number(e.target.value))}>
              <option value={1}>Администратор</option>
              <option value={2}>Пользователь</option>
            </select>
            <span>
              Скидка:
              <input type="number" defaultValue={u.discount_percent}
                     onBlur={(e) => changeDiscount(u, e.target.value)}
                     style={{ width: 60, marginLeft: 6 }} /> %
            </span>
            <button className="danger" onClick={() => removeUser(u)}>Удалить</button>
          </div>
        ))}
      </div>
    </section>
  )
}