import { createRouter, createWebHistory } from 'vue-router';
import LoginPage from '../views/Login.vue';
import DashboardPage from '../views/Dashboard.vue';

const routes = [
  { path: '/', name: 'Login', component: LoginPage },
  { path: '/dashboard', name: 'Dashboard', component: DashboardPage },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
