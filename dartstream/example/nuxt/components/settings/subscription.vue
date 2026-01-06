<template>
  <div class="">
  
    <div class=" ">
      <div class="flex gap-3">
        <img src="/assets/images/planb.png" alt="" class="h-7 w-7" />
        <h2 class="text-xl  mb-4">Plans</h2>
      </div>

      <div class="">
        <div class="flex justify-between items-center">
          <div>
            <h3 class="text-lg font-medium">Current Plan</h3>
            <p class="text-gray-500 text-sm">
              Pick an account plan that fits your workflow.
            </p>
          </div>
          <button v-if="isSubscriptionActive"
            class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] hover:bg-indigo-700"
          >
            Upgrade
          </button>
          <button v-if="isSandbox" @click="resetSandbox" 
            class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] hover:bg-indigo-700"
          >
            Reset Sandbox Account
          </button>
        </div>
        <div class="relative mt-5">
          <div
            class="flex justify-between border border-[#42489E] rounded-t-lg p-3 bg-[#E9EAF6]"
          >
 {{
    isSandbox
      ? 'Sandbox'
      : isSubscriptionActive
        ? 'Standard'
        : 'Free'
  }}
            <div class="text-[#42489E]">
              <svg
                class="w-6 h-6"
                fill="currentColor"
                viewBox="0 0 20 20"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  fill-rule="evenodd"
                  d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.707a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
          </div>
          <div
            class="flex justify-between items-center p-4 border border-gray-200 rounded-b-lg"
          >
            <div>
              <p class="text-2xl font-bold text-gray-800 mt-1">
                {{
    isSandbox
      ? 'Free'
      : isSubscriptionActive
        ? '$120'
        : ''
  }}
                <span class="text-sm font-normal text-gray-500"> {{
    isSandbox
      ? '7 Days'
      : isSubscriptionActive
        ? 'per year'
        : ''
  }}</span>
              </p>
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
               Flags & Projects
              </li><li class="flex items-center gap-2">
                <svg class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0" viewBox="0 0 16 13" fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                Environment-Specific Flags
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
              </li>
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
               Kill Switch / Instant Rollback
              </li>
              <li class="flex items-center gap-2">
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
                Analytics Hooks (Flag Metrics)
              </li><li class="flex items-center gap-2">
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
              </li>
            </ul>
          </div>
        </div>
              <!-- <ul class="mt-4 space-y-2 text-gray-700">
                <li class="flex items-center gap-2">
                  <span class="text-indigo-600 font-bold flex"><img src="/assets/images/tick.png" alt="" class="" /></span> 1 user
                </li>
                <li class="flex items-center gap-2">
                  <span class="text-indigo-600 font-bold flex"><img src="/assets/images/tick.png" alt="" class="" /></span> Limited
                  environments/features
                </li>
              </ul> -->
            </div>
          </div>
        </div>
      </div>
    </div>


    <!-- <div class="">
      <div class="flex justify-between items-center mb-4 mt-4">
        <div class="">
          <h3 class="text-lg ">Billing History</h3>
          <p class="text-gray-500 text-sm">
            Update your billing details and address.
          </p>
        </div>

        <button class="border px-3 py-2 rounded-[8px] hover:bg-gray-100 flex gap-3">
          <img src="/assets/images/download.png" alt="" class="" /> Download all
        </button>
      </div>
      <div class="overflow-x-auto border rounded-[8px] shadow">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-4 py-3 flex items-center justify-center">
                <input
                  type="checkbox"
                  class="form-checkbox ml-2 h-4 w-4 text-indigo-600"
                />
              </th>
              <th
                class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase"
              >
                Invoice ⭳
              </th>
              <th
                class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase"
              >
                Amount
              </th>
              <th
                class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase"
              >
                Date
              </th>
              <th
                class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase"
              >
                Status
              </th>
              <th class="px-4 py-2"></th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="(invoice, index) in invoices" :key="index">
              <td class="px-4 py-2 flex items-center justify-center">
                <input
                  type="checkbox"
                  class="form-checkbox ml-2 h-4 w-4 text-indigo-600"
                />
              </td>
              <td class="px-4 py-2 text-sm">{{ invoice.name }}</td>
              <td class="px-4 py-2 text-gray-400 text-sm">{{ invoice.amount }}</td>
              <td class="px-4 py-2 text-gray-400 text-sm">{{ invoice.date }}</td>
              <td class="px-4 py-2">
                <span class="text-[#027A48] bg-[#ECFDF3] p-1">✔ Paid</span>
              </td>
              <td class="px-4 py-2">
                <button class="text-gray-400 hover:text-gray-600">
                  <img src="/assets/images/download.png" alt="" class="" />
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div> -->
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue";
import { useToast } from "vue-toastification";
const { $api } = useNuxtApp()
const router = useRouter()
const toast = useToast()
interface UserStatus {
  isSandbox: boolean;
  subscriptionStatus?: boolean;
  // add other fields as needed
}

const isSandbox = ref(false)
const isSubscriptionActive = ref(false)



const userStatus = ref<UserStatus | null>(null);



onMounted(() => {
  const rawUserStatus = localStorage.getItem("user_status");
  userStatus.value = rawUserStatus ? JSON.parse(rawUserStatus) : null;
  console.log(userStatus.value?.isSandbox);
  
  if (userStatus.value?.isSandbox) {
  
    isSandbox.value = true
  }
  if (!userStatus.value?.isSandbox && userStatus.value?.subscriptionStatus) {
     isSubscriptionActive.value = true
  }


});
const invoices = [
  { name: "Basic Plan – Dec 2022", amount: "USD $10.00", date: "Dec 1, 2022" },
  { name: "Basic Plan – Nov 2022", amount: "USD $10.00", date: "Nov 1, 2022" },
  { name: "Basic Plan – Oct 2022", amount: "USD $10.00", date: "Oct 1, 2022" },
  { name: "Basic Plan – Sep 2022", amount: "USD $10.00", date: "Aug 1, 2022" },
];


const resetSandbox = async () => {
  try {
    // Always try to send logout request if token exists
    const token = useCookie("auth_token").value;

    if (token) {
      await $api("/api/sandbox/reset", {
        method: "POST"
      });
    }

    // Clear token regardless of logout API result
    useCookie("auth_token").value = null;
    localStorage.removeItem("auth_token");
    localStorage.removeItem("refresh_token");
    localStorage.removeItem("auth_user");
    localStorage.removeItem("sandbox");

    // Redirect after clearing state
    router.push("/auth/login");
    toast.success("You have been reset your account");
  } catch (error) {
    // Even if API fails, proceed with client logout
    

    useCookie("auth_token").value = null;
    localStorage.clear();

    router.push("/auth/login");
    toast.error(
      "Something went wrong on logout, but we logged you out locally."
    );
  }
};
</script>


