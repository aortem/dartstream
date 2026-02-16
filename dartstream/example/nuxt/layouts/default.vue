<template>
  
    
    <main>
      <slot />
    </main>
  
</template>

<script setup lang="ts">
import { onMounted } from 'vue';
import { useAuth } from '~/composables/useAuth'

const { fetchSession } = useAuth()

onMounted(fetchSession)
</script>