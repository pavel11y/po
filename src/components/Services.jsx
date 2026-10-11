import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { api } from '../api'
import { useAuth } from '../context/AuthContext'
import { useCart } from '../context/CartContext'

export default function Services() {
  const { user } = useAuth()
  const { addToCart } = useCart()
  const [services, setServices] = useState([])
  const [categories, setCategories] = useState([])
  const [selectedCategory, setSelectedCategory] = useState('all')
  const [minPrice, setMinPrice] = useState('')
  const [maxPrice, setMaxPrice] = useState('')
  const [search, setSearch] = useState('')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    async function load() {
      try {
        setLoading(true)
        const [s, c] = await Promise.all([api.services(), api.categories()])
        setServices(s)
        setCategories(c)
      } catch (err) { setError(err.message) }
      finally { setLoading(false) }
    }
    load()
  }, [])

  const filtered = services.filter(s => {
    if (selectedCategory !== 'all' && s.category_title !== selectedCategory) return false
    if (minPrice && Number(s.price) < Number(minPrice)) return false
    if (maxPrice && Number(s.price) > Number(maxPrice)) return false
    if (search && !s.name.toLowerCase().includes(search.toLowerCase())) return false
    return true
  })

  if (loading) return <div className="state">Загрузка каталога...</div>
  if (error) return <div className="state error">{error}</div>

  return (
    <section>
      <div className="page-title">
        <h1>Каталог лунных участков</h1>
        {user?.discount_percent > 0 && !user?.first_order_done && (
          <div className="discount-info">Ваша скидка: {user.discount_percent}%</div>
        )}
      </div>

      <div className="filters-row">
        <input placeholder="Поиск по названию..."
               value={search} onChange={(e) => setSearch(e.target.value)} />
        <select value={selectedCategory} onChange={(e) => setSelectedCategory(e.target.value)}>
          <option value="all">Все категории</option>
          {categories.map(c => <option key={c.id} value={c.title}>{c.title}</option>)}
        </select>
        <input type="number" placeholder="Цена от" value={minPrice}
               onChange={(e) => setMinPrice(e.target.value)} />
        <input type="number" placeholder="Цена до" value={maxPrice}
               onChange={(e) => setMaxPrice(e.target.value)} />
      </div>
      <p className="filters-info">Найдено участков: {filtered.length}</p>

      <div className="services-grid">
        {filtered.map(s => {
          const userDiscount = user?.first_order_done ? 0 : Number(user?.discount_percent || 0)
          const d = Math.min(75, Number(s.discount_percent) + userDiscount)
          const finalPrice = Math.round(Number(s.price) * (1 - d / 100))
          return (
            <div className="service-card" key={s.id}>
              {s.image_url && <img src={s.image_url} alt={s.name} />}
              <span className="service-category">{s.category_title}</span>
              <h2>{s.name}</h2>
              <p className="duration">Площадь: {s.area} акров</p>
              <p className="duration">В наличии: {s.stock} шт.</p>
              <div className="price">
                {finalPrice.toLocaleString()} ₽
                {d > 0 && <span className="old-price">{Number(s.price).toLocaleString()} ₽</span>}
              </div>
              {d > 0 && <div className="discount">Скидка {d}%</div>}

              <button onClick={() => addToCart(s)} disabled={!user}>
                {user ? 'В корзину' : 'Войдите для покупки'}
              </button>
              <Link to={`/reviews/${s.id}`} className="btn-link">Отзывы</Link>
            </div>
          )
        })}
      </div>
    </section>
  )
}