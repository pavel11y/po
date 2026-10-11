import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { api } from '../api'
import { useAuth } from '../context/AuthContext'
import { useCart } from '../context/CartContext'

export default function Cart() {
  const { user } = useAuth()
  const { cart, updateQuantity, removeFromCart, clearCart, reload } = useCart()
  const navigate = useNavigate()
  const [address, setAddress] = useState(user.default_address || '')
  const [date, setDate] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const userDiscount = user.first_order_done ? 0 : Number(user.discount_percent || 0)

  const total = cart.reduce((sum, item) => {
    const d = Math.min(75, Number(item.discount_percent) + userDiscount)
    return sum + Math.round(Number(item.price) * (1 - d / 100)) * item.quantity
  }, 0)

  async function checkout() {
    setError('')
    if (!address.trim()) return setError('Введите адрес доставки.')
    if (!date) return setError('Выберите дату доставки.')
    const today = new Date(); today.setHours(0, 0, 0, 0)
    if (new Date(date) < today) return setError('Дата доставки не может быть в прошлом.')

    setLoading(true)
    try {
      await api.createOrder(user.id, address.trim(), date)
      await reload()
      navigate('/orders')
    } catch (err) { setError(err.message) }
    finally { setLoading(false) }
  }

  if (!cart.length) {
    return (
      <div className="empty-box">
        <h1>Корзина пуста</h1>
        <Link to="/services">Перейти к каталогу</Link>
      </div>
    )
  }

  return (
    <section>
      <h1>Корзина — Лунные участки</h1>
      {error && <div className="error">{error}</div>}

      <div className="cart-layout">
        <div>
          {cart.map(item => {
            const d = Math.min(75, Number(item.discount_percent) + userDiscount)
            const price = Math.round(Number(item.price) * (1 - d / 100))
            return (
              <div className="cart-item" key={item.id}>
                <div>
                  <h3>{item.name}</h3>
                  <p>{price.toLocaleString()} ₽ за участок</p>
                  <small>{item.category_title}</small>
                </div>
                <div className="quantity">
                  <button onClick={() => updateQuantity(item.id, item.quantity - 1)}>−</button>
                  <b>{item.quantity}</b>
                  <button onClick={() => updateQuantity(item.id, item.quantity + 1)} disabled={item.quantity >= 10 || item.quantity >= item.stock}>+</button>
                </div>
                <button className="danger" onClick={() => removeFromCart(item.id)}>Удалить</button>
              </div>
            )
          })}
        </div>

        <aside className="summary">
          <h2>Итого</h2>
          <p>Участков: {cart.reduce((s, i) => s + i.quantity, 0)}</p>
          <h2>{total.toLocaleString()} ₽</h2>

          <label>Адрес доставки (координаты базы)</label>
          <input value={address}
                 onChange={(e) => setAddress(e.target.value)}
                 placeholder="Лунная база, сектор" />

          <label>Дата доставки</label>
          <input type="date" value={date} onChange={(e) => setDate(e.target.value)} />

          <button onClick={checkout} disabled={loading}>
            {loading ? 'Оформление...' : 'Оформить заказ'}
          </button>
          <button className="secondary" onClick={clearCart}>Очистить корзину</button>
        </aside>
      </div>
    </section>
  )
}