<script setup lang="ts">
import SdkCard from "~/components/sdk-components/sdk-card.vue";
const isModalOpen = ref(false);
definePageMeta({
  layout: "dashboard",
});
</script>

<template>
  <div class="relative mt-4">
    <div class="min-h-screen p-6">
      <div class="flex items-center justify-between mb-6">
        <div>
          <div class="flex gap-3">
            <img src="/assets/images/enable.png" alt="" class="w-6 h-8" />
            <h1 class="text-2xl mt-1">SDKs</h1>
          </div>

          <p class="text-sm text-gray-500">
            Feature module for running, managing, and analyzing controlled
            sdk’s.
          </p>
        </div>
        <div class="">
          <button
            @click="isModalOpen = true"
            class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2 dashboard-create-button"
          >
            Connect to another SDK
          </button>
        </div>
      </div>
      <div class="">
        <SdkCard />
      </div>
    </div>
  </div>
</template>
