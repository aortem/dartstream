import { useState } from 'react';
import { api } from './api';
import './index.css';

function App() {
    const [isRegistering, setIsRegistering] = useState(false);
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');

    const handleRegister = async (e) => {
        e.preventDefault();
        setError('');
        setSuccess('');
        setLoading(true);

        const formData = new FormData(e.target);
        const email = formData.get('email');
        const password = formData.get('password');
        const displayName = formData.get('displayName');

        try {
            await api.register(email, password, displayName);
            setSuccess('Account created successfully! You can now log in.');
            setIsRegistering(false);
            e.target.reset();
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };

    const handleLogin = async (e) => {
        e.preventDefault();
        setError('');
        setSuccess('');
        setLoading(true);

        const formData = new FormData(e.target);
        const email = formData.get('email');
        const password = formData.get('password');

        try {
            const response = await api.login(email, password);
            setUser(response.user);
            setSuccess('Login successful!');
            e.target.reset();
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };

    const handleLogout = async () => {
        setLoading(true);
        setError('');

        try {
            await api.logout();
            setUser(null);
            setSuccess('Logged out successfully!');
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };

    if (user) {
        return (
            <div className="app">
                <div className="container">
                    <div className="card">
                        <div className="header">
                            <h1>Welcome Back! 👋</h1>
                            <p className="subtitle">EntraID Authentication Demo</p>
                        </div>

                        {success && <div className="alert alert-success">{success}</div>}
                        {error && <div className="alert alert-error">{error}</div>}

                        <div className="profile">
                            <div className="profile-header">
                                <div className="avatar">
                                    {user.displayName?.charAt(0).toUpperCase() || user.email.charAt(0).toUpperCase()}
                                </div>
                                <div className="profile-info">
                                    <h2>{user.displayName || 'User'}</h2>
                                    <p className="email">{user.email}</p>
                                </div>
                            </div>

                            <div className="user-details">
                                <div className="detail-item">
                                    <span className="label">User ID:</span>
                                    <span className="value">{user.id}</span>
                                </div>
                                <div className="detail-item">
                                    <span className="label">Provider:</span>
                                    <span className="value">EntraID</span>
                                </div>
                                {user.customAttributes && (
                                    <>
                                        <div className="detail-item">
                                            <span className="label">Tenant ID:</span>
                                            <span className="value">{user.customAttributes.tenant_id}</span>
                                        </div>
                                        <div className="detail-item">
                                            <span className="label">Created:</span>
                                            <span className="value">
                                                {new Date(user.customAttributes.created_at).toLocaleString()}
                                            </span>
                                        </div>
                                    </>
                                )}
                            </div>

                            <button
                                onClick={handleLogout}
                                className="btn btn-secondary"
                                disabled={loading}
                            >
                                {loading ? 'Logging out...' : 'Logout'}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div className="app">
            <div className="container">
                <div className="card">
                    <div className="header">
                        <h1>EntraID Authentication</h1>
                        <p className="subtitle">Secure authentication demo with DartStream</p>
                    </div>

                    {success && <div className="alert alert-success">{success}</div>}
                    {error && <div className="alert alert-error">{error}</div>}

                    <div className="tabs">
                        <button
                            className={`tab ${!isRegistering ? 'active' : ''}`}
                            onClick={() => {
                                setIsRegistering(false);
                                setError('');
                                setSuccess('');
                            }}
                        >
                            Login
                        </button>
                        <button
                            className={`tab ${isRegistering ? 'active' : ''}`}
                            onClick={() => {
                                setIsRegistering(true);
                                setError('');
                                setSuccess('');
                            }}
                        >
                            Register
                        </button>
                    </div>

                    {isRegistering ? (
                        <form onSubmit={handleRegister} className="form">
                            <div className="form-group">
                                <label htmlFor="displayName">Display Name</label>
                                <input
                                    type="text"
                                    id="displayName"
                                    name="displayName"
                                    placeholder="Enter your name"
                                    required
                                />
                            </div>
                            <div className="form-group">
                                <label htmlFor="email">Email</label>
                                <input
                                    type="email"
                                    id="email"
                                    name="email"
                                    placeholder="Enter your email"
                                    required
                                />
                            </div>
                            <div className="form-group">
                                <label htmlFor="password">Password</label>
                                <input
                                    type="password"
                                    id="password"
                                    name="password"
                                    placeholder="Enter your password"
                                    required
                                    minLength="6"
                                />
                            </div>
                            <button type="submit" className="btn btn-primary" disabled={loading}>
                                {loading ? 'Creating account...' : 'Create Account'}
                            </button>
                        </form>
                    ) : (
                        <form onSubmit={handleLogin} className="form">
                            <div className="form-group">
                                <label htmlFor="login-email">Email</label>
                                <input
                                    type="email"
                                    id="login-email"
                                    name="email"
                                    placeholder="Enter your email"
                                    required
                                />
                            </div>
                            <div className="form-group">
                                <label htmlFor="login-password">Password</label>
                                <input
                                    type="password"
                                    id="login-password"
                                    name="password"
                                    placeholder="Enter your password"
                                    required
                                />
                            </div>
                            <button type="submit" className="btn btn-primary" disabled={loading}>
                                {loading ? 'Logging in...' : 'Login'}
                            </button>
                        </form>
                    )}
                </div>
            </div>
        </div>
    );
}

export default App;
