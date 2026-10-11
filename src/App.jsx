import { Navigate, Route, Routes } from 'react-router-dom'
import { useAuth } from './context/AuthContext'
import Menu from './Menu'
import Login from './login'
import Services from './components/Services'
import Cart from './components/Cart'
import AdminPanel from './AdminPanel'
import CategoriesList from './components/CategoriesList'
import ServicesList from './components/ServicesList'
import OrdersList from './components/OrdersList'
import ReviewsList from './components/ReviewsList'
import MyOrders from './components/MyOrders'
import Profile from './components/Profile'
import ReviewsPage from './components/ReviewsPage'

export default function App() {
  const { user } = useAuth()

  if (!user) return <Login />

  const isAdmin = user.role_title === 'Администратор'

  return (
    <div className="app">
      {isAdmin ? <AdminPanel /> : <Menu />}

      <main className="content">
        <Routes>
          <Route path="/" element={<Navigate to="/services" replace />} />
          <Route path="/services" element={<Services />} />
          <Route path="/reviews/:id" element={<ReviewsPage />} />
          <Route path="/profile" element={<Profile />} />

          {!isAdmin && (
            <>
              <Route path="/cart" element={<Cart />} />
              <Route path="/orders" element={<MyOrders />} />
            </>
          )}

          {isAdmin && (
            <>
              <Route path="/admin/categories" element={<CategoriesList />} />
              <Route path="/admin/services" element={<ServicesList />} />
              <Route path="/admin/orders" element={<OrdersList />} />
              <Route path="/admin/reviews" element={<ReviewsList />} />
              <Route path="/admin/access-denied" element={<AccessDenied />} />
            </>
          )}

          <Route path="*" element={<Navigate to="/services" replace />} />
        </Routes>
      </main>
    </div>
  )
}

function AccessDenied() {
  return (
    <div className="empty-box">
      <h1>Доступ запрещён</h1>
      <p>У вас нет прав для просмотра этой страницы.</p>
    </div>
  )
}