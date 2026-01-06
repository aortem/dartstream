<script setup lang="ts">
import Featuredata from "~/components/feature-flag/featuredata.vue";
import { ref, onMounted } from "vue"
import { useToast } from "vue-toastification";

definePageMeta({
  layout: "dashboard",
});

const { $api } = useNuxtApp()
const toast = useToast()
const flags = ref(null)
const selectedProjectId  = ref()

onMounted(() => {
  const rawUserStatus = localStorage.getItem('user_status');
  const userStatus = rawUserStatus ? JSON.parse(rawUserStatus) : null;
   selectedProjectId.value = localStorage.getItem('selectedProject');
  if (userStatus?.isSandbox) {
    
    getDemoData();
  }else{
    getAllFlags();
  }
})

const getDemoData = async () => {
  try {
    const demoData = await $api('/api/sandbox/demo-data', { method: 'GET' })
    if (demoData && demoData.flags) {
      flags.value = demoData.flags; 
    } else {
      toast.error("Flags not found!");
    }
  } catch (e) {
    toast.error("Failed to fetch demo data.");
  }
}
const getAllFlags = async () => {
  try {
    const demoData = await $api(`/api/flags/projects/${selectedProjectId}/flags`, { method: 'GET' })
    if (demoData && demoData.flags) {
      flags.value = demoData.flags; 
  
      
    } else {
      toast.error("Flags not found!");
    }
  } catch (e) {
    toast.error("Failed to fetch demo data.");
  }
}
</script>

<template>
  <div class="min-h-screen bg-[#F8F8F8] p-6 ">
    <div class="flex gap-3">
      <!-- <div
        class="flex items-center space-x-2 h-12 w-12 px-2 py-2 bg-[#E5E5E5] rounded-full"
      >
        <img src="/assets/images/flag.png" alt="" class="h-9 w-auto" />
      </div> -->
      <div>
        <div class="flex gap-3"><img src="/assets/images/enable.png" alt="" class="h-8 w-auto" />
          <h1 class="font-satoshi font-medium text-2xl font-bold ">Feature Flags</h1>
        </div>
        <p class="text-sm text-gray-500">
          Manage all product categories and their nested subcategories from one
          place.
        </p>
      </div>
    </div>
    <Featuredata :data="flags" @getFlags="getAllFlags"/>

  </div>
</template>
