<script setup lang="ts">
import SdkModal from "~/components/settings/modals/sdkModal.vue";
const isModalOpen = ref(false);
const showSort = ref(false);
definePageMeta({
  layout: "dashboard",
});
</script>

<template>
  <div class="relative mt-4">
    <div class="">
      <div class="flex items-center justify-between mb-6">
        <div>
          <div class="flex gap-3">
            <img src="/assets/images/envir.png" alt="" class="w-8 h-8" />
            <h1 class="text-2xl mt-1">Applications SDK’s</h1>
          </div>
        </div>
      </div>
      <div class="flex justify-end gap-2 w-full">
        <div class="relative">
          <input
            type="text"
            placeholder="Search..."
            class="pl-10 pr-3 py-2 border border-gray border-radius8 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
          <span class="absolute left-3 top-2.5 text-gray-400">
            <img src="/assets/images/search.png" alt="" class="w-auto" />
          </span>
          <span
            class="absolute right-2 top-2.5 text-xs text-gray-500 bg-gray-100 px-1.5 py-0.5 rounded"
          >
            ⌘1
          </span>
        </div>

        <button
          class="flex items-center gap-1 px-3 py-2 border border-gray border-radius8 text-gray-600 hover:bg-gray-100"
        >
          <img src="/assets/images/filter.png" alt="" class="w-auto" />
          <span>Filter</span>
        </button>

        <div class="relative">
          <button
            @click="showSort = !showSort"
            class="flex items-center gap-1 px-3 py-2 border border-gray border-radius8 text-gray-600 hover:bg-gray-100"
          >
            <img src="/assets/images/sort.png" alt="" class="w-auto" />
            <span>Sort by</span>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-4 w-4 ml-2 text-gray-400"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M19 9l-7 7-7-7"
              />
            </svg>
          </button>
          <div
            v-if="showSort"
            class="absolute mt-1 right-0 w-32 bg-white border border-gray border-radius8 z-10"
          >
            <ul>
              <li
                class="px-4 py-2 hover:bg-gray-100 cursor-pointer text-gray-600"
              >
                Newest
              </li>
              <li
                class="px-4 py-2 hover:bg-gray-100 cursor-pointer text-gray-600"
              >
                Oldest
              </li>
              <li
                class="px-4 py-2 hover:bg-gray-100 cursor-pointer text-gray-600"
              >
                Name
              </li>
            </ul>
          </div>
        </div>
        <div class="">
          <button
            @click="isModalOpen = true"
            class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2 dashboard-create-button"
          >
            <img src="/assets/images/add.png" alt="" class="w-auto" />
            Connect SDK
          </button>
        </div>
      </div>
      <div class="mt-5">
        <div class="">
          <div
            class="max-w-md p-4 border rounded-lg shadow-sm bg-[#F5F7FA] mb-6"
          >
            <h1 class="text-lg mb-4 font-medium">React SDK</h1>
            <div class="flex items-center mb-1 text-sm text-[#525866]">
              <span>🔐 Environment: Development</span>
            </div>
            <div
              class="flex items-center justify-between mb-2 text-sm text-[#525866]"
            >
              <span>🗝️ API Key: env_xxxxx</span>
              <button
                class="inline-flex items-center gap-2 bg-white text-[#42489E] text-xs px-3 py-1.5 border rounded-md hover:bg-gray-100"
              >
                <img
                  src="/assets/images/copy.png"
                  alt="Copy Key"
                  class="w-4 h-4"
                />
                Copy Key
              </button>
            </div>
            <div class="text-sm text-[#525866] mb-4">
              <span>⚙️ Offline: Disabled</span>
              <span class="mx-2">|</span>
              <span>TTL: 60s</span>
            </div>
            <div class="flex gap-2">
              <button class="px-4 py-2 text-sm rounded-md bg-[#E2E2E2] w-full">
                Edit config
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <SdkModal :isOpen="isModalOpen" @close="isModalOpen = false" />
  </div>
</template>
