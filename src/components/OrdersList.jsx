import { useEffect, useState } from 'react'
import { api } from '../api'
import { useAuth } from '../context/AuthContext'

function formatDateTime(value) {
  if (!value) return ''
  const d = new Date(value)
  if (isNaN(d.getTime())) return value
  const pad = (n) => String(n).padStart(2, '0')
  return `${pad(d.getDate())}.${pad(d.getMonth() + 1)}.${d.getFullYear()} ${pad(d.getHours())}:${pad(d.getMinutes())}`
}

export default function OrdersList() {
  const { user } = useAuth()
  const [items, setItems] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  async function load() {
    try {
      setLoading(true); setError('')
      setItems(await api.allOrders(user.id))
    } catch (err) { setError(err.message) }
    finally { setLoading(false) }
  }
  useEffect(() => { load() }, [])

  async function changeStatus(id, status) {
    try {
      await api.updateOrderStatus(id, status, user.id)
      load()
    } catch (err) { setError(err.message) }
  }

  if (loading) return <div className="state">Загрузка заказов...</div>

  return (
    <section>
      <h1>Все заказы лунных участков</h1>
      {error && <div className="error">{error}</div>}
      <div className="admin-table">
        {items.map(o => (
          <div className="service-row" key={o.id}>
            <span><b>{o.user_name || o.email}</b><small>{o.address}</small></span>
            <span>{formatDateTime(o.created_at)}</span>
            <span>Доставка: {o.delivery_date?.slice(0, 10)}</span>
            <span>{Number(o.total).toLocaleString()} ₽</span>
            <select value={o.status} onChange={(e) => changeStatus(o.id, e.target.value)}>
              <option disabled={o.status === 'Оплачен'}>Ожидает оплаты</option>
              <option>В обработке</option>
              <option>Подтверждён</option>
              <option>Доставлен</option>
              <option>Отменён</option>
              <option>Оплачен</option>
            </select>
          </div>
        ))}
      </div>
    </section>
  )
}