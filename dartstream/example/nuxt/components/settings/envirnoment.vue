<script setup lang="ts">
import SdkCard from "~/components/sdk-components/sdk-card.vue";
import EnvirnomentModal from "~/components/settings/modals/envirnomentModal.vue";
import { useToast } from "vue-toastification";
const isModalOpen = ref(false);
definePageMeta({
  layout: "dashboard",
});
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
  
  if (sandbox.value) {
    toast.warning("Sandbox user not allowed to add environment!");
    return;
  } else {
    toast.warning("Standard user not allowed to add environment!");

    // isModalOpen.value = true;
  }
};
</script>

<template>
  <div class="relative">
    <div class="flex items-center justify-between mb-6">
      <div>
        <div class="flex gap-3">
          <img src="/assets/images/envir.png" alt="" class="w-7 h-7" />
          <h1 class="text-2xl">Environments</h1>
        </div>
      </div>
    </div>
    <div class="flex justify-between items-center mb-4">
      <div>
        <label class="block font-medium text-lg">Your Environments</label>
        <p class="text-sm text-gray-500">manage your different Environments</p>
      </div>
      <div class="flex gap-2 justify-end">
        <div class="relative">
          <input
            type="text"
            placeholder="Search..."
            class="pl-10 pr-3 py-2 w-full border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
          <span class="absolute left-3 top-2.5 text-gray-400">
            <img src="/assets/images/search.png" alt="Search" class="w-4 h-4" />
          </span>
          <span
            class="absolute right-2 top-2.5 text-xs text-gray-500 bg-gray-100 px-1.5 py-0.5 rounded"
          >
            ⌘1
          </span>
        </div>
        <div class="">
          <button
           @click="openModal()"
            data-cy="add-environment-button"
            class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2 dashboard-create-button"
          >
            <img src="/assets/images/add.png" alt="" class="w-auto" />
            Add Environment
          </button>
        </div>
      </div>
    </div>
    <div class="">
      <div class="bg-[#F5F7FA] p-3 h-screen flex gap-3 overflow-auto">
        <div class="min-w-[340px]">
          <div class="bg-white rounded-[8px] p-2 flex justify-between border">
            <div class="flex gap-2 font-medium">
              <div class="h-3 w-3 bg-[#3559E9] rounded-full mt-1"></div>
              Dev Card
            </div>
            <div
              class="bg-[#EBF1FF] rounded-[8px] flex gap-2 px-2 text-[#3559E9]"
            >
              <img src="/assets/images/bload.png" alt="" class="w-4 h-4 mt-1" />
              <div class="">2</div>
            </div>
          </div>
          <div class="bg-white mt-4 rounded-[8px] p-3 border">
            <div class="flex justify-between border-b pb-5 pt-4">
              <div class="flex gap-2 font-medium">
                <div class="h-3 w-3 bg-[#3559E9] rounded-full mt-1"></div>
                Development
              </div>
              <div class="bg-[#F5F7FA] rounded flex gap-2 px-2 text-[#1A1C3D]">
                <img src="/assets/images/flag.png" alt="" class="" />
                <div class="">4 Flags</div>
              </div>
            </div>
            <div class="mt-4 border-b pb-4">
              <div class="text-xs text-[#525866]">🗝️ SDK Key</div>
              <div class="mt-2 flex justify-between">
                <div class="flex font-medium">abc1234-example-key-he...</div>
                <img src="/assets/images/copy.png" alt="" class="h-4 mt-2" />
              </div>
            </div>
            <div class="mt-4 pb-4">
              <div class="text-xs text-[#525866] flex gap-2">
                <img src="/assets/images/laptop.png" alt="" class="h-4" />
                SDK Snippet
              </div>
              <div class="mt-2 flex justify-between">
                <div class="flex font-medium">
                  dartClient.init
                  <span class="text-[#7D52F4]">("abc1234...");</span>
                </div>
              </div>
            </div>
            <div class="">
              <button
                class="inline-flex items-center gap-2 bg-[#F5F7FA] text-[#525866] text-xs px-3 py-1.5 border rounded-md hover:bg-gray-100"
              >
                <img
                  src="/assets/images/copy.png"
                  alt="Copy Key"
                  class="w-4 h-4"
                />
                Copy Code
              </button>
            </div>
          </div>
        </div>
        <div class="min-w-[340px]">
          <div class="bg-white rounded-[8px] p-2 flex justify-between border">
            <div class="flex gap-2 font-medium">
              <div class="h-3 w-3 bg-[#FF8447] rounded-full mt-1"></div>
              QA Card
            </div>
            <div
              class="bg-[#FFF1EB] rounded-[8px] flex gap-2 px-2 text-[#FF8447]"
            >
              <img src="/assets/images/oeye.png" alt="" class="w-4 h-4 mt-1" />
              <div class="">3</div>
            </div>
          </div>
          <div class="bg-white mt-4 rounded-[8px] p-3 border">
            <div class="flex justify-between border-b pb-5 pt-4">
              <div class="flex gap-2 font-medium">
                <div class="h-3 w-3 bg-[#FF8447] rounded-full mt-1"></div>
                QA
              </div>
              <div class="bg-[#F5F7FA] rounded flex gap-2 px-2 text-[#1A1C3D]">
                <img src="/assets/images/flag.png" alt="" class="" />
                <div class="">4 Flags</div>
              </div>
            </div>
            <div class="mt-4 border-b pb-4">
              <div class="text-xs text-[#525866]">🗝️ SDK Key</div>
              <div class="mt-2 flex justify-between">
                <div class="flex font-medium">abc1234-example-key-he...</div>
                <img src="/assets/images/copy.png" alt="" class="h-4 mt-2" />
              </div>
            </div>
            <div class="mt-4 pb-4">
              <div class="text-xs text-[#525866] flex gap-2">
                <img src="/assets/images/laptop.png" alt="" class="h-4" />
                SDK Snippet
              </div>
              <div class="mt-2 flex justify-between">
                <div class="flex font-medium">
                  dartClient.init
                  <span class="text-[#7D52F4]">("abc1234...");</span>
                </div>
              </div>
            </div>
            <div class="">
              <button
                class="inline-flex items-center gap-2 bg-[#F5F7FA] text-[#525866] text-xs px-3 py-1.5 border rounded-md hover:bg-gray-100"
              >
                <img
                  src="/assets/images/copy.png"
                  alt="Copy Key"
                  class="w-4 h-4"
                />
                Copy Code
              </button>
            </div>
          </div>
          <div class="bg-white mt-4 rounded-[8px] p-3 border">
            <div class="flex justify-between border-b pb-5 pt-4">
              <div class="flex gap-2 font-medium">
                <div class="h-3 w-3 bg-[#FF8447] rounded-full mt-1"></div>
                QA
              </div>
              <div class="bg-[#F5F7FA] rounded flex gap-2 px-2 text-[#1A1C3D]">
                <img src="/assets/images/flag.png" alt="" class="" />
                <div class="">4 Flags</div>
              </div>
            </div>
            <div class="mt-4 border-b pb-4">
              <div class="text-xs text-[#525866]">🗝️ SDK Key</div>
              <div class="mt-2 flex justify-between">
                <div class="flex font-medium">abc1234-example-key-he...</div>
                <img src="/assets/images/copy.png" alt="" class="h-4 mt-2" />
              </div>
            </div>
            <div class="mt-4 pb-4">
              <div class="text-xs text-[#525866] flex gap-2">
                <img src="/assets/images/laptop.png" alt="" class="h-4" />
                SDK Snippet
              </div>
              <div class="mt-2 flex justify-between">
                <div class="flex font-medium">
                  dartClient.init
                  <span class="text-[#7D52F4]">("abc1234...");</span>
                </div>
              </div>
            </div>
            <div class="">
              <button
                class="inline-flex items-center gap-2 bg-[#F5F7FA] text-[#525866] text-xs px-3 py-1.5 border rounded-md hover:bg-gray-100"
              >
                <img
                  src="/assets/images/copy.png"
                  alt="Copy Key"
                  class="w-4 h-4"
                />
                Copy Code
              </button>
            </div>
          </div>
        </div>
        <div class="min-w-[340px]">
          <div class="bg-white rounded-[8px] p-2 flex justify-between border">
            <div class="flex gap-2 font-medium">
              <div class="h-3 w-3 bg-[#54A300] rounded-full mt-1"></div>
              Dev Card
            </div>
            <div
              class="bg-[#E0FAEC] rounded-[8px] flex gap-2 px-2 text-[#54A300]"
            >
              <img src="/assets/images/bload.png" alt="" class="w-4 h-4 mt-1" />
              <div class="">2</div>
            </div>
          </div>
          <div class="bg-white mt-4 rounded-[8px] p-3 border">
            <div class="flex justify-between border-b pb-5 pt-4">
              <div class="flex gap-2 font-medium">
                <div class="h-3 w-3 bg-[#54A300] rounded-full mt-1"></div>
                Development
              </div>
              <div class="bg-[#F5F7FA] rounded flex gap-2 px-2 text-[#1A1C3D]">
                <img src="/assets/images/flag.png" alt="" class="" />
                <div class="">4 Flags</div>
              </div>
            </div>
            <div class="mt-4 border-b pb-4">
              <div class="text-xs text-[#525866]">🗝️ SDK Key</div>
              <div class="mt-2 flex justify-between">
                <div class="flex font-medium">abc1234-example-key-he...</div>
                <img src="/assets/images/copy.png" alt="" class="h-4 mt-2" />
              </div>
            </div>
            <div class="mt-4 pb-4">
              <div class="text-xs text-[#525866] flex gap-2">
                <img src="/assets/images/laptop.png" alt="" class="h-4" />
                SDK Snippet
              </div>
              <div class="mt-2 flex justify-between">
                <div class="flex font-medium">
                  dartClient.init
                  <span class="text-[#7D52F4]">("abc1234...");</span>
                </div>
              </div>
            </div>
            <div class="">
              <button
                class="inline-flex items-center gap-2 bg-[#F5F7FA] text-[#525866] text-xs px-3 py-1.5 border rounded-md hover:bg-gray-100"
              >
                <img
                  src="/assets/images/copy.png"
                  alt="Copy Key"
                  class="w-4 h-4"
                />
                Copy Code
              </button>
            </div>
          </div>
          <div class="bg-white mt-4 rounded-[8px] p-3 border">
            <div class="flex justify-between border-b pb-5 pt-4">
              <div class="flex gap-2 font-medium">
                <div class="h-3 w-3 bg-[#54A300] rounded-full mt-1"></div>
                Development
              </div>
              <div class="bg-[#F5F7FA] rounded flex gap-2 px-2 text-[#1A1C3D]">
                <img src="/assets/images/flag.png" alt="" class="" />
                <div class="">4 Flags</div>
              </div>
            </div>
            <div class="mt-4 border-b pb-4">
              <div class="text-xs text-[#525866]">🗝️ SDK Key</div>
              <div class="mt-2 flex justify-between">
                <div class="flex font-medium">abc1234-example-key-he...</div>
                <img src="/assets/images/copy.png" alt="" class="h-4 mt-2" />
              </div>
            </div>
            <div class="mt-4 pb-4">
              <div class="text-xs text-[#525866] flex gap-2">
                <img src="/assets/images/laptop.png" alt="" class="h-4" />
                SDK Snippet
              </div>
              <div class="mt-2 flex justify-between">
                <div class="flex font-medium">
                  dartClient.init
                  <span class="text-[#7D52F4]">("abc1234...");</span>
                </div>
              </div>
            </div>
            <div class="">
              <button
                class="inline-flex items-center gap-2 bg-[#F5F7FA] text-[#525866] text-xs px-3 py-1.5 border rounded-md hover:bg-gray-100"
              >
                <img
                  src="/assets/images/copy.png"
                  alt="Copy Key"
                  class="w-4 h-4"
                />
                Copy Code
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <EnvirnomentModal :isOpen="isModalOpen" @close="isModalOpen = false" />
  </div>
</template>
