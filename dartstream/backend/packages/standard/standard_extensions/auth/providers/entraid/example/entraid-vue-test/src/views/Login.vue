<template>
  <div class="auth-container">
    <h2>EntraID Test Login / Signup</h2>
    <form @submit.prevent="handleAuth">
      <input v-model="email" type="email" placeholder="Email" required />
      <input v-model="password" type="password" placeholder="Password" required />
      <div class="buttons">
        <button type="submit">{{ isSignup ? 'Signup' : 'Signin' }}</button>
        <button type="button" @click="toggleMode">
          Switch to {{ isSignup ? 'Signin' : 'Signup' }}
        </button>
      </div>
    </form>
    <p class="message">{{ message }}</p>
  </div>
</template>

<script>
import axios from 'axios';
import { useRouter } from 'vue-router';
import { ref } from 'vue'

export default {
  setup() {
    const router = useRouter();
    const email = ref('');
    const password = ref('');
    const isSignup = ref(true);
    const message = ref('');

    const toggleMode = () => {
      isSignup.value = !isSignup.value;
      message.value = '';
    };

    const handleAuth = async () => {
      try {
        const endpoint = isSignup.value ? '/signup' : '/signin';
        const res = await axios.post(`http://localhost:8080${endpoint}`, {
          email: email.value,
          password: password.value,
        });

        message.value = res.data.message;

        if (!isSignup.value && res.data.user) {
          router.push('/dashboard');
        }
      } catch (err) {
        message.value = err.response?.data?.error || err.message;
      }
    };

    return { email, password, isSignup, toggleMode, handleAuth, message };
  },
};
</script>

<style scoped>
.auth-container {
  max-width: 400px;
  margin: 100px auto;
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  text-align: center;
}
input {
  display: block;
  width: 100%;
  padding: 0.8rem;
  margin-bottom: 1rem;
  border-radius: 8px;
  border: 1px solid #ccc;
}
button {
  padding: 0.7rem 1.2rem;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  background-color: #4f46e5;
  color: white;
  font-weight: bold;
  margin-right: 0.5rem;
}
button:hover {
  background-color: #4338ca;
}
.buttons {
  display: flex;
  justify-content: center;
}
.message {
  margin-top: 1rem;
  color: #ef4444;
  font-weight: bold;
}
</style>
