<template>
  <div class="p-6">
    <!-- Card Matching User's Provided Design -->
    <div class="max-w-md p-4 border rounded-lg shadow-sm bg-white mb-6">
      <h1 class="text-lg mb-4">OpenFeature Provider Intellitoggle</h1>
      <div class="flex items-center mb-1 text-sm text-[#525866]">
        <span>🔐 Environment: Development</span>
      </div>
      <div class="flex items-center justify-between mb-2 text-sm text-[#525866]">
        <span>🗝️ API Key: env_xxxxx</span>
        <button class="inline-flex items-center gap-2 bg-white text-[#42489E] text-xs px-3 py-1.5 border rounded-md hover:bg-gray-100">
          <img src="/assets/images/copy.png" alt="Copy Key" class="w-4 h-4" />
          Copy Key
        </button>
      </div>
      <div class="text-sm text-[#525866] mb-4">
        <span>⚙️ Offline: Disabled</span>
        <span class="mx-2">|</span>
        <span>TTL: 60s</span>
      </div>
      <div class="flex gap-2">
        <button @click="isModalOpen = true" class="px-4 py-2 text-sm rounded-md bg-[#E2E2E2] w-1/2">Edit config</button>
        <button class="px-4 py-2 text-sm rounded-md bg-[#42489E] text-white w-1/2">Test config</button>
      </div>
    </div>

    <div v-if="selectedConfig" class="relative bg-white p-3 flex justify-between rounded-[12px] mt-4">
      <pre class="w-full whitespace-pre-wrap bg-transparent text-sm font-mono resize-none outline-none">
{{ generatedCode }}
      </pre>
      <button @click="copyCode">
        <img src="/assets/images/copy.png" alt="Copy" class="w-4 h-4" />
      </button>
      <span v-if="copied" class="text-green-500 text-sm absolute top-2 right-14">Copied!</span>
    </div>

    <div v-if="isModalOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
      <div class="bg-white p-2 rounded-[12px] max-w-xl w-full">
        <h1 class="text-[28px] text-center">SDKs Integration</h1>
        <p class="mb-4 text-[#525866] text-center">
          Welcome! To get started, choose your SDK and environment
        </p>
        <div class="p-3 border rounded-[12px] shadow-sm m-4">
          <p class="">Install & Usage</p>
          <div class="border rounded-[12px] shadow-sm mt-3">
            <div class="p-3 bg-[#F5F7FA] text-[#525866]">dart</div>
            <div class="relative bg-white p-3 rounded-[12px]">
              <pre class="w-full whitespace-pre-wrap bg-transparent text-sm font-mono resize-none outline-none">
{{ generatedCode }}
              </pre>
              <button @click="copyCode" class="absolute top-3 right-3">
                <img src="/assets/images/copy.png" alt="Copy" class="w-4 h-4" />
              </button>
              <span v-if="copied" class="text-green-500 text-sm absolute top-3 right-12">Copied!</span>
            </div>
        </div>
        </div>
        <div class="flex justify-end gap-2 ms-3 me-3">
          <button @click="closeModal" class="px-4 py-2 w-full bg-[#E2E2E2] rounded-[8px]">
            Cancel
          </button>
          <button @click="goToNextModal" class="px-4 py-2 bg-[#42489E] w-full text-white rounded-[8px]">
            Next
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const isModalOpen = ref(false)
const copied = ref(false)

const form = ref({
  apiKey: '',
  userId: '',
  email: '',
})

const selectedConfig = ref<typeof form.value | null>(null)

const saveConfig = () => {
  if (!form.value.apiKey || !form.value.userId || !form.value.email) {
    alert('All fields are required')
    return
  }
  selectedConfig.value = { ...form.value }
  isModalOpen.value = false
}

const closeModal = () => {
  isModalOpen.value = false
}

// const goToNextModal = () => {
//   alert('Proceeding to next step...')
// }

const generatedCode = computed(() => {
  
 
  return `With Dart:
  dart pub add openfeature_provider_intellitoggle
  With Flutter:
  flutter pub add openfeature_provider_intellitoggle
  dependencies:
  openfeature_provider_intellitoggle: ^0.0.4  
  Import:
  Now in your Dart code, you can use:
  import 'package:openfeature_provider_intellitoggle
  /openfeature_provider_intellitoggle.dart';
});`
})

const copyCode = async () => {
  try {
    await navigator.clipboard.writeText(generatedCode.value)
    copied.value = true
    setTimeout(() => copied.value = false, 2000)
  } catch (err) {
    console.error('Copy failed:', err)
    alert('Failed to copy. Try again.')
  }
}
</script>

<style scoped>
textarea::-webkit-scrollbar {
  display: none;
}
</style>
