const API_BASE_URL = 'http://localhost:8080';

export const api = {
    async register(email, password, displayName) {
        const response = await fetch(`${API_BASE_URL}/api/auth/register`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ email, password, displayName }),
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error || 'Registration failed');
        }

        return data;
    },

    async login(email, password) {
        const response = await fetch(`${API_BASE_URL}/api/auth/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ email, password }),
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error || 'Login failed');
        }

        return data;
    },

    async logout() {
        const response = await fetch(`${API_BASE_URL}/api/auth/logout`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error || 'Logout failed');
        }

        return data;
    },

    async getCurrentUser() {
        const response = await fetch(`${API_BASE_URL}/api/auth/user`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            },
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error || 'Failed to get user');
        }

        return data;
    },

    async verifyToken(token) {
        const response = await fetch(`${API_BASE_URL}/api/auth/verify`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`,
            },
        });

        const data = await response.json();

        return data.valid;
    },
};
