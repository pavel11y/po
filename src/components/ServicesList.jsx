import { useEffect, useState } from 'react'
import { api } from '../api'
import { useAuth } from '../context/AuthContext'

const EMPTY = {
  name: '', description: '', area: '', price: '',
  category_id: '', discount_percent: 0, image_url: '', stock: 0,
}

export default function ServicesList() {
  const { user } = useAuth()
  const [items, setItems] = useState([])
  const [categories, setCategories] = useState([])
  const [form, setForm] = useState(EMPTY)
  const [editId, setEditId] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  async function load() {
    try {
      setLoading(true)
      const [s, c] = await Promise.all([api.services(), api.categories()])
      setItems(s); setCategories(c)
    } catch (err) { setError(err.message) }
    finally { setLoading(false) }
  }
  useEffect(() => { load() }, [])

  function update(key, value) { setForm(prev => ({ ...prev, [key]: value })) }

  async function submit(e) {
    e.preventDefault()
    setError('')
    if (!form.name.trim()) return setError('Введите название.')
    if (!form.price || Number(form.price) <= 0) return setError('Введите корректную цену (больше 0).')
    if (!form.area || Number(form.area) <= 0) return setError('Введите корректную площадь.')
    if (!form.category_id) return setError('Выберите категорию.')
    if (Number(form.stock) < 0) return setError('Количество не может быть отрицательным.')

    try {
      if (editId) await api.updateService(editId, form, user.id)
      else await api.addService(form, user.id)
      setForm(EMPTY); setEditId(null); load()
    } catch (err) { setError(err.message) }
  }

  function edit(s) {
    setEditId(s.id)
    setForm({
      name: s.name, description: s.description, area: s.area,
      price: s.price, category_id: s.category_id,
      discount_percent: s.discount_percent, image_url: s.image_url || '',
      stock: s.stock || 0,
    })
  }

  async function remove(id) {
    if (!confirm('Удалить участок?')) return
    try { await api.deleteService(id, user.id); load() }
    catch (err) { setError(err.message) }
  }

  if (loading) return <div className="state">Загрузка участков...</div>

  return (
    <section>
      <h1>Управление участками</h1>
      {error && <div className="error">{error}</div>}

      <form className="service-form" onSubmit={submit}>
        <input placeholder="Название" value={form.name} onChange={(e) => update('name', e.target.value)} />
        <textarea placeholder="Описание" value={form.description} onChange={(e) => update('description', e.target.value)} />
        <input type="number" placeholder="Площадь (акры)" value={form.area} onChange={(e) => update('area', e.target.value)} />
        <input type="number" placeholder="Цена" value={form.price} onChange={(e) => update('price', e.target.value)} />
        <input type="number" placeholder="Количество в наличии" value={form.stock} onChange={(e) => update('stock', e.target.value)} />
        <input placeholder="URL изображения" value={form.image_url} onChange={(e) => update('image_url', e.target.value)} />
        <select value={form.category_id} onChange={(e) => update('category_id', e.target.value)}>
          <option value="">-- Выберите категорию --</option>
          {categories.map(c => <option key={c.id} value={c.id}>{c.title}</option>)}
        </select>
        <input type="number" placeholder="Скидка %" value={form.discount_percent} onChange={(e) => update('discount_percent', e.target.value)} />
        <button>{editId ? 'Сохранить' : 'Добавить'}</button>
        {editId && <button type="button" onClick={() => { setEditId(null); setForm(EMPTY) }}>Отмена</button>}
      </form>

      <div className="admin-table">
        {items.map(s => (
          <div className="service-row" key={s.id}>
            <span><b>{s.name}</b><small>{s.category_title}</small></span>
            <span>{s.area} акров</span>
            <span>{Number(s.price).toLocaleString()} ₽</span>
            <span>В наличии: {s.stock}</span>
            <button onClick={() => edit(s)}>Изменить</button>
            <button className="danger" onClick={() => remove(s.id)}>Удалить</button>
          </div>
        ))}
      </div>
    </section>
  )
}