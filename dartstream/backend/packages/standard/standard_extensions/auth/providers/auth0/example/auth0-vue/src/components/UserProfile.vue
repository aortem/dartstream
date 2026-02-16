<template>
  <div v-if="isLoading" class="loading-text">
    Loading profile...
  </div>
  <div 
    v-else-if="isAuthenticated && user" 
    class="profile-container"
  >
    <img 
      :src="user.picture || placeholderImage" 
      :alt="user.name || 'User'" 
      class="profile-picture"
      @error="handleImageError"
    />
    <div class="profile-info">
      <div class="profile-name">
        {{ user.name }}
      </div>
      <div class="profile-email">
        {{ user.email }}
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useAuth0 } from '@auth0/auth0-vue'

const { user, isAuthenticated, isLoading } = useAuth0()

const placeholderImage = `data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 100 100'%3E%3Ccircle cx='50' cy='50' r='50' fill='%2363b3ed'/%3E%3Cpath d='M50 45c7.5 0 13.64-6.14 13.64-13.64S57.5 17.72 50 17.72s-13.64 6.14-13.64 13.64S42.5 45 50 45zm0 6.82c-9.09 0-27.28 4.56-27.28 13.64v3.41c0 1.88 1.53 3.41 3.41 3.41h47.74c1.88 0 3.41-1.53 3.41-3.41v-3.41c0-9.08-18.19-13.64-27.28-13.64z' fill='%23fff'/%3E%3C/svg%3E`

function handleImageError(e: Event) {
  const target = e.target as HTMLImageElement
  target.src = placeholderImage
}
</script>

<style scoped>
.profile-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.profile-picture {
  width: 110px;
  height: 110px;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid #63b3ed;
  transition: transform 0.3s ease-in-out;
}

.profile-picture:hover {
  transform: scale(1.05);
}

.profile-info {
  text-align: center;
}

.profile-name {
  font-size: 2rem;
  font-weight: 600;
  color: #f7fafc;
  margin-bottom: 0.5rem;
}

.profile-email {
  font-size: 1.15rem;
  color: #a0aec0;
}
</style>