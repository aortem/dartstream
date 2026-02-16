<template>
  <button 
    @click="handleLogin" 
    class="button login"
    :disabled="isLoading"
  >
    {{ isLoading ? 'Loading...' : 'Log In' }}
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useAuth0 } from '@auth0/auth0-vue'

const isLoading = ref(false)
const { loginWithRedirect } = useAuth0()

const handleLogin = async () => {
    isLoading.value = true
  try {
    // Open a prompt for email/password or use your existing modal if needed
    const email = prompt('Enter your email')
    const password = prompt('Enter your password')

    if (!email || !password) {
      alert('Email and password required')
      return
    }

    const res = await fetch('http://localhost:8080/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    })

    const data = await res.json()

    if (!res.ok) {
      throw new Error(data.error ?? 'Login failed')
    }

    alert(`Welcome ${data.name}!`)
    // store user data globally if needed
    localStorage.setItem('user', JSON.stringify(data))
    window.location.reload() // reload to show UserProfile
  } catch (err: any) {
    console.error('Login error:', err.message)
    alert('Login failed: ' + err.message)
  } finally {
    isLoading.value = false
  }
  loginWithRedirect()
}
</script>