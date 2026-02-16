<script setup lang="ts">
const isModalOpen = ref(false);
import Analyticss from "~/components/analytics/analytics.vue";
import UpgradePrompt from "~/components/analytics/UpgradePrompt.vue";
definePageMeta({
  layout: "dashboard",
});

const subscriptionPlan = ref('');

onMounted(() => {
  // Get subscription plan from localStorage
  const storedData = localStorage.getItem('user_status'); // Replace with your actual key
  if (storedData) {
    const parsedData = JSON.parse(storedData);
    subscriptionPlan.value = parsedData.subscriptionPlan || '';
  }
});

const canViewAnalytics = computed(() => {
  return subscriptionPlan.value !== 'standard';
});
</script>

<template>
  <div class="relative mt-4">
    <div class="min-h-screen p-6">
      <div class="flex items-center justify-between mb-6">
        <div>
          <div class="flex gap-3">
            <img src="/assets/images/analytics.png" alt="" class="h-8 w-auto" />
            <h1 class="text-2xl">Analytics</h1>
          </div>

          <p class="text-sm text-gray-500">
            Manage all product categories and their nested subcategories from
            one place.
          </p>
        </div>
      </div>
      <div class="main-content flex items-center justify-center bg-white p-4 rounded-[8px] shadow">
        <Analyticss v-if="canViewAnalytics" />
        <UpgradePrompt v-else />
      </div>
    </div>
  </div>
</template>
