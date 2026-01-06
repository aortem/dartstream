<template>
  <aside class="w-64 h-screen bg-white border-r px-4 py-6 mt-4">
    <div
      class="text-xs  text-gray-400 uppercase mb-3 "
    >
      Main Menu
    </div>

    <nav class="space-y-2">
      <NuxtLink
        to="/admin"
        :class="[
          'flex items-center space-x-3 px-2 py-2 transition',
          $route.path === '/admin/dashboard'
            ? 'bg-[#E5E5E5] rounded-[30px] text-black'
            : 'text-gray-700 hover:text-black hover:bg-gray-100 rounded-md',
        ]"
      >
        <img src="/assets/images/dashboard.png" alt="" class="w-auto" />

        <span class="">Dashboard</span>
      </NuxtLink>

      <NuxtLink
        to="/admin/feature-flags"
        :class="[
          'flex items-center space-x-3 px-2 py-2 transition',
          $route.path === '/admin/feature-flags'
            ? 'bg-[#E5E5E5] rounded-[30px] text-black'
            : 'text-gray-700 hover:text-black hover:bg-gray-100 rounded-md',
        ]"
      >
        <img src="/assets/images/flag.png" alt="" class="w-auto" />
        <span class="">Feature Flags</span>
      </NuxtLink>

      <NuxtLink
        to="/admin/user-management"
        :class="[
          'flex items-center space-x-3 px-2 py-2 transition',
          $route.path === '/admin/user-management'
            ? 'bg-[#E5E5E5] rounded-[30px] text-black'
            : 'text-gray-700 hover:text-black hover:bg-gray-100 rounded-md',
        ]"
      >
        <img src="/assets/images/envir.png" alt="" class="w-auto" />
        <span class="">User Management</span>
      </NuxtLink>
    
    </nav>

    <div class="my-5 border-t border-gray-200"></div>

    <div
      class="text-xs  text-gray-500 uppercase mb-3 "
    >
      Preferences
    </div>

    <nav class="space-y-2">
      <NuxtLink
        to="/admin/setting"
        :class="[
          'flex items-center space-x-3 px-2 py-2 transition',
          $route.path === '/admin/setting'
            ? 'bg-[#E5E5E5] rounded-[30px] text-black'
            : 'text-gray-700 hover:text-black hover:bg-gray-100 rounded-md',
        ]"
      >
        <img src="/assets/images/setting.png" alt="" class="w-auto" />
        <span class="">Settings</span>
      </NuxtLink>

        <div class="px-4 py-4">
      <button
        @click="handleLogout"
        class="flex items-center space-x-2 text-gray-500 hover:text-red-600 transition w-full"
      >
        <img src="/assets/images/support.png" alt="Logout" class="w-5 h-5" />
        <span>Log Out</span>
      </button>
    </div>
    </nav>
  </aside>
</template>
<script setup lang="ts">
import { useToast } from 'vue-toastification';
const { $api } = useNuxtApp()
const router = useRouter()
const toast = useToast();
const handleLogout = async () => {
    try {
    const res = await $api('/auth/logout', {
      method: 'POST',
 
    })
  
     useCookie('auth_token').value = null
      
     // alert('Signup successful!')
     router.push('/auth/login')
      toast.success('You have been logged out successfully.')
    

  } catch (error) {
    // Handle logout failure (optional)
    toast.error('Logout failed. Please try again.')
    console.error('Logout error:', error)
  }
}
</script>