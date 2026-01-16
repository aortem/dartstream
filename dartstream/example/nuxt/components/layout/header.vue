<template>
  <header
    class="bg-[#1A1C3D] shadow-md px-6 py-4 flex items-center justify-between"
  >
    <div class="flex items-center space-x-6 w-full max-w-3xl">
      <NuxtLink to="/" class="flex items-center space-x-2">
        <img
          src="/assets/images/header-logo.png"
          alt="Logo"
          class="h-10 w-auto"
        />
      </NuxtLink>

      <div class="relative w-full max-w-sm">
        <input
          type="text"
          placeholder="Search..."
          class="w-full bg-white/20 text-white placeholder-white rounded-full py-2 px-4 pl-10 focus:outline-none focus:ring-2 focus:ring-white/30"
        />
        <svg
          class="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-white"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          viewBox="0 0 24 24"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M21 21l-4-4m0 0a7 7 0 10-9.9 0 7 7 0 009.9 0z"
          />
        </svg>
      </div>
    </div>

    <div
      class="flex md:flex-row flex-col md:items-center items-end sm:w-auto w-full space-x-3"
    >
      <div class="relative bg-white/20 p-2 rounded-full">
        <img src="/assets/images/bell.png" alt="" class="w-auto" />

        <span
          class="absolute top-2 right-2 h-2.5 w-2.5 bg-red-600 rounded-full"
        ></span>
      </div>

      <div class="h-7 w-px bg-[#474747] md:block hidden"></div>
      <div @click="toggleDropdown">
        <img
          v-if="avatarUrl"
          :src="avatarUrl"
          class="md:h-[45px] md:w-[45px] h-[20px] w-[30px] rounded-full"
          alt="avatar"
        />
        <img
          v-else
          src="/assets/images/avatar.png"
          alt="avatar"
          class="md:h-[45px] md:w-[45px] h-[30px] object-fill w-[30px] rounded-full"
        />
      </div>
      <div class="flex items-center space-x-2 relative" @click="toggleDropdown">
        <div class="flex flex-col w-full text-white">
          <div class="flex items-center space-x-2">
            <span class="font-medium sm:block hidden">{{
              tenantName ? tenantName : "Sophia Williams"
            }}</span>

            <div
              class="h-5 w-5 text-white rounded-full hidden sm:flex items-center justify-center cursor-pointer"
            >
              <!-- <img src="/assets/images/verify.png" alt="" class="w-4" /> -->
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-5 w-5 text-white"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                stroke-width="2"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M19 9l-7 7-7-7"
                />
              </svg>
            </div>
          </div>

          <span class="text-sm md:block hidden">
            {{ user.email ? user.email : "anonymous@acme.com" }}
          </span>
        </div>
        <div
          v-if="showDropdown"
          class="absolute right-0 lg:top-14 top-10 sm:w-48 w-64 bg-white shadow-md rounded-[8px] z-50 p-3"
        >
          <span class="font-medium block sm:hidden px-4 py-2">{{
            tenantName ? tenantName : "Sophia Williams"
          }}</span>

          <hr class="my-1 block sm:hidden" />
          <span class="block sm:hidden px-4 py-2">
            {{ user.email ? user.email : "anonymous@acme.com" }}
          </span>
          <div
            @click="goToSettings"
            class="flex items-center px-4 py-2 font-medium hover:bg-gray-100 cursor-pointer text-sm text-gray-700"
          >
            <img
              src="/assets/images/setting.png"
              alt="Settings"
              class="w-4 h-4 mr-2"
            />
            Settings
          </div>
          <hr class="my-1" />
          <hr class="my-1 block sm:hidden" />
          <div
            @click="handleLogout"
            class="flex items-center px-4 py-2 font-medium hover:bg-gray-100 cursor-pointer text-sm text-red-500"
          >
            <img
              src="/assets/images/logout.png"
              alt="Logout"
              class="w-4 h-4 mr-2"
            />
            Log Out
          </div>
        </div>
      </div>
    </div>
  </header>
</template>
<script setup lang="ts">
import { useToast } from "vue-toastification";
import { ref, onMounted } from "vue";
import { signOut } from "firebase/auth";
import { useRouter } from "vue-router";
import { useAvatar } from "~/composables/useAvatar";
import { useAuth } from "~/composables/useAuth";

const { user } = useAuth();

const { avatarUrl, refreshAvatar } = useAvatar();

const { $firebaseAuth, $api } = useNuxtApp();
const router = useRouter();

const toast = useToast();
const email = ref("");
const tenantName = ref("");
const tenantId = ref();

const showDropdown = ref(false);

function toggleDropdown() {
  showDropdown.value = !showDropdown.value;
}

function goToSettings() {
  // Navigate to settings page
  // window.location.href = "/dashboard/setting"; // or use NuxtLink programmatically
  router.push("/dashboard/setting");
}
onMounted(async () => {
  const rawUserStatus = localStorage.getItem("user_status");
  const userStatus = rawUserStatus ? JSON.parse(rawUserStatus) : null;
  tenantId.value = rawUserStatus ? JSON.parse(rawUserStatus).tenantId : null;

  const rawAuthUser = localStorage.getItem("auth_user");
  const authUser = rawAuthUser ? JSON.parse(rawAuthUser) : null;

  email.value = authUser?.email || "";
  tenantName.value = userStatus?.tenantName || "";



});

const handleLogout = async () => {
  try {
    // Always try to send logout request if token exists
    const token = useCookie("auth_token").value;
    await signOut($firebaseAuth);
    if (token) {
      await $api("/auth/logout", {
        method: "POST",
      });
    }

    // Clear token regardless of logout API result
    useCookie("auth_token").value = null;
    localStorage.removeItem("auth_token");
    localStorage.removeItem("refresh_token");
    localStorage.removeItem("auth_user");
    localStorage.removeItem("sandbox");
    localStorage.removeItem("selectedProject");
    localStorage.removeItem("user_status");
    // localStorage.clear();

    // Redirect after clearing state
    router.push("/auth/login");
    toast.success("You have been logged out successfully.");
  } catch (error) {
    // Even if API fails, proceed with client logout
    console.error("Logout error (proceeding anyway):", error);

    useCookie("auth_token").value = null;
    // localStorage.clear();
    localStorage.removeItem("auth_token");
    localStorage.removeItem("refresh_token");
    localStorage.removeItem("auth_user");
    localStorage.removeItem("sandbox");
    localStorage.removeItem("selectedProject");
    localStorage.removeItem("user_status");

    router.push("/auth/login");
    toast.error(
      "Something went wrong on logout, but we logged you out locally."
    );
  }
};
</script>
