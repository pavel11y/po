import { useEffect, useState } from 'react'
import { api } from '../api'
import { useAuth } from '../context/AuthContext'

export default function CategoriesList() {
  const { user } = useAuth()
  const [categories, setCategories] = useState([])
  const [title, setTitle] = useState('')
  const [editId, setEditId] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  async function load() {
    try {
      setLoading(true)
      setCategories(await api.categories())
    } catch (err) { setError(err.message) }
    finally { setLoading(false) }
  }
  useEffect(() => { load() }, [])

  async function submit(e) {
    e.preventDefault()
    setError('')
    const trimmed = title.trim()
    if (!trimmed) return setError('Введите название категории.')

    try {
      if (editId) {
        await api.updateCategory(editId, trimmed, user.id)
        setEditId(null)
      } else {
        const dup = categories.some(c => c.title.toLowerCase() === trimmed.toLowerCase())
        if (dup) return setError(`Категория «${trimmed}» уже существует.`)
        await api.addCategory(trimmed, user.id)
      }
      setTitle(''); load()
    } catch (err) { setError(err.message) }
  }

  async function remove(c) {
    if (c.title === 'Без категории') {
      return setError('Нельзя удалить категорию "Без категории"')
    }
    if (!confirm(`Удалить категорию «${c.title}»? Участки перейдут в "Без категории".`)) return
    try { await api.deleteCategory(c.id, user.id); load() }
    catch (err) { setError(err.message) }
  }

  function edit(c) {
    setEditId(c.id)
    setTitle(c.title)
  }

  function cancel() {
    setEditId(null); setTitle(''); setError('')
  }

  if (loading) return <div className="state">Загрузка категорий...</div>

  return (
    <section>
      <h1>Категории лунных участков</h1>
      <form className="admin-form" onSubmit={submit}>
        <input value={title} onChange={(e) => setTitle(e.target.value)}
               placeholder="Название категории" />
        <button>{editId ? 'Сохранить' : 'Добавить'}</button>
        {editId && <button type="button" className="secondary" onClick={cancel}>Отмена</button>}
      </form>
      {error && <div className="error">{error}</div>}
      <div className="admin-table">
        {categories.map((c, index) => (
          <div className="service-row" key={c.id}>
            <span><b>{index + 1}</b><small>{c.title}</small></span>
            <button onClick={() => edit(c)}>Изменить</button>
            <button className="danger" onClick={() => remove(c)} disabled={c.title === 'Без категории'}>
              Удалить
            </button>
          </div>
        ))}
      </div>
    </section>
  )
}