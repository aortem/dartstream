import { useState, useEffect } from 'react'
import { Magic } from 'magic-sdk'
import './App.css'

// Initialize Magic SDK
const magic = new Magic(import.meta.env.VITE_MAGIC_PUBLISHABLE_KEY || 'pk_live_1F15F3020DF38574');

function App() {
  const [email, setEmail] = useState('')
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(false)
  const [token, setToken] = useState(null)
  const [error, setError] = useState(null)

  const handleLogin = async (e) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    try {
      // 1. Authenticate with Magic
      const didToken = await magic.auth.loginWithMagicLink({ email })
      setToken(didToken)

      // 2. Validate with Backend
      const res = await fetch('http://localhost:8080/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${didToken}`
        },
        body: JSON.stringify({ didToken })
      })

      if (!res.ok) {
        const errText = await res.text()
        throw new Error(`Backend validation failed: ${errText || res.statusText}`)
      }

      const data = await res.json()
      setUser(data.user)
    } catch (err) {
      console.error(err)
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  const handleLogout = async () => {
    try {
      await magic.user.logout()
      setUser(null)
      setToken(null)
    } catch (err) {
      console.error(err)
    }
  }

  return (
    <div className="container">
      <h1>Magic Auth Demo</h1>

      {!user ? (
        <div className="login-form">
          <p>Sign in via Magic Link</p>
          <form onSubmit={handleLogin}>
            <input
              type="email"
              placeholder="Enter your email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              disabled={loading}
            />
            <button type="submit" disabled={loading}>
              {loading ? 'Sending Magic Link...' : 'Log In'}
            </button>
          </form>
          {error && <p className="error">{error}</p>}
        </div>
      ) : (
        <div className="user-profile">
          <h2>Welcome!</h2>
          <p><strong>Email:</strong> {user.email}</p>
          <p><strong>Issuer (DID):</strong> {user.issuer}</p>
          <p><strong>Public Address:</strong> {user.publicAddress}</p>
          <button onClick={handleLogout}>Log Out</button>
        </div>
      )}

      {token && <p className="token-preview">Token: {token.substring(0, 20)}...</p>}
    </div>
  )
}

export default App
