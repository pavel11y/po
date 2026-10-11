import { useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { api } from '../api'
import { useAuth } from '../context/AuthContext'

export default function ReviewsPage() {
  const { id } = useParams()
  const { user } = useAuth()
  const [reviews, setReviews] = useState([])
  const [services, setServices] = useState([])
  const [rating, setRating] = useState(5)
  const [comment, setComment] = useState('')
  const [editId, setEditId] = useState(null)
  const [editForm, setEditForm] = useState({ rating: 5, comment: '' })
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(true)
  const [sending, setSending] = useState(false)

  async function load() {
    try {
      setLoading(true)
      const [r, s] = await Promise.all([api.reviewsForService(id), api.services()])
      setReviews(r)
      setServices(s)
    } catch (err) { setError(err.message) }
    finally { setLoading(false) }
  }
  useEffect(() => { load() }, [id])

  async function submit(e) {
    e.preventDefault()
    setError('')
    if (!comment.trim()) return setError('Введите комментарий.')
    if (comment.trim().length < 5) return setError('Отзыв не короче 5 символов.')
    setSending(true)
    try {
      await api.addReview(user.id, id, rating, comment.trim())
      setComment(''); setRating(5); load()
    } catch (err) { setError(err.message) }
    finally { setSending(false) }
  }

  async function saveEdit(e) {
    e.preventDefault()
    setError('')
    if (!editForm.comment.trim()) return setError('Введите комментарий.')
    if (editForm.comment.trim().length < 5) return setError('Отзыв не короче 5 символов.')
    setSending(true)
    try {
      await api.updateReview(editId, user.id, editForm.rating, editForm.comment.trim())
      setEditId(null); load()
    } catch (err) { setError(err.message) }
    finally { setSending(false) }
  }

  const service = services.find(s => s.id === Number(id))
  const myReview = reviews.find(r => Number(r.user_id) === Number(user?.id) && !r.is_deleted)

  if (loading) return <div className="state">Загрузка отзывов...</div>

  return (
    <section>
      <p className="back-link"><Link to="/services">← Назад к каталогу</Link></p>
      <h1>Отзывы: {service?.name || 'Участок'}</h1>
      <p className="reviews-subtitle">Всего отзывов: {reviews.length}</p>

      {error && <div className="error">{error}</div>}

      {reviews.length === 0 && <div className="empty-box">Пока нет отзывов.</div>}

      <div className="reviews-list">
        {reviews.map(r => (
          <div className="review-card" key={r.id}>
            <div className="review-head">
              <b>{r.user_name}</b>
              <span className="review-rating">★ {r.rating}/5</span>
              <span className="review-date">{new Date(r.created_at).toLocaleDateString()}</span>
              {Number(r.user_id) === Number(user?.id) && !r.is_deleted && (
                <button
                  className="secondary"
                  style={{ marginLeft: 'auto', padding: '4px 10px', fontSize: 12 }}
                  onClick={() => { setEditId(r.id); setEditForm({ rating: r.rating, comment: r.comment }) }}
                >Редактировать</button>
              )}
            </div>
            {r.is_deleted ? (
              <p style={{ color: 'var(--danger)', fontStyle: 'italic' }}>
                Отзыв удалён администратором: {r.delete_reason}
              </p>
            ) : editId === r.id ? (
              <form onSubmit={saveEdit} style={{ display: 'grid', gap: 8, marginTop: 8 }}>
                <select value={editForm.rating} onChange={(e) => setEditForm(p => ({ ...p, rating: Number(e.target.value) }))}>
                  <option value={5}>5 — Отлично</option>
                  <option value={4}>4 — Хорошо</option>
                  <option value={3}>3 — Нормально</option>
                  <option value={2}>2 — Плохо</option>
                  <option value={1}>1 — Ужасно</option>
                </select>
                <textarea value={editForm.comment}
                          onChange={(e) => setEditForm(p => ({ ...p, comment: e.target.value }))} />
                <div style={{ display: 'flex', gap: 8 }}>
                  <button disabled={sending}>Сохранить</button>
                  <button type="button" className="secondary" onClick={() => setEditId(null)}>Отмена</button>
                </div>
              </form>
            ) : (
              <p>{r.comment}</p>
            )}
          </div>
        ))}
      </div>

      {user && !myReview && (
        <form className="review-form" onSubmit={submit}>
          <h2>Оставить отзыв</h2>
          <select value={rating} onChange={(e) => setRating(Number(e.target.value))}>
            <option value={5}>5 — Отлично</option>
            <option value={4}>4 — Хорошо</option>
            <option value={3}>3 — Нормально</option>
            <option value={2}>2 — Плохо</option>
            <option value={1}>1 — Ужасно</option>
          </select>
          <textarea value={comment} onChange={(e) => setComment(e.target.value)} placeholder="Ваш отзыв (минимум 5 символов)..." />
          <button disabled={sending}>{sending ? 'Отправка...' : 'Отправить'}</button>
        </form>
      )}

      {user && myReview && (
        <div className="empty-box" style={{ marginTop: 20 }}>
          Вы уже оставляли отзыв. Можете отредактировать его выше.
        </div>
      )}
    </section>
  )
}