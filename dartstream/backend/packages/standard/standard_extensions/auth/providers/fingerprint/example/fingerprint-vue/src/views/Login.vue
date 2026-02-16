<template>
  <div class="app-container">
    <div class="auth-box">
      <h1>Fingerprint Auth Test</h1>

      <form @submit.prevent="handleLogin">
        <input type="email" v-model="email" placeholder="Email" required />
        <input type="password" v-model="password" placeholder="Password" required />
        <button type="submit">Login</button>
      </form>

      <form @submit.prevent="handleSignup">
        <input type="email" v-model="email" placeholder="Email" required />
        <input type="password" v-model="password" placeholder="Password" required />
        <button type="submit" class="signup-btn">Signup</button>
      </form>

      <p class="message" v-if="message">{{ message }}</p>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'

export default {
  setup() {
    const router = useRouter()
    const email = ref('')
    const password = ref('')
    const message = ref('')

    const handleLogin = async () => {
      try {
        const res = await axios.post('http://localhost:8080/signin', { email: email.value, password: password.value })
        if (res.data.status === 'success') {
          localStorage.setItem('userEmail', email.value) // save email for dashboard
          router.push('/dashboard')
        }
      } catch (err) {
        message.value = 'Login failed'
      }
    }

    const handleSignup = async () => {
      try {
        const res = await axios.post('http://localhost:8080/signup', { email: email.value, password: password.value })
        if (res.data.status === 'success') {
          message.value = 'Account created, you can login now'
        }
      } catch (err) {
        message.value = 'Signup failed'
      }
    }

    return { email, password, handleLogin, handleSignup, message }
  }
}
</script>

<style scoped>
.app-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #6b73ff 0%, #000dff 100%);
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.auth-box {
  background: #ffffff;
  padding: 40px 30px;
  border-radius: 15px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
  width: 350px;
  text-align: center;
}

h1 {
  margin-bottom: 25px;
  color: #333;
}

input {
  display: block;
  width: 90%;
  padding: 12px;
  margin: 10px auto;
  border-radius: 8px;
  border: 1px solid #ccc;
  font-size: 16px;
}

button {
  width: 95%;
  padding: 12px;
  margin-top: 15px;
  border: none;
  border-radius: 8px;
  background: #6b73ff;
  color: white;
  font-size: 16px;
  cursor: pointer;
  transition: background 0.3s ease;
}

button:hover {
  background: #000dff;
}

.signup-btn {
  background: #ff6b6b;
}

.signup-btn:hover {
  background: #ff0000;
}

.message {
  margin-top: 15px;
  color: #ff0000;
  font-weight: 500;
}
</style>
