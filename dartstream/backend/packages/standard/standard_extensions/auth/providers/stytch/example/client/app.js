// API Configuration
const API_BASE_URL = "http://localhost:8082";

// Session Management
const SESSION_KEY = "stytch_session_id";

// Get session ID from localStorage
function getSessionId() {
  return localStorage.getItem(SESSION_KEY);
}

// Set session ID in localStorage
function setSessionId(sessionId) {
  localStorage.setItem(SESSION_KEY, sessionId);
}

// Clear session
function clearSession() {
  localStorage.removeItem(SESSION_KEY);
}

// API Client
async function apiRequest(endpoint, options = {}) {
  const sessionId = getSessionId();
  const headers = {
    "Content-Type": "application/json",
    ...options.headers,
  };

  if (sessionId) {
    headers["Authorization"] = `Bearer ${sessionId}`;
  }

  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      ...options,
      headers,
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.error || "Request failed");
    }

    return data;
  } catch (error) {
    console.error("API Error:", error);
    throw error;
  }
}

// Show Alert
function showAlert(message, type = "success") {
  const container = document.getElementById("alertContainer");
  const alert = document.createElement("div");
  alert.className = `alert alert-${type}`;

  const icon = type === "success" ? "✅" : "❌";
  const title = type === "success" ? "Success" : "Error";

  alert.innerHTML = `
        <div class="alert-icon">${icon}</div>
        <div class="alert-content">
            <div class="alert-title">${title}</div>
            <div class="alert-message">${message}</div>
        </div>
    `;

  container.appendChild(alert);

  setTimeout(() => {
    alert.style.animation = "slideInRight 0.3s ease-out reverse";
    setTimeout(() => alert.remove(), 300);
  }, 4000);
}

// View Management
function showView(viewId) {
  document.querySelectorAll(".view").forEach((view) => {
    view.classList.remove("active");
  });
  document.getElementById(viewId).classList.add("active");
}

function showLogin() {
  showView("loginView");
}

function showRegister() {
  showView("registerView");
}

function showDashboard(user) {
  document.getElementById("userName").textContent = user.displayName || "User";
  document.getElementById("userEmail").textContent = user.email;
  document.getElementById("userId").textContent = user.id;
  showView("dashboardView");
}

// Form Handlers
async function handleRegister(event) {
  event.preventDefault();

  const form = event.target;
  const button = form.querySelector('button[type="submit"]');
  const displayName = document.getElementById("registerName").value;
  const email = document.getElementById("registerEmail").value;
  const password = document.getElementById("registerPassword").value;

  button.classList.add("loading");

  try {
    await apiRequest("/auth/register", {
      method: "POST",
      body: JSON.stringify({ email, password, displayName }),
    });

    showAlert("Account created successfully! Please sign in.");
    form.reset();
    showLogin();
  } catch (error) {
    showAlert(error.message, "error");
  } finally {
    button.classList.remove("loading");
  }
}

async function handleLogin(event) {
  event.preventDefault();

  const form = event.target;
  const button = form.querySelector('button[type="submit"]');
  const email = document.getElementById("loginEmail").value;
  const password = document.getElementById("loginPassword").value;

  button.classList.add("loading");

  try {
    const data = await apiRequest("/auth/login", {
      method: "POST",
      body: JSON.stringify({ email, password }),
    });

    setSessionId(data.sessionId);
    showAlert("Login successful!");
    form.reset();
    showDashboard(data.user);
  } catch (error) {
    showAlert(error.message, "error");
  } finally {
    button.classList.remove("loading");
  }
}

async function logout() {
  try {
    await apiRequest("/auth/logout", {
      method: "POST",
    });

    clearSession();
    showAlert("Logged out successfully");
    showLogin();
  } catch (error) {
    console.error("Logout error:", error);
    clearSession();
    showLogin();
  }
}

// Check Session on Load
async function checkSession() {
  const sessionId = getSessionId();

  if (!sessionId) {
    showLogin();
    return;
  }

  try {
    const data = await apiRequest("/auth/session");
    showDashboard(data.user);
  } catch (error) {
    clearSession();
    showLogin();
  }
}

// Initialize
document.addEventListener("DOMContentLoaded", () => {
  // Attach form handlers
  document
    .getElementById("registerForm")
    .addEventListener("submit", handleRegister);
  document.getElementById("loginForm").addEventListener("submit", handleLogin);

  // Check existing session
  checkSession();
});
