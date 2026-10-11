import { NavLink } from 'react-router-dom'
import { useAuth } from './context/AuthContext'
import ThemeToggle from './components/ThemeToggle'

export default function AdminPanel() {
  const { user, logout } = useAuth()

  return (
    <header className="navbar admin-navbar">
      <NavLink to="/services" className="logo">Lunar Estates — Админ</NavLink>

      <nav>
        <NavLink to="/services">Каталог</NavLink>
        <NavLink to="/admin/categories">Категории</NavLink>
        <NavLink to="/admin/services">Участки</NavLink>
        <NavLink to="/admin/orders">Заказы</NavLink>
        <NavLink to="/admin/reviews">Отзывы</NavLink>
        <NavLink to="/profile">Профиль</NavLink>
      </nav>

      <div className="user-box">
        <ThemeToggle />
        <span>{user.email}</span>
        <b>{user.role_title}</b>
        <button onClick={logout}>Выйти</button>
      </div>
    </header>
  )
}