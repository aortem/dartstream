<template>
  <div class="dashboard-container">
    <h2>Dashboard</h2>
    <p>Welcome! You are logged in.</p>
    <button @click="logout">Logout</button>
  </div>
</template>

<script>
import axios from 'axios';
import { useRouter } from 'vue-router';

export default {
  setup() {
    const router = useRouter();

    const logout = async () => {
      try {
        await axios.post('http://localhost:8080/signout');
        router.push('/');
      } catch (err) {
        console.error(err);
      }
    };

    return { logout };
  },
};
</script>

<style scoped>
.dashboard-container {
  max-width: 400px;
  margin: 100px auto;
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  text-align: center;
}
button {
  padding: 0.7rem 1.2rem;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  background-color: #0284c7;
  color: white;
  font-weight: bold;
}
button:hover {
  background-color: #0369a1;
}
</style>
