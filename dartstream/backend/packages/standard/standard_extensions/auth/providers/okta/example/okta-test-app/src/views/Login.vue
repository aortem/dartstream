<template>
  <div class="card">
    <h2>Okta Test Login</h2>

    <input v-model="email" placeholder="Email" />
    <input v-model="password" type="password" placeholder="Password" />

    <div class="actions">
      <button class="primary" @click="login">Login</button>
    
    </div>

    <p v-if="error" class="error">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { api } from '../services/api'

const email = ref('')
const password = ref('')
const error = ref('')
const router = useRouter()

async function login() {
  try {
    await api.post('/login', {
      email: email.value,
      password: password.value,
    })
    router.push('/dashboard')
  } catch (e) {
    error.value = 'Login failed'
  }
}

async function signup() {
  try {
    await api.post('/signup', {
      email: email.value,
      password: password.value,
    })
    await login()
  } catch (e) {
    error.value = 'Signup failed'
  }
}
</script>
