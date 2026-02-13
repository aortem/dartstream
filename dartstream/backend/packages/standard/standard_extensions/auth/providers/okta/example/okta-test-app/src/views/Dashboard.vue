<template>
  <div class="card dashboard">
    <h2>Dashboard</h2>

    <p><strong>Email:</strong> {{ user?.email }}</p>

    <button class="primary" @click="logout">Logout</button>
  </div>
</template>


<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { api } from '../services/api'

const user = ref(null)
const router = useRouter()

onMounted(async () => {
  const res = await api.get('/me')
  user.value = res.data
})

async function logout() {
  await api.post('/logout')
  router.push('/')
}
</script>
