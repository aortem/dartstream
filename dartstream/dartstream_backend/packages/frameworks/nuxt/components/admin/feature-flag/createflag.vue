<template>
  <transition name="fade">
    <div
      v-if="isOpen"
      class="fixed inset-0 bg-black bg-opacity-40 z-50 flex justify-end "
    >
      <div
        class="bg-white w-full sm:w-[500px] max-h-screen my-auto sm:my-4 mr-3 rounded-2xl shadow-xl overflow-y-auto relative"
      >
        <div
          class="flex items-center justify-between p-4 border-b bg-[#F3F5F7]"
        >
          <h2 class="text-lg ">Add New Flag</h2>
          <button @click="close" class="text-gray-500 hover:text-gray-700">
            ✕
          </button>
        </div>

        <div class="p-4 m-4 space-y-4 border border-gray rounded-[16px]">
          <div class="flex gap-3">
            <div
              class="flex items-center space-x-2 h-9 w-9 px-2 py-2 bg-[#E5E5E5] rounded-full"
            >
              <img src="/assets/images/flag.png" alt="" class="w-auto" />
            </div>
            <div class="">
              <h3 class="text-md ">Flag Details</h3>
              <p class="text-xs text-gray-500">Enter Flags Details</p>
            </div>
          </div>
          <div class="">
            <img src="/assets/images/divider.png" alt="" class="w-auto" />
          </div>
          <div class="space-y-4">
            <div class="flex gap-4">
              <div class="w-1/2">
                <label class="block font-medium"
                  >Name <span class="text-[#0062FF] font-medium">*</span></label
                >
                <select
                  class="w-full border rounded-[8px] px-3 py-2 text-gray-300"
                >
                  <option></option>
                </select>
              </div>

              <div class="w-1/2">
                <label class="block font-medium"
                  >Key <span class="text-[#0062FF] font-medium">*</span></label
                >
                <select
                  class="w-full border rounded-[8px] px-3 py-2 text-gray-300"
                >
                  <option></option>
                </select>
              </div>
            </div>

            <div>
              <label class="block font-medium"
                >Description <span class="text-red-500 font-medium">*</span></label
              >
              <textarea
                class="w-full border rounded-[8px] px-3 py-2"
                placeholder="Message..."
                maxlength="200"
              ></textarea>
            </div>

            <div>
              <label class="block font-medium"
                >Team <span class="text-[#0062FF] font-medium">*</span></label
              >
              <select class="w-full border rounded-[8px] px-3 py-2">
                <option>Select one</option>
              </select>
            </div>

            <div>
              <label class="block font-medium"
                >Flag Type
                <span class="text-[#0062FF] font-medium">*</span></label
              >
              <select class="w-full border rounded-[8px] px-3 py-2">
                <option>Boolean</option>
              </select>
            </div>
          </div>
        </div>
        <div
          class="flex items-center justify-between bg-[#D8EABC] p-2 m-4 rounded-[8px]"
        >
          <div class="flex gap-3">
            <img src="/assets/images/exchange.png" alt="" class="w-6" />
            Make this flag "on" default
          </div>

          <div
            @click="toggle"
            class="relative inline-flex items-center h-5 w-10 rounded-full cursor-pointer transition-colors duration-300"
            :class="isOn ? 'bg-[#7AA734]' : 'bg-gray-200'"
          >
            <span
              class="inline-block w-5 h-5 transform bg-white rounded-full shadow transition-transform duration-300"
              :class="isOn ? 'translate-x-5' : 'translate-x-0'"
            ></span>
          </div>
        </div>
        <div class="p-4 m-4 space-y-4 border border-gray rounded-[16px]">
          <div class="flex gap-3">
            <div
              class="flex items-center space-x-2 h-9 w-9 px-2 py-2 bg-[#E5E5E5]-400 rounded-full"
            >
              <img src="/assets/images/envir.png" alt="" class="w-auto" />
            </div>
            <div class="">
              <h3 class="text-md " :class="isOn ? 'text-black' : 'text-gray-300'">
                Flag Variations
              </h3>
              <p class="text-xs ":class="isOn ? 'text-black' : 'text-gray-200'">
                manage ur variations for your flag
              </p>
            </div>
          </div>
          <div class="flex gap-4">
            <div class="w-1/2">
              <label class="block font-medium ":class="isOn ? 'text-black' : 'text-gray-300'"
                >When Targeting is On <span class="text-[#0062FF] font-medium" :class="isOn ? 'text-[#0062FF]' : 'text-blue-200'">*</span></label
              >
              <select class="w-full border rounded px-3 py-2 ":class="isOn ? 'text-black' : 'text-gray-300'">
                <option>true</option>
              </select>
            </div>

            <div class="w-1/2">
              <label class="block font-medium ":class="isOn ? 'text-black' : 'text-gray-300'"
                >When Targeting is On <span class="text-[#0062FF] font-medium" :class="isOn ? 'text-[#0062FF]' : 'text-blue-200'">*</span></label
              >
              <select class="w-full border rounded px-3 py-2 ":class="isOn ? 'text-black' : 'text-gray-300'">
                <option>false</option>
              </select>
            </div>
          </div>
          <div class="w-full">
            <button class="px-4 py-2 w-full flex gap-3 justify-center rounded " :class="isOn ? 'text-black bg-[#F5F7FA]' : 'text-gray-400 bg-gray-150'">
             <img src="/assets/images/grayadd.png" alt="" class="w-6 " :class="isOn ? '' : 'opacity-50'" />  Add More Variations
            </button>
          </div>
        </div>
        <div class="p-4">
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
