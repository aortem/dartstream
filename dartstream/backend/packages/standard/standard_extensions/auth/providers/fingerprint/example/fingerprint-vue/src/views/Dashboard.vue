<template>
  <div class="dashboard-container">
    <div class="dashboard-box">
      <h1>Welcome, {{ userEmail }}</h1>
      <p>You are logged in with Fingerprint Auth.</p>
      <button @click="logout">Logout</button>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

export default {
  setup() {
    const router = useRouter()
    const userEmail = ref('')

    onMounted(() => {
      const email = localStorage.getItem('userEmail')
      if (!email) {
        router.push('/')
      } else {
        userEmail.value = email
      }
    })

    const logout = async () => {
      try {
        await axios.post('http://localhost:8080/signout')
        localStorage.removeItem('userEmail')
        router.push('/')
      } catch (err) {
        console.error(err)
      }
    }

    return { userEmail, logout }
  }
}
</script>

<style scoped>
.dashboard-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #f9d423 0%, #ff4e50 100%);
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.dashboard-box {
  background: #fff;
  padding: 50px 40px;
  border-radius: 20px;
  box-shadow: 0 10px 30px rgba(0,0,0,0.3);
  text-align: center;
  max-width: 400px;
}

h1 {
  color: #333;
  margin-bottom: 15px;
}

p {
  margin-bottom: 30px;
  color: #555;
}

button {
  padding: 12px 25px;
  border: none;
  border-radius: 10px;
  background: #6b73ff;
  color: white;
  font-size: 16px;
  cursor: pointer;
  transition: background 0.3s ease;
}

button:hover {
  background: #000dff;
}
</style>
