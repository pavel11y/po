import { useEffect, useState } from 'react'
import { api } from '../api'
import { useAuth } from '../context/AuthContext'

function formatDate(v) {
  const d = new Date(v)
  const pad = (n) => String(n).padStart(2, '0')
  return `${pad(d.getDate())}.${pad(d.getMonth() + 1)}.${d.getFullYear()} ${pad(d.getHours())}:${pad(d.getMinutes())}`
}

export default function MyOrders() {
  const { user } = useAuth()
  const [orders, setOrders] = useState([])
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(true)

  async function load() {
    try {
      setLoading(true); setError('')
      setOrders(await api.myOrders(user.id))
    } catch (err) { setError(err.message) }
    finally { setLoading(false) }
  }

  useEffect(() => { load() }, [])

  if (loading) return <div className="state">Загрузка заказов...</div>
  if (error) return <div className="state error">{error}<br /><button onClick={load}>Повторить</button></div>

  return (
    <section>
      <h1>Мои заказы лунных участков</h1>

      {!orders.length && <div className="empty-box">Заказов пока нет.</div>}

      {orders.map(o => (
        <div className="order-card" key={o.id}>
          <div className="order-head">
            <b>Заказ №{o.id}</b>
            <span>{formatDate(o.created_at)}</span>
            <span className="badge">{o.status}</span>
          </div>
          <p>Адрес: {o.address}</p>
          <p>Доставка: {o.delivery_date?.slice(0, 10)}</p>
          <ul>
            {o.items.map((it, i) => (
              <li key={i}>{it.service_name} × {it.quantity} = {Number(it.price).toLocaleString()} ₽</li>
            ))}
          </ul>
          <b>Итого: {Number(o.total).toLocaleString()} ₽</b>
        </div>
      ))}
    </section>
  )
}