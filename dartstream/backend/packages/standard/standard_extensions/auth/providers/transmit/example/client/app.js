// API Configuration
const API_BASE_URL = 'http://localhost:4000';

// Session management
let sessionId = null;
let currentUser = null;

// DOM Elements
const loginView = document.getElementById('loginView');
const dashboardView = document.getElementById('dashboardView');
const loginForm = document.getElementById('loginForm');
const loginBtn = document.getElementById('loginBtn');
const loginError = document.getElementById('loginError');
const logoutBtn = document.getElementById('logoutBtn');
const refreshBtn = document.getElementById('refreshBtn');
const dashboardError = document.getElementById('dashboardError');
const dashboardSuccess = document.getElementById('dashboardSuccess');

// User info elements
const userEmail = document.getElementById('userEmail');
const userDisplayName = document.getElementById('userDisplayName');
const userId = document.getElementById('userId');

// Utility functions
function showError(element, message) {
    element.textContent = message;
    element.classList.remove('hidden');
    setTimeout(() => element.classList.add('hidden'), 5000);
}

function showSuccess(element, message) {
    element.textContent = message;
    element.classList.remove('hidden');
    setTimeout(() => element.classList.add('hidden'), 3000);
}

function switchView(view) {
    loginView.classList.remove('active');
    dashboardView.classList.remove('active');
    view.classList.add('active');
}

function updateUserInfo(user) {
    currentUser = user;
    userEmail.textContent = user.email;
    userDisplayName.textContent = user.displayName || 'N/A';
    userId.textContent = user.id;
}

// API calls
async function login(email, password) {
    const response = await fetch(`${API_BASE_URL}/auth/login`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
    });

    if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Login failed');
    }

    return response.json();
}

async function logout() {
    const response = await fetch(`${API_BASE_URL}/auth/logout`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${sessionId}`,
        },
    });

    if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Logout failed');
    }

    return response.json();
}

async function refreshToken() {
    // In a real app, you'd store the refresh token securely
    const mockRefreshToken = 'mock_refresh_token';

    const response = await fetch(`${API_BASE_URL}/auth/refresh`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ refreshToken: mockRefreshToken }),
    });

    if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Token refresh failed');
    }

    return response.json();
}

async function checkSession() {
    const response = await fetch(`${API_BASE_URL}/auth/session`, {
        headers: {
            'Authorization': `Bearer ${sessionId}`,
        },
    });

    if (!response.ok) {
        return null;
    }

    return response.json();
}

// Event handlers
loginForm.addEventListener('submit', async (e) => {
    e.preventDefault();

    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    loginBtn.disabled = true;
    loginBtn.textContent = 'Signing in...';
    loginError.classList.add('hidden');

    try {
        const result = await login(email, password);

        if (result.success) {
            sessionId = result.sessionId;
            updateUserInfo(result.user);
            switchView(dashboardView);

            // Clear form
            loginForm.reset();
        }
    } catch (error) {
        showError(loginError, error.message);
    } finally {
        loginBtn.disabled = false;
        loginBtn.textContent = 'Sign In';
    }
});

logoutBtn.addEventListener('click', async () => {
    logoutBtn.disabled = true;
    logoutBtn.textContent = '🔄 Logging out...';
    dashboardError.classList.add('hidden');

    try {
        await logout();
        sessionId = null;
        currentUser = null;
        switchView(loginView);
    } catch (error) {
        showError(dashboardError, error.message);
    } finally {
        logoutBtn.disabled = false;
        logoutBtn.textContent = '🚪 Logout';
    }
});

refreshBtn.addEventListener('click', async () => {
    refreshBtn.disabled = true;
    refreshBtn.textContent = '🔄 Refreshing...';
    dashboardError.classList.add('hidden');
    dashboardSuccess.classList.add('hidden');

    try {
        const result = await refreshToken();

        if (result.success) {
            showSuccess(dashboardSuccess, '✅ Token refreshed successfully!');
            console.log('New access token:', result.accessToken);
        }
    } catch (error) {
        showError(dashboardError, error.message);
    } finally {
        refreshBtn.disabled = false;
        refreshBtn.textContent = '🔄 Refresh Token';
    }
});

// Check for existing session on load
window.addEventListener('load', async () => {
    const storedSessionId = localStorage.getItem('sessionId');

    if (storedSessionId) {
        sessionId = storedSessionId;

        try {
            const result = await checkSession();

            if (result && result.user) {
                updateUserInfo(result.user);
                switchView(dashboardView);
            } else {
                localStorage.removeItem('sessionId');
            }
        } catch (error) {
            localStorage.removeItem('sessionId');
        }
    }
});

// Save session ID to localStorage
window.addEventListener('beforeunload', () => {
    if (sessionId) {
        localStorage.setItem('sessionId', sessionId);
    } else {
        localStorage.removeItem('sessionId');
    }
});
