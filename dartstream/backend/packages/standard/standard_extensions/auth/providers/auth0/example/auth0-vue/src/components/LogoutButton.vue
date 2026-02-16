<template>
  <button
    @click="handleLogout"
    class="button logout"
    :disabled="isLoading"
  >
    {{ isLoading ? 'Loading...' : 'Log Out' }}
  </button>
</template>

<script setup lang="ts">
import { useAuth0 } from '@auth0/auth0-vue'

const { logout, isLoading } = useAuth0()

const handleLogout = () => {
  logout({
    logoutParams: {
      returnTo: window.location.origin
    }
  })
}
</script>