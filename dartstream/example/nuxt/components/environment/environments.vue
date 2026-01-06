<template>
  <div class="">
    <div class="flex items-center justify-between bg-white p-4 rounded-lg m-4">
      <div class="">
        <h2 class="text-lg ">Your Environments</h2>
        <p class="text-sm text-gray-500">manage your different Environments</p>
      </div>
      <div class="flex items-center gap-2">
        <div class="relative">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search..."
            class="pl-10 pr-3 py-2 border border-gray border-radius8 focus:outline-none"
          />
          <span class="absolute left-3 top-2.5 text-gray-400"
            ><img src="/assets/images/search.png" alt="" class="w-auto" />
          </span>
          <span
            class="absolute right-2 top-2.5 text-xs text-gray-500 bg-gray-100 px-1.5 py-0.5 rounded"
          >
            ⌘1
          </span>
        </div>

        <button
          @click="isModalOpen = true"
          class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2 "
        >
          <img src="/assets/images/add.png" alt="" class="w-auto" />
          Add Environment
        </button>
      </div>
      <AddEnvironment :isOpen="isModalOpen" @close="isModalOpen = false" />
    </div>
    <div class="">
      <div class="bg-white rounded-lg p-4 ml-4 mr-4">
        <div class="rounded bg-gray-100 p-4">
          <div
            class="flex items-center bg-white border border-gray border-radius8 justify-between  px-4 py-2"
          >
            <div class="flex items-center space-x-2">
              <span class="h-2 w-2 rounded-full bg-blue-500"></span>
              <span class="text-sm ">Dev Card</span>
            </div>
            <div class="">
              <img src="/assets/images/load.png" alt="" class="w-auto" />
            </div>
          </div>

          <div class="px-4 py-3 space-y-3 bg-white border border-gray border-radius8 mt-4">
            <div class="flex items-center justify-between space-x-2">
              <div class="flex gap-2">
                <span class="h-2 w-2 mt-2 rounded-full bg-blue-500"></span>
                <span class="text-sm ">Development</span>
              </div>
              <div class="">
                <button
                  class="bg-gray-100 flex gap-3 border border-gray-200 px-3 py-1 rounded-md"
                >
                  <img
                    src="/assets/images/flag.png"
                    alt=""
                    class="w-auto"
                  /><span class="ml-auto text-sm text-[#42489E]">4 Flags</span>
                </button>
              </div>
            </div>
            <div class="my-5 border-t border-gray-200"></div>

            <div class="flex items-center justify-between">
              <div class="text-sm text-gray-800">
                <div class="flex gap-3">
                  🔑
                  <div class="text-gray-400">SDK Key</div>
                </div>
                <span class="text-sm "
                  >abc1234-example-key-he...</span
                >
              </div>
              <div class="flex items-center gap-2">
                <img src="/assets/images/copy.png" alt="" class="w-auto" />
              </div>
            </div>
            <div class="my-5 border-t border-gray-200"></div>

            <div class="">
              <div class="text-sm text-gray-800 flex gap-3">
                <img
                  src="/assets/images/laptop.png"
                  alt=""
                  class="h-4 w-auto"
                />
                <div class="text-gray-400">SDK Snippet</div>
              </div>
              <div class="flex items-center gap-2 mt-2 mb-2">
                <span class="">dartClient.init</span>
                <span class="text-blue-700">("abc1234...");</span>
              </div>
              <button
                class="mt-2 inline-flex items-center gap-2 bg-[#F5F7FA] text-gray-800 text-sm px-4 py-2 rounded-[8px] border  hover:bg-gray-100"
              >
                <img src="/assets/images/copy.png" alt="" class="w-auto" />
                Copy Code
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import AddEnvironment from "@/components/environment/addenvironment.vue";
const isModalOpen = ref(false);
</script>
