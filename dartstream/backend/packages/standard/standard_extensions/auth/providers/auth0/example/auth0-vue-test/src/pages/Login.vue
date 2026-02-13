<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { login } from '../api'

const email = ref('')
const password = ref('')
const error = ref('')
const router = useRouter()

async function submit() {
  error.value = ''
  try {
    await login(email.value, password.value)
    router.push('/dashboard')
  } catch (e) {
    error.value = e.message
  }
}
</script>

<template>
  <h2>Login</h2>

  <input v-model="email" placeholder="Email" />
  <input v-model="password" type="password" placeholder="Password" />

  <button @click="submit">Login</button>

  <p style="color:red" v-if="error">{{ error }}</p>

  <p>
    No account?
    <router-link to="/register">Register</router-link>
  </p>
</template>

<style scoped>
h2 {
  text-align: center;
  color: #fff;
  margin-bottom: 1rem;
}

input {
  width: 100%;
  padding: 12px;
  margin-bottom: 12px;
  border-radius: 8px;
  border: none;
  outline: none;
  font-size: 14px;
}

button {
  width: 100%;
  padding: 12px;
  background: #00c6ff;
  background: linear-gradient(to right, #0072ff, #00c6ff);
  border: none;
  border-radius: 8px;
  color: white;
  font-weight: bold;
  cursor: pointer;
}

button:hover {
  opacity: 0.9;
}

p {
  text-align: center;
  color: #ddd;
}

a {
  color: #00c6ff;
  text-decoration: none;
}

:deep(*) {
  max-width: 360px;
}
</style>
