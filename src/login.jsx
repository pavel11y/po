import { useState } from 'react'
import { useAuth } from './context/AuthContext'
import { api } from './api'
import ThemeToggle from './components/ThemeToggle'

const TEST_ACCOUNTS = [
  { role: 'Администратор', icon: '👑', email: 'admin@lunar.ru', password: 'admin123' },
  { role: 'Пользователь', icon: '👤', email: 'user@lunar.ru', password: 'user123' },
]

export default function Login() {
  const { login } = useAuth()
  const [mode, setMode] = useState('login')
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [phone, setPhone] = useState('')
  const [password, setPassword] = useState('')
  const [confirm, setConfirm] = useState('')
  const [code, setCode] = useState('')
  const [newPassword, setNewPassword] = useState('')
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(false)

  function switchMode(next) {
    setMode(next); setError(''); setMessage(''); setPassword(''); setConfirm('')
  }

  const phoneRegex = /^\+?[0-9\s\-\(\)]{10,20}$/
  const nameRegex = /^[А-Яа-яЁёA-Za-z\s-]+$/

  async function submit(e) {
    e.preventDefault()
    setError(''); setMessage('')
    if (!email || !password) return setError('Заполните email и пароль.')
    if (!email.includes('@')) return setError('Введите корректный email.')

    if (mode === 'register') {
      if (!name.trim()) return setError('Введите имя.')
      if (!nameRegex.test(name)) return setError('ФИО должно содержать только буквы.')
      if (!phone.trim()) return setError('Введите телефон.')
      if (!phoneRegex.test(phone)) return setError('Неверный формат телефона.')
      if (password.length < 6) return setError('Пароль не короче 6 символов.')
      if (password !== confirm) return setError('Пароли не совпадают.')
    }

    setLoading(true)
    try {
      if (mode === 'login') {
        login(await api.login(email, password))
      } else {
        login(await api.register(name, email, password, phone))
      }
    } catch (err) { setError(err.message) }
    finally { setLoading(false) }
  }

  async function submitForgot(e) {
    e.preventDefault()
    setError(''); setMessage('')
    if (!email || !email.includes('@')) return setError('Введите корректный email.')
    setLoading(true)
    try {
      await api.forgotPassword(email)
      setMessage('Код отправлен на почту')
      setMode('reset')
    } catch (err) { setError(err.message) }
    finally { setLoading(false) }
  }

  async function submitReset(e) {
    e.preventDefault()
    setError(''); setMessage('')
    if (!code || code.length !== 6) return setError('Введите 6-значный код.')
    if (newPassword.length < 6) return setError('Пароль не короче 6 символов.')
    setLoading(true)
    try {
      await api.resetPassword(email, code, newPassword)
      setMessage('Пароль изменён. Войдите.')
      setMode('login')
    } catch (err) { setError(err.message) }
    finally { setLoading(false) }
  }

  async function quickLogin(account) {
    setError('')
    setEmail(account.email)
    setPassword(account.password)
    setLoading(true)
    try {
      login(await api.login(account.email, account.password))
    } catch (err) {
      setError(`Не удалось войти как ${account.role}: ${err.message}`)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="login-page">
      <div className="login-theme-toggle">
        <ThemeToggle />
      </div>

      <form className="login-card" onSubmit={mode === 'forgot' ? submitForgot : mode === 'reset' ? submitReset : submit}>
        <h1>Lunar Estates</h1>
        <p>
          {mode === 'login' && 'Авторизация'}
          {mode === 'register' && 'Регистрация покупателя'}
          {mode === 'forgot' && 'Восстановление пароля'}
          {mode === 'reset' && 'Введите код и новый пароль'}
        </p>
        {error && <div className="error">{error}</div>}
        {message && <div className="success-box">{message}</div>}

        {mode === 'register' && (
          <>
            <label>Полное имя</label>
            <input value={name} onChange={(e) => setName(e.target.value)} placeholder="Иван Петров" />
            <label>Телефон</label>
            <input value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="+7 900 000-00-00" />
          </>
        )}

        {mode !== 'reset' && (
          <>
            <label>Email</label>
            <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="user@lunar.ru" />
          </>
        )}

        {mode !== 'reset' && mode !== 'forgot' && (
          <>
            <label>Пароль</label>
            <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Пароль" />
          </>
        )}

        {mode === 'register' && (
          <>
            <label>Повторите пароль</label>
            <input type="password" value={confirm} onChange={(e) => setConfirm(e.target.value)} placeholder="Повторите пароль" />
          </>
        )}

        {mode === 'reset' && (
          <>
            <label>Код из письма</label>
            <input value={code} onChange={(e) => setCode(e.target.value)} placeholder="123456" maxLength={6} />
            <label>Новый пароль</label>
            <input type="password" value={newPassword} onChange={(e) => setNewPassword(e.target.value)} placeholder="Новый пароль" />
          </>
        )}

        <button disabled={loading}>
          {loading ? 'Отправка...' : (
            mode === 'login' ? 'Войти' :
            mode === 'register' ? 'Зарегистрироваться' :
            mode === 'forgot' ? 'Отправить код' : 'Сбросить пароль'
          )}
        </button>

        {mode === 'login' && (
          <div className="quick-login">
            <p className="quick-login-title">Быстрый вход (тестовые аккаунты):</p>
            <div className="quick-login-buttons">
              {TEST_ACCOUNTS.map(acc => (
                <button
                  key={acc.email}
                  type="button"
                  className={`quick-login-btn quick-login-btn--${acc.role === 'Администратор' ? 'admin' : 'user'}`}
                  onClick={() => quickLogin(acc)}
                  disabled={loading}
                  title={`${acc.email} / ${acc.password}`}
                >
                  <span className="quick-login-icon">{acc.icon}</span>
                  <span className="quick-login-text">
                    <b>{acc.role}</b>
                    <small>{acc.email}</small>
                  </span>
                </button>
              ))}
            </div>
          </div>
        )}

        <div className="test-login">
          {mode === 'login' && (
            <>
              <p>Нет аккаунта?</p>
              <button type="button" onClick={() => switchMode('register')}>Регистрация</button>
              <p style={{ marginTop: 10 }}>Забыли пароль?</p>
              <button type="button" onClick={() => switchMode('forgot')}>Восстановить</button>
            </>
          )}
          {mode === 'register' && (
            <>
              <p>Уже есть аккаунт?</p>
              <button type="button" onClick={() => switchMode('login')}>Авторизация</button>
            </>
          )}
          {(mode === 'forgot' || mode === 'reset') && (
            <button type="button" onClick={() => switchMode('login')}>Назад к входу</button>
          )}
        </div>
      </form>
    </div>
  )
}