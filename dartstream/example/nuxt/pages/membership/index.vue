<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useToast } from "vue-toastification";
import SignupModal from "~/pages/membership/signupModal.vue";
const { startCheckout } = useCheckout();
const { $api } = useNuxtApp();
const router = useRouter();
const route = useRoute();
const toast = useToast();
const isModalOpen = ref(false);
definePageMeta({
  layout: "membership",
});
const showModal = () => {
  isModalOpen.value = true;
};
// Allow forcing the Additional Details modal via query param for QA
onMounted(() => {
  const q = (route.query?.details ?? "").toString().toLowerCase();
  if (q === "1" || q === "true") {
    isModalOpen.value = true;
  }
});
const billingCycle = ref<"monthly" | "annual">("monthly");

const sendData = async (nameVal: string) => {
  try {
    if (nameVal == "enhanced" || nameVal == "entreprise") {
      toast.warning("Coming Soon");
      return;
    }

    const payload = {
      type: "subscription",
      planId: nameVal,
      successUrl: `${window.location.origin}/membership/membership-paid`,
      cancelUrl: `${window.location.origin}/membership/`,
    };
    const response = await $api("/api/billing/checkout", {
      method: "POST",
      body: payload,
    });
    // ✅ Only redirect to the checkout page
    if (response?.checkoutUrl) {
      window.location.href = response.checkoutUrl;
    } else {
      console.warn("⚠️ No checkout URL returned in response");
    }
  } catch (error) {
    console.error("❌ Error:", error);
  }
};

const sandbox = async () => {
  try {
    const authUserRaw = localStorage.getItem("auth_user");
    const authUser = authUserRaw ? JSON.parse(authUserRaw) : null;

    const res = await $api("/api/sandbox/subscribe", {
      method: "POST",
      body: {
        email: authUser.email,
        name: "My Sandbox",
      },
    });

    if (res.success) {
      localStorage.setItem("sandbox", JSON.stringify(res.tenant));
      setTimeout(() => {
        router.push("/membership/membership-paid");
      }, 100); // 100ms is usually enough
      toast.success(res.message);
    } else {
      toast.error(res.message);
    }
  } catch (error: any) {
    console.error("error:", error.data || error.message);
    toast.error(error.data?.message || "Please try again.");
  }
};

const alertShow = () => {
toast.warning('Coming Soon!')
return;
}
</script>

<template>
  <div
    class="min-h-screen flex items-center justify-center pt-6 pr-16 pb-6 pl-16"
  >
    <div class="card bg-white w-screen rounded-lg">
      <div class="card-body p-6 md:p-10">
        <div
          class="flex flex-col md:flex-row justify-between items-start md:items-center mb-10 md:mb-12"
        >
          <div class="mb-6 md:mb-0 md:pr-6">
            <h5 class="text-3xl md:text-3xl text-gray-800 mb-2 leading-tight">
              Select Your IntelliToggle Subscription
            </h5>
            <p class="text-gray-600 text-base md:text-lg max-w-xl">
              Select you prefered Plan.
            </p>
          </div>

          <!-- <div class="flex-shrink-0 relative">
              Toggle buttons
            <div class="inline-flex rounded-lg border border-gray-200 p-1 bg-gray-100">
              <button type="button" @click="billingCycle = 'monthly'" :class="[
                'px-5 py-2.5 rounded-md text-sm font-medium transition-colors duration-150',
                billingCycle === 'monthly'
                  ? 'bg-[#42489E] text-white shadow-md'
                  : 'text-gray-700 hover:bg-white focus:outline-none focus:bg-white'
              ]">
                Monthly
              </button>
              <button type="button" @click="billingCycle = 'annual'" :class="[
                'px-5 py-2.5 rounded-md text-sm font-medium transition-colors duration-150',
                billingCycle === 'annual'
                  ? 'bg-[#42489E] text-white shadow-md'
                  : 'text-gray-700 hover:bg-white focus:outline-none focus:bg-white'
              ]">
                Annual
              </button>
            </div>

              Info Text
             <div class="mt-3 flex items-center space-x-2">

               <span><img src="/images/info-icon.png" alt="info-icon" /></span>
              <span class="text-sm">
                <span class="font-bold">{{ billingCycle === 'annual' ? 'Annual' : 'Monthly' }}</span>
                 <span class="text-indigo-600">– 2 months free 🎉</span>
              </span>
            </div>
          </div>-->
        </div>

        <div class="flex flex-wrap -mx-2 lg:-mx-4">
          <div class="w-full md:w-1/2 lg:w-1/3 px-2 lg:px-4 mb-8">
            <div
              class="bg-white rounded-xl shadow-lg p-6 md:p-8 flex flex-col h-full"
            >
              <div class="flex items-center gap-2 mb-2">
                <h6 class="text-2xl text-gray-800">Standard</h6>
                <span
                  class="-rotate-12 bg-[#42489E] text-white px-2.5 py-0.5 rounded-full shadow"
                >
                  Billed annually
                </span>
              </div>
              <p class="text-2xl text-gray-900 mb-1">
                $10
                <span class="text-sm font-normal text-gray-500">per month</span>
              </p>
              <hr />
              <p
                class="text-1xl text-gray-800 font-normal mt-3 mb-3 min-h-[10px]"
              >
                Features
              </p>
              <ul class="space-y-3 text-gray-600 mb-8 flex-grow">
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Core Feature Flags API
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Targeting Rules Engine ( Basic)
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Percentage Rollouts
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Flutter Client SDK
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Kill Switch / instant rollback
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Dart Server SDK (OpenFeature)
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  API Management Access
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  OpenFeature Compliance
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  SDK caching and offline mode
                </li>
              </ul>
           
               <!-- <button
                  @click="sendData('standard')"
                  class="w-full bg-[#42489E] hover:bg-[#353A89] text-white py-3 px-6 rounded-lg transition duration-150 text-center"
                >
                  Sign Up
                </button> -->
               <button
                   @click.prevent.stop="startCheckout('standard')"
                   data-cy="button-sign-up-standard"
                  class="w-full bg-[#42489E] hover:bg-[#353A89] text-white py-3 px-6 rounded-lg transition duration-150 text-center"
                >
                  Sign Up
                </button>
             
            </div>
          </div>

          <div class="w-full md:w-1/2 lg:w-1/3 px-2 lg:px-4 mb-8">
            <div
              class="bg-white rounded-xl shadow-lg p-6 md:p-8 flex flex-col h-full"
            >
              <!-- Title + Badge -->
              <div class="flex items-center gap-1.5 mb-2">
                <h6 class="text-2xl text-gray-800">Enhanced</h6>
                <span
                  class="-rotate-12 bg-[#42489E] text-white px-2.5 py-0.5 rounded-full shadow"
                >
                  Billed annually
                </span>
              </div>

              <!-- Price + Most Popular -->
              <div class="flex items-center justify-between mb-3">
                <p class="text-2xl text-gray-900">
                  $149
                  <span class="text-sm font-normal text-gray-500"
                    >per month</span
                  >
                </p>
                <button
                  class="whitespace-nowrap px-4 py-1.5 border-2 border-black rounded-lg bg-black text-white text-sm font-medium hover:bg-gray-900 transition"
                >
                  Most Popular
                </button>
              </div>

              <hr />
              <p
                class="text-1xl text-gray-800 font-normal mt-3 mb-3 min-h-[10px]"
              >
                Features
              </p>
              <ul class="space-y-3 text-gray-600 mb-8 flex-grow">
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Multi Environment support (dev / staging / prod)
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Unlimited Flags & Projects
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Targeting Rules Engine (advanced + custom attributes)
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Environment-Specific Flags
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Real-Time Streaming Flag Updates (Websocket/ gRPC)
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Analytics hooks (flag usage tracking)
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Built-in A/B Testing / Experimentation Dashboard
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Audit Logs (90 days + export in CSV/JSON)
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  API Access with mutiple keys & custom roles
                </li>
              </ul>
              <button
                @click.prevent.stop="startCheckout('enhanced')"
                class="mt-auto w-full bg-[#42489E] text-white py-3 px-6 rounded-lg hover:bg-[#353A89] transition duration-150 text-center"
              >
                Sign Up
              </button>
            </div>
          </div>

          <div class="w-full md:w-1/2 lg:w-1/3 px-2 lg:px-4 mb-8">
            <div
              class="bg-white rounded-xl shadow-lg p-6 md:p-8 flex flex-col h-full"
            >
              <div class="flex items-center gap-2 mb-2">
                <h6 class="text-2xl text-gray-800">Entreprise</h6>
                <span
                  class="-rotate-12 bg-[#42489E] text-white px-2.5 py-0.5 rounded-full shadow"
                >
                  Billed annually
                </span>
              </div>
              <!-- <h6 class="text-2xl text-gray-800 mb-2">Entreprise</h6> -->
              <p class="text-2xl text-gray-900 mb-1">
                Custom
                <span class="text-sm font-normal text-gray-500">per month</span>
              </p>
              <hr />

              <p
                class="text-1xl text-gray-800 font-normal mt-3 mb-3 min-h-[10px]"
              >
                Features
              </p>
              <ul class="space-y-3 text-gray-600 mb-8 flex-grow">
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Unlimited Flags & Projects
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Unlimited Audit Logs (1 year +)
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Full access tp all SaaS modules
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Dedicated customer success manager
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  24/7 support (phone, email , stack )
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Custom SLA (eg 99.99% uptime , penalty ,clauses=
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Multi-Environment Support
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Custom integrations (eq VCH hooks , Terraform provider)
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  White labeled portal
                </li>
                <li class="flex items-center">
                  <svg
                    class="w-5 h-5 text-indigo-500 mr-2 flex-shrink-0"
                    viewBox="0 0 16 13"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1.22 8.71997C1.22 8.71997 2.72 8.71997 4.72 12.22C4.72 12.22 10.2788 3.0533 15.22 1.21997"
                      stroke="currentColor"
                      stroke-width="1.5"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  Optional on-premises deploymet air gapped/secure hosting)
                </li>
              </ul>
              <!-- <button
                @click="showModal"
                class="mt-auto w-full bg-[#42489E] text-white py-3 px-6 rounded-lg hover:bg-[#353A89] transition duration-150 text-center"
              >
                Sign Up
              </button> -->
                 <button
                 @click="alertShow()"
                class="mt-auto w-full bg-[#42489E] text-white py-3 px-6 rounded-lg hover:bg-[#353A89] transition duration-150 text-center"
              >
                Sign Up
              </button>
            </div>
          </div>
        </div>

        <div
          class="flex flex-col md:flex-row justify-between items-start md:items-center mb-10 md:mb-12"
        >
          <div class="mb-6 md:mb-0 md:pr-6">
            <h6 class="text-2xl md:text-2xl text-gray-800 mb-2 leading-tight">
              Start your 7-days free
              <span class="text-black">Sandbox</span> Plan
            </h6>
            <p class="text-gray-400 text-base md:text-lg max-w-xl">
              Join over 1,000+ startups already growing with Untitled.
            </p>
          </div>

          <div
            class="flex flex-col sm:flex-row justify-center items-center gap-4"
          >
            <button
              class="w-full sm:w-auto px-6 py-3 text-base font-medium rounded-lg text-gray-500 bg-white border border-gray-300 hover:bg-gray-50 transition duration-150"
            >
              Learn more
            </button>
            <button
              @click="sandbox"
              data-cy="button-get-started"
              class="w-full sm:w-auto px-6 py-3 text-base font-medium rounded-lg text-white bg-[#42489E] hover:bg-[#42489E] transition duration-150"
            >
              Get started
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
  <SignupModal :isOpen="isModalOpen" @close="isModalOpen = false" />
</template>
