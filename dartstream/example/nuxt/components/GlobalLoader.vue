<template>
  <div
    v-if="isLoading"
    class="fixed inset-0 z-[9999] bg-white bg-opacity-60 flex items-center justify-center"
  >
    <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
  </div>
</template>

<script setup>
const { isLoading } = useLoading()
</script>
