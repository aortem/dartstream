import { useState } from 'react'
import './App.css'

const API_URL = 'http://127.0.0.1:8081'

function App() {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(false)
  const [message, setMessage] = useState('')
  const [isError, setIsError] = useState(false)

  // Form states
  const [loginEmail, setLoginEmail] = useState('')
  const [loginPassword, setLoginPassword] = useState('')
  const [registerEmail, setRegisterEmail] = useState('')
  const [registerPassword, setRegisterPassword] = useState('')

  const showMessage = (msg, error = false) => {
    setMessage(msg)
    setIsError(error)
    setTimeout(() => setMessage(''), 5000)
  }

  const handleLogin = async (e) => {
    e.preventDefault()
    setLoading(true)
    try {
      const res = await fetch(`${API_URL}/login`, {
        method: 'POST',
        body: JSON.stringify({
          username: loginEmail,
          password: loginPassword
        })
      })
      const data = await res.json()

      if (data.success) {
        setUser(data.user)
        showMessage('Login successful!')
        setLoginEmail('')
        setLoginPassword('')
      } else {
        showMessage(data.error || 'Login failed', true)
      }
    } catch (err) {
      showMessage('Connection error: Is backend running?', true)
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  const handleRegister = async (e) => {
    e.preventDefault()
    setLoading(true)
    try {
      const res = await fetch(`${API_URL}/register`, {
        method: 'POST',
        body: JSON.stringify({
          email: registerEmail,
          password: registerPassword
        })
      })
      const data = await res.json()

      if (data.success) {
        showMessage('Registration successful! Please login.')
        setRegisterEmail('')
        setRegisterPassword('')
      } else {
        showMessage(data.error || 'Registration failed', true)
      }
    } catch (err) {
      showMessage('Connection error: Is backend running?', true)
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  const handleLogout = async () => {
    setLoading(true)
    try {
      await fetch(`${API_URL}/logout`, { method: 'POST' })
      setUser(null)
      showMessage('Logged out successfully')
    } catch (err) {
      showMessage('Logout failed', true)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="container">
      <h1>DartStream Cognito Sample (React)</h1>

      {!user ? (
        <div className="auth-forms">
          <div className="card">
            <h2>Login</h2>
            <form onSubmit={handleLogin}>
              <input
                type="email"
                placeholder="Email"
                value={loginEmail}
                onChange={(e) => setLoginEmail(e.target.value)}
                required
              />
              <input
                type="password"
                placeholder="Password"
                value={loginPassword}
                onChange={(e) => setLoginPassword(e.target.value)}
                required
              />
              <button type="submit" disabled={loading}>
                {loading ? 'Processing...' : 'Sign In'}
              </button>
            </form>
          </div>

          <div className="card">
            <h2>Register</h2>
            <form onSubmit={handleRegister}>
              <input
                type="email"
                placeholder="Email"
                value={registerEmail}
                onChange={(e) => setRegisterEmail(e.target.value)}
                required
              />
              <input
                type="password"
                placeholder="Password"
                value={registerPassword}
                onChange={(e) => setRegisterPassword(e.target.value)}
                required
              />
              <button type="submit" disabled={loading}>
                {loading ? 'Processing...' : 'Create Account'}
              </button>
            </form>
          </div>
        </div>
      ) : (
        <div className="dashboard">
          <div className="card success-card">
            <h2>Welcome, {user.displayName || user.email}!</h2>
            <p><strong>User ID:</strong> {user.id}</p>
            <p><strong>Email:</strong> {user.email}</p>
            <button onClick={handleLogout} className="danger">Sign Out</button>
          </div>
        </div>
      )}

      {message && (
        <div className={`message ${isError ? 'error' : 'success'}`}>
          {message}
        </div>
      )}
    </div>
  )
}

export default App
