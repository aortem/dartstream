<script setup lang="ts">
const isModalOpen = ref(false);
definePageMeta({
  layout: "dashboard",
});

import { useToast } from "vue-toastification";
interface UserStatus {
  isSandbox: boolean;
}
const toast = useToast();
const userStatus = ref<UserStatus | null>(null);
const sandbox = ref(false);

onMounted(() => {
  const rawUserStatus = localStorage.getItem("user_status");
  userStatus.value = rawUserStatus ? JSON.parse(rawUserStatus) : null;

  if (userStatus.value?.isSandbox) {
    sandbox.value = true;
  }
});

const openModal = () => {
  if (sandbox) {
    toast.warning("You are in Sandbox Account!");
    return;
  } else {
    isModalOpen.value = true;
  }
};
</script>

<template>
  <div class="relative mt-4">
    <div class="min-h-screen p-6">
      <div class="flex items-center justify-between mb-6">
        <div>
          <h1 class="text-2xl">Environment</h1>
          <p class="text-sm text-gray-500">
            Overview of your environment and more
          </p>
        </div>
        <div class="">
          <button
            @click="openModal()"
            class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2 dashboard-create-button"
          >
            <img src="/assets/images/add.png" alt="" class="w-auto" />
            Create Environment
          </button>
        </div>
      </div>
      <div
        class="main-content flex items-center justify-center bg-white p-4 rounded-[16px]"
      >
        <div class="mt-20">
          <div
            class="bg-red-500 text-white text-sm flex items-center justify-between px-4 py-2 rounded-md shadow mb-6"
          >
            <div class="flex items-center gap-2">
              <span class="text-lg">⚠️</span>
              <span>Upgrade your membership • To see your logs activity</span>
              <a href="#" class="underline ml-2">Upgrade now</a>
            </div>
            <button class="text-white text-xl font-bold">×</button>
          </div>
          <img src="/assets/images/Light.png" alt="" class="" />
        </div>
      </div>
    </div>
  </div>
</template>
