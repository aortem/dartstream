<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { register } from '../api'

const email = ref('')
const password = ref('')
const name = ref('')
const error = ref('')
const router = useRouter()

async function submit() {
  error.value = ''
  try {
    await register(email.value, password.value, name.value)
    router.push('/login')
  } catch (e) {
    error.value = e.message
  }
}
</script>

<template>
  <h2>Register</h2>

  <input v-model="name" placeholder="Name" />
  <input v-model="email" placeholder="Email" />
  <input v-model="password" type="password" placeholder="Password" />

  <button @click="submit">Register</button>

  <p style="color:red" v-if="error">{{ error }}</p>

  <p>
    Already have an account?
    <router-link to="/login">Login</router-link>
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
  background: linear-gradient(to right, #11998e, #38ef7d);
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
  color: #38ef7d;
  text-decoration: none;
}

:deep(*) {
  max-width: 360px;
}
</style>

