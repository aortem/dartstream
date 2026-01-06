<template>
  <transition name="fade">
    <div
      v-if="isOpen"
      class="fixed inset-0 bg-black bg-opacity-40 z-50 flex justify-end "
    >
      <div
        class="bg-white w-full sm:w-[500px] max-h-screen my-auto sm:my-2 mr-2 rounded-2xl shadow-xl overflow-y-auto relative"
      >
        <div class="flex items-center justify-between p-4 border-b bg-[#F3F5F7]">
          <h2 class="text-lg ">Add Environment</h2>
          <button @click="close" class="text-gray-500 hover:text-gray-700">
            ✕
          </button>
        </div>

        <div class="p-4 space-y-4 m-4 border border-gray rounded-[16px]">
          <div class="flex gap-3">
            <div
              class="flex items-center space-x-2 h-9 w-9 px-2 py-2 bg-[#E5E5E5] rounded-full"
            >
              <img src="/assets/images/envir.png" alt="" class="w-auto" />
            </div>
            <div class="">
              <h3 class="text-md ">Environment Details</h3>
              <p class="text-xs text-gray-500">Enter Flags Details</p>
            </div>
          </div>
             <div class="">
            <img src="/assets/images/divider.png" alt="" class="w-auto" />
          </div>
          <div class="space-y-4">
            <div class="flex gap-4">
              <div class="w-1/2 ">
                <label class="block font-medium"
                  >Name <span class="text-red-600">*</span></label
                >
                <input
                  type="text"
                  class="w-full border border-gray rounded-[8px] px-3 py-2 "
                />
              </div>

              <div class="w-1/2">
                <label class="block font-medium"
                  >Environment Type <span class="text-red-600">*</span></label
                >
                <input
                  type="text"
                  class="w-full border border-gray rounded-[8px] px-3 py-2 text-gray-300"
                />
              </div>
            </div>

            <div>
              <label class="block font-medium"
                >A Short note about environment
                <span class="text-red-600">*</span></label
              >
              <textarea
                class="w-full border border-gray rounded-[8px] px-3 py-2"
                placeholder="Message..."
                maxlength="200"
              ></textarea>
            </div>
          </div>
          <div class="w-full">
            <label class="block font-medium"
              >SDK auto-generated <span class="text-red-600">*</span></label
            >
            <div
              type="text"
              class="w-full border border-gray rounded-[8px] px-3 py-2 text-gray-300 flex items-center justify-between"
            >
              <p>abc1234-exemple-key12912JERZrjaq</p>
              <img src="/assets/images/copy.png" alt="" class="w-auto" />
            </div>
          </div>
         
        </div>
        <div class="p-4 mt-24">
          <div class="flex justify-between gap-2 border-t pt-4">
            <button
              @click="close"
              class="px-4 py-2 bg-[#F5F7FA] w-full rounded-[8px]"
            >
              Cancel
            </button>
            <button
              class="px-4 py-2 bg-[#42489E] text-white w-full rounded-[8px]"
            >
              Create Flag
            </button>
          </div>
        </div>
      </div>
      
    </div>
  </transition>
</template>

<script setup>
defineProps(["isOpen"]);
const emit = defineEmits(["close"]);
const isOn = ref(true);

function toggle() {
  isOn.value = !isOn.value;
}

const close = () => {
  emit("close");
};
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
