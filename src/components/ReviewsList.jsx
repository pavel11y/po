import { useEffect, useState } from 'react'
import { api } from '../api'
import { useAuth } from '../context/AuthContext'

function formatDate(v) {
  if (!v) return ''
  const d = new Date(v)
  const pad = (n) => String(n).padStart(2, '0')
  return `${pad(d.getDate())}.${pad(d.getMonth() + 1)}.${d.getFullYear()} ${pad(d.getHours())}:${pad(d.getMinutes())}`
}

export default function ReviewsList() {
  const { user } = useAuth()
  const [items, setItems] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [editId, setEditId] = useState(null)
  const [editForm, setEditForm] = useState({ rating: 5, comment: '' })
  const [saving, setSaving] = useState(false)
  const [reason, setReason] = useState({})

  async function load() {
    try {
      setLoading(true); setError('')
      setItems(await api.allReviews(user.id))
    } catch (err) { setError(err.message) }
    finally { setLoading(false) }
  }
  useEffect(() => { load() }, [])

  async function saveEdit(e) {
    e.preventDefault()
    setError('')
    if (!editForm.comment.trim() || editForm.comment.trim().length < 5) {
      return setError('Отзыв должен быть не короче 5 символов.')
    }
    setSaving(true)
    try {
      await api.adminUpdateReview(editId, editForm.rating, editForm.comment.trim(), user.id)
      setEditId(null); load()
    } catch (err) { setError(err.message) }
    finally { setSaving(false) }
  }

  async function removeReview(r) {
    const rsn = reason[r.id] || 'Удалено за нарушение политики'
    if (!confirm(`Удалить отзыв от ${r.user_name}? Причина: "${rsn}"`)) return
    try {
      await api.deleteReview(r.id, user.id, rsn)
      load()
    } catch (err) { setError(err.message) }
  }

  if (loading) return <div className="state">Загрузка отзывов...</div>

  return (
    <section>
      <h1>Отзывы покупателей</h1>
      {error && <div className="error">{error}</div>}
      {!items.length && <div className="empty-box">Отзывов пока нет.</div>}

      <div className="admin-table">
        {items.map(r => (
          <div className="service-row" key={r.id} style={{ gridTemplateColumns: '2fr 1fr 2fr auto auto' }}>
            <span>
              <b>{r.service_name}</b>
              <small>{r.user_name} • {r.user_email}</small>
            </span>
            <span>
              <b>★ {r.rating}/5</b>
              <small>{formatDate(r.created_at)}</small>
            </span>
            {editId === r.id ? (
              <form onSubmit={saveEdit} style={{ display: 'grid', gap: 6 }}>
                <select value={editForm.rating}
                        onChange={(e) => setEditForm(p => ({ ...p, rating: Number(e.target.value) }))}>
                  <option value={5}>5 — Отлично</option>
                  <option value={4}>4 — Хорошо</option>
                  <option value={3}>3 — Нормально</option>
                  <option value={2}>2 — Плохо</option>
                  <option value={1}>1 — Ужасно</option>
                </select>
                <textarea value={editForm.comment}
                          onChange={(e) => setEditForm(p => ({ ...p, comment: e.target.value }))}
                          style={{ minHeight: 60 }} />
                <div style={{ display: 'flex', gap: 6 }}>
                  <button disabled={saving}>Сохранить</button>
                  <button type="button" className="secondary" onClick={() => setEditId(null)}>Отмена</button>
                </div>
              </form>
            ) : r.is_deleted ? (
              <span style={{ color: 'var(--danger)', fontStyle: 'italic' }}>
                Удалено: {r.delete_reason}
              </span>
            ) : (
              <span>{r.comment}</span>
            )}

            {!r.is_deleted && editId !== r.id && (
              <>
                <button onClick={() => { setEditId(r.id); setEditForm({ rating: r.rating, comment: r.comment }) }}>
                  Изменить
                </button>
                <div style={{ display: 'flex', gap: 6 }}>
                  <input placeholder="Причина удаления"
                         value={reason[r.id] || ''}
                         onChange={(e) => setReason(p => ({ ...p, [r.id]: e.target.value }))}
                         style={{ width: 140 }} />
                  <button className="danger" onClick={() => removeReview(r)}>Удалить</button>
                </div>
              </>
            )}
          </div>
        ))}
      </div>
    </section>
  )
}