<script setup lang="ts">
import { ref, computed, onMounted } from "vue";
import { useToast } from "vue-toastification";
   
definePageMeta({
  layout: "membership",
});

const { $api } = useNuxtApp()
const showModal = ref(false);
const router = useRouter()
const toast = useToast()

const form = ref({
  name: '',
  description: '',
  environmentSetup: ''
})

const onSubmit = async () => {
  const { name, description, environmentSetup } = form.value

  try {
    const res = await $api('/api/projects/', {
      method: 'POST',
      body: {
        description,
        name,
      },
    })
    // router.push('/membership')
    // toast.success('Signup successful!')

  } catch (error: any) {
    console.error('Error:', error.data || error.message)
    toast.error(error.data?.message || 'Project creation failed. Please try again.')
  }
}

function openModal() {
  getUserStatus();

}

function closeModal() {
  showModal.value = false;
}

const getUserStatus = async () => {

  try {
    const userStatus = await $api('/auth/user-status', { method: 'GET' })
 if (userStatus) {
      localStorage.setItem('user_status', JSON.stringify(userStatus))
    }
  //     const raw = localStorage.getItem('sandbox');
  // const sandbox = raw ? JSON.parse(raw) : null;

  if (!userStatus?.isSandbox) {
    showModal.value = true;
  } else {
    router.push('/dashboard');
  }
  // console.log('jiya',userStatus?.subscriptionStatus);
  
  //   if (userStatus?.subscriptionStatus == 'none') {
  //     showModal.value = false;
  //     router.push('/dashboard');
  // } else {
  //   if (userStatus?.subscriptionStatus == 'active') {
  //      showModal.value = true;
  //   }
  // }

  } catch (error: any) {
    console.error('Error:', error.data || error.message)
    toast.error(error.data?.message || 'User not Found. Please try again.')
  }
}


</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100">
    <div class="bg-white shadow-lg rounded-lg p-6 w-full max-w-xl text-center">
      <!-- Logo -->
      <div class="flex justify-center mb-4">
        <img src="/assets/images/logo.png" alt="Logo" class="h-10" />
      </div>

      <!-- Heading -->
      <h2 class="text-xl mb-2">🎉 Welcome To IntelliToggle! 🎉</h2>
      <p class="text-gray-600 text-sm mb-4">
        You’ve unlocked the ultimate toolkit! ✨ Here’s what you can do now.
      </p>

      <!-- Features -->
      <div class="text-left border border-gray-200 rounded-md p-4 mb-4">
        <p class=" text-gray-600 text-sm mb-2">Features:</p>
        <div class="w-full flex">
          <div class="w-1/2">
            <ul class="text-sm space-y-2">
              <li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                Core Feature Flags API
              </li>
              <li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                Percentage Rollouts
              </li><li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
               Kill Switch / instant rollback
              </li><li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
             API Management Access
              </li><li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
              SDK caching and offline mode
              </li>
              <!-- <li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                SDK Caching & Offline Mode
              </li><li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
               API Management Access (single key)
              </li><li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                Monthly API Calls (10k)
              </li><li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                Support SLA (72 HR SLA)
              </li> -->
            </ul>
          </div>
          <div class="w-1/2">
            <ul class="text-sm space-y-2">
              <li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
            Targeting Rules Engine ( Basic)
              </li>
              <li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
              Flutter Client SDK
              </li>
              <li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
           Dart Server SDK (OpenFeature)
              </li><li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
              OpenFeature Compliance
              </li>
              <!-- <li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
               Dart Server SDK (OpenFeature)
              </li><li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                Client Side SDKs
              </li><li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
               OpenFeature Compliance
              </li><li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
              Log Retention (7 days)
              </li><li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
              1 User
              </li> -->
            </ul>
          </div>
        </div>

      </div>

      <!-- Button to Open Modal -->
      <button @click="openModal"
        class="w-full bg-[#42489E] hover:bg-[#353A89] text-white py-2 rounded-md transition duration-150">
        Get Started
      </button>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg shadow-xl p-6 max-w-lg w-full">
        <div class="flex justify-center mb-4">
          <img src="/assets/images/logo.png" alt="Logo" class="h-10" />
        </div>

        <!-- Heading -->
        <h2 class="text-xl text-center mb-2">
          🎉 Let’s Start By Creating Your first Project 🎉
        </h2>
        <form @submit.prevent="onSubmit">

       
        <div class="mt-3">
          <label class="block font-medium">
            Name <span class="text-[#E93544] font-medium">*</span>
          </label>
          <input v-model="form.name"
            class="w-full border rounded-[8px] px-3 py-2 text-gray-700 focus:outline-none focus:ring-0 focus:border-gray-300"
            placeholder="Enter name" />
        </div>


        <!-- <div class="mt-3">
          <label class="block font-medium">
            Environment Setup <span class="text-[#E93544] font-medium">*</span>
          </label>
          <select v-model="form.environmentSetup"
            class="w-full border rounded-[8px] px-3 py-2 text-gray-700 focus:outline-none focus:ring-0 focus:border-gray-300">
            <option value="">Select Environment</option>
            <option value="dev">Dev</option>
            <option value="prod">Prod</option>
          </select>
        </div> -->


        <div class="mt-3">
          <label class="block font-medium">
            Description <span class="text-red-500 font-medium">*</span>
          </label>
          <textarea v-model="form.description"
            class="w-full border rounded-[8px] px-3 py-2 focus:outline-none focus:ring-0 focus:border-gray-300"
            placeholder="Message..." maxlength="400"></textarea>
        </div>


        <div class="mt-3 w-full">
          
            <button type="submit" class="
              px-4 py-2 w-full rounded-[8px] transition duration-150
               bg-[#42489E] text-white hover:bg-[#353A89]
            ">
              Create
            </button>
        
        </div>
         </form>
      </div>
    </div>
  </div>
</template>
