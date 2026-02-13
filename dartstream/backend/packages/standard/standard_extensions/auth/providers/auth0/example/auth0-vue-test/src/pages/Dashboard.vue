<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

function logout() {
  // No server logout endpoint yet
  router.push('/login')
}
</script>

<template>
  <h2>Dashboard</h2>
  <p>You are logged in 🎉</p>

  <button @click="logout">Logout</button>
</template>


<style scoped>
h2 {
  color: #fff;
  margin-bottom: 0.5rem;
}

p {
  color: #cceeff;
  margin-bottom: 1.5rem;
}

button {
  padding: 12px 24px;
  background: linear-gradient(to right, #ff416c, #ff4b2b);
  border: none;
  border-radius: 8px;
  color: white;
  font-weight: bold;
  cursor: pointer;
}

button:hover {
  opacity: 0.9;
}
</style>
