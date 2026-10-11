import { NavLink } from 'react-router-dom'
import { useAuth } from './context/AuthContext'
import { useCart } from './context/CartContext'
import ThemeToggle from './components/ThemeToggle'

export default function Menu() {
  const { user, logout } = useAuth()
  const { totalCount } = useCart()

  return (
    <header className="navbar">
      <NavLink to="/services" className="logo">🌙 Lunar Estates</NavLink>

      <nav>
        <NavLink to="/services">Каталог</NavLink>
        <NavLink to="/cart">Корзина {totalCount > 0 && `(${totalCount})`}</NavLink>
        <NavLink to="/orders">Мои заказы</NavLink>
        <NavLink to="/profile">Личный кабинет</NavLink>
      </nav>

      <div className="user-box">
        <ThemeToggle />
        <span>{user.name || user.email}</span>
        {user.discount_percent > 0 && !user.first_order_done && (
          <small>Скидка: {user.discount_percent}%</small>
        )}
        <button onClick={logout}>Выйти</button>
      </div>
    </header>
  )
}