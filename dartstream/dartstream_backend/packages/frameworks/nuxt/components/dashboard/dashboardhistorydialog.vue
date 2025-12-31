<template>
  <div
    v-if="visible"
    class="fixed bottom-6 right-6 z-50 max-w-xs w-[300px] bg-white shadow-xl rounded-lg p-4 relative"
  >
    <!-- Arrow -->
    <div class="absolute -top-2 right-10 w-4 h-4 bg-white rotate-45 shadow -z-10"></div>

    <h3 class="text-lg  text-[#042F2C]">Welcome to the tour!</h3>
    <p class="text-sm text-gray-600 mt-2">Here’s a quick guide to help you get started.</p>

    <button @click="emit('close')" class="mt-4 text-sm text-blue-600 hover:underline">
      Got it
    </button>
  </div>
</template>

<script setup>
defineProps({ visible: Boolean })
const emit = defineEmits(['close'])
</script>
