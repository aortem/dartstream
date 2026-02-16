<template>
  <div class="app-container">
    <div v-if="isLoading" class="loading-state">
      <div class="loading-text">Loading...</div>
    </div>
    
    <div v-else-if="error" class="error-state">
      <div class="error-title">Oops!</div>
      <div class="error-message">Something went wrong</div>
      <div class="error-sub-message">{{ error.message }}</div>
    </div>
    
    <div v-else class="main-card-wrapper">
      <img 
        src="../src/assets//Dartstream-logo.svg" 
        alt="Auth0 Logo" 
        class="auth0-logo"
        @error="handleImageError"
      />
      <h1 class="main-title">Dartstream Auth0 Auth Provider</h1>
      
      <div v-if="isAuthenticated" class="logged-in-section">
        <div class="logged-in-message">✅ Successfully authenticated!</div>
        <h2 class="profile-section-title">Your Profile</h2>
        <div class="profile-card">
          <UserProfile />
        </div>
        <LogoutButton />
      </div>
      
      <div v-else class="action-card">
        <p class="action-text">Get started by signing in to your account</p>
        <LoginButton />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useAuth0 } from '@auth0/auth0-vue'
import LoginButton from './components/LoginButton.vue'
import LogoutButton from './components/LogoutButton.vue'
import UserProfile from './components/UserProfile.vue'

const { isAuthenticated, isLoading, error } = useAuth0()

const handleImageError = (e: Event) => {
  const target = e.target as HTMLImageElement
  target.style.display = 'none'
}
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Inter', sans-serif;
  background-color: #1a1e27;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  color: #e2e8f0;
}

#app {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.app-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  width: 100%;
  padding: 1rem;
}

.loading-state, .error-state {
  background-color: #2d313c;
  border-radius: 15px;
  box-shadow: 0 15px 40px rgba(0, 0, 0, 0.4);
  padding: 3rem;
  text-align: center;
}

.loading-text {
  font-size: 1.8rem;
  font-weight: 500;
  color: #a0aec0;
  animation: pulse 1.5s infinite ease-in-out;
}

.error-state {
  background-color: #c53030;
  color: #fff;
}

.error-title {
  font-size: 2.8rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.error-message {
  font-size: 1.3rem;
  margin-bottom: 0.5rem;
}

.error-sub-message {
  font-size: 1rem;
  opacity: 0.8;
}

.main-card-wrapper {
  background-color: #262a33;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.6), 0 0 0 1px rgba(255, 255, 255, 0.05);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2rem;
  padding: 3rem;
  max-width: 500px;
  width: 90%;
  animation: fadeInScale 0.8s ease-out forwards;
}

.auth0-logo {
  width: 160px;
  margin-bottom: 1.5rem;
  opacity: 0;
  animation: slideInDown 1s ease-out forwards 0.2s;
}

.main-title {
  font-size: 2.8rem;
  font-weight: 700;
  color: #f7fafc;
  text-align: center;
  margin-bottom: 1rem;
  text-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
  opacity: 0;
  animation: fadeIn 1s ease-out forwards 0.4s;
}

.action-card {
  background-color: #2d313c;
  border-radius: 15px;
  box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.3), 0 5px 15px rgba(0, 0, 0, 0.3);
  padding: 2.5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1.8rem;
  width: calc(100% - 2rem);
  opacity: 0;
  animation: fadeIn 1s ease-out forwards 0.6s;
}

.action-text {
  font-size: 1.25rem;
  color: #cbd5e0;
  text-align: center;
  line-height: 1.6;
  font-weight: 400;
}

.button {
  padding: 1.1rem 2.8rem;
  font-size: 1.2rem;
  font-weight: 600;
  border-radius: 10px;
  border: none;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  outline: none;
}

.button:focus {
  box-shadow: 0 0 0 4px rgba(99, 179, 237, 0.5);
}

.button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

.button.login {
  background-color: #63b3ed;
  color: #1a1e27;
}

.button.login:hover:not(:disabled) {
  background-color: #4299e1;
  transform: translateY(-5px) scale(1.03);
  box-shadow: 0 12px 25px rgba(0, 0, 0, 0.5);
}

.button.logout {
  background-color: #fc8181;
  color: #1a1e27;
}

.button.logout:hover:not(:disabled) {
  background-color: #e53e3e;
  transform: translateY(-5px) scale(1.03);
  box-shadow: 0 12px 25px rgba(0, 0, 0, 0.5);
}

.logged-in-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1.5rem;
  width: 100%;
}

.logged-in-message {
  font-size: 1.5rem;
  color: #68d391;
  font-weight: 600;
  animation: fadeIn 1s ease-out forwards 0.8s;
}

.profile-section-title {
  font-size: 2.2rem;
  animation: slideInUp 1s ease-out forwards 1s;
}

.profile-card {
  padding: 2.2rem;
  animation: scaleIn 0.8s ease-out forwards 1.2s;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes fadeInScale {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

@keyframes slideInDown {
  from { opacity: 0; transform: translateY(-70px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes slideInUp {
  from { opacity: 0; transform: translateY(50px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.6; }
}

@keyframes scaleIn {
  from { opacity: 0; transform: scale(0.8); }
  to { opacity: 1; transform: scale(1); }
}

@media (max-width: 600px) {
  .main-card-wrapper {
    padding: 2rem;
    margin: 1rem;
  }
  
  .main-title {
    font-size: 2.2rem;
  }
  
  .button {
    padding: 1rem 2rem;
    font-size: 1.1rem;
  }
  
  .auth0-logo {
    width: 120px;
  }
}
</style>