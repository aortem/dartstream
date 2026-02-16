<template>
  <transition name="fade">
    <div v-if="isOpen" class="fixed inset-0 z-50">
      <div class="absolute inset-0 bg-black/40" @click="close"></div>
      <form class="absolute inset-0 sm:inset-auto sm:right-[21px] sm:top-1/2 sm:-translate-y-1/2 isolate flex sm:block items-end sm:items-start justify-center sm:justify-start px-4 sm:px-0 py-4 sm:py-0">
        <div
          class="relative bg-white w-full sm:w-[569px] h-[min(985px,calc(100vh-32px))] rounded-[12px] sm:rounded-[8px] shadow-xl flex flex-col justify-between"
        >
          <div class="flex items-center justify-between h-[61px] px-6 py-3 bg-[#F5F7FA] rounded-t-[8px]">
            <h2 class="text-[18px] leading-[27px] tracking-[-0.015em] text-[#0E121B] font-medium">Additional details</h2>
            <button @click="close" class="text-gray-500 hover:text-gray-700">
              ✕
            </button>
          </div>

          <div class="flex-1 flex flex-col py-[34px] gap-6 overflow-y-auto pb-[88px]">
            <div class="w-full sm:w-[569px] px-4 sm:px-5 mx-auto flex flex-col gap-[16px]">
              <div class="w-full sm:w-[472px] h-[45px] bg-[#F5F7FA] border border-[#E1E4EA] rounded-[12px] px-3 py-2 flex items-center gap-2">
                <img src="/assets/images/mset.png" alt="" class="w-5 h-5" />
                <div class="text-[14px] text-nowrap leading-[21px] tracking-[-0.006em] text-[#0E121B]">
                  We need some additional details before you proceed to the web app;
                </div>
              </div>
              <div>
                <h1 class="text-[#000] text-[24px] leading-[36px] tracking-[-0.006em] font-medium">Tell us more about your account</h1>
                <p class="text-[#525866]/90 text-[16px] leading-[24px] tracking-[-0.015em] capitalize">This help customize your experience</p>
              </div>
              <!-- Cards -->
              <div class="flex flex-col sm:flex-row gap-[11px]">
              <!-- Company Account -->
              <div
                @click="selectAccount('company')"
                :class="[ 
                  'cursor-pointer box-border w-full sm:w-[259px] h-[181px] rounded-[12px] p-3 flex flex-col justify-center transition-all',
                  selected === 'company'
                    ? 'border-2 border-[#4148a3] bg-white text-[#0E121B]'
                    : 'border border-[#E1E4EA] bg-white text-[#0E121B]',
                  ]"
                >
                <div class="flex flex-col gap-[17px] w-[235px]">
                  <div class="flex justify-start">
                    <div :class="['rounded-[12px] h-14 w-14 p-3 flex items-center justify-center', selected==='company' ? 'bg-[#4148a3] text-white' : 'bg-[#F5F7FA] text-[#0E121B]']">
                      <!-- ✅ Company Icon (Lucide briefcase-business) -->
                      <!-- swapped to original asset -->
                      <img src="/images/bag.png" alt="Company" class="w-8 h-8" :style="selected==='company' ? { filter: 'brightness(0) invert(1)' } : null" />
                      <!--
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="40"
                        height="40"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        class="lucide lucide-briefcase-business-icon lucide-briefcase-business"
                      >
                        <path d="M12 12h.01" />
                        <path d="M16 6V4a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2" />
                        <path d="M22 13a18.15 18.15 0 0 1-20 0" />
                        <rect width="20" height="14" x="2" y="6" rx="2" />
                      </svg>
                      -->

                    </div>
                  </div>
                  <div class="text-[#0E121B]">
                    <h2 class="text-[18px] leading-[27px] tracking-[-0.015em] font-medium">Company account</h2>
                    <p class="text-[14px] leading-[21px] tracking-[-0.006em] text-[#525866]">Lorem Ipsum is simply dummy text of the printing and typesetting industry.</p>
                  </div>
                </div>
              </div>

              <!-- Personal Account -->
              <div
                @click="selectAccount('personal')"
                :class="[ 
                  'cursor-pointer box-border w-full sm:w-[259px] h-[181px] rounded-[12px] p-3 flex flex-col justify-center transition-all',
                  selected === 'personal'
                    ? 'border-2 border-[#4148a3] bg-white text-[#4148a3]'
                    : 'border border-[#E1E4EA] bg-white text-[#0E121B]',
                  ]"
              >
                <div class="flex flex-col gap-[17px] w-[235px]">
                  <div class="flex justify-start">
                    <div :class="['rounded-[12px] h-14 w-14 p-3 flex items-center justify-center', selected==='personal' ? 'bg-[#4148a3] text-white' : 'bg-[#F5F7FA] text-[#0E121B]']">
                      <!-- ✅ Personal Icon (User SVG you provided) -->
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke-width="1.5"
                        stroke="currentColor"
                        class="w-10 h-10"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z"
                        />
                      </svg>

                    </div>
                  </div>
                  <div :class="[ selected==='personal' ? 'text-[#4148a3]' : 'text-[#0E121B]']">
                    <h2 class="text-[18px] leading-[27px] tracking-[-0.015em] font-medium" :class="selected==='personal' ? 'text-[#4148a3]' : 'text-[#0E121B]'">Personal account</h2>
                    <p class="text-[14px] leading-[21px] tracking-[-0.006em]" :class="selected==='personal' ? 'text-[#4148a3]' : 'text-[#525866]'">Lorem Ipsum is simply dummy text of the printing and typesetting industry.</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Show name input if company selected -->
            <div v-if="selected === 'company'" class="w-full sm:w-[569px]  mx-auto">
              <label class="block text-[14px] font-medium text-[#0E121B] flex items-center gap-1">
                Company Name <span class="text-red-500">*</span>
                <img src="/assets/images/ionic.png" alt="info" class="h-4 w-4" />
              </label>

              <input
                v-model="companyName"
                type="text"
                placeholder="Enter company name"
                class="mt-1 w-[93%] border border-[#E1E4EA] rounded-[8px] p-2 focus:outline-none focus:border-[#4148a3]"
              />
            </div>
          </div>

          <div class="absolute bottom-0 left-0 right-0 h-[72px] bg-white border-t border-[#E1E4EA] shadow-[0_-4px_30.2px_rgba(0,0,0,0.05)] rounded-b-[8px] flex items-center justify-center">
            <div class="w-[569px] px-6 flex items-center gap-6">
              <button type="button" @click="close" class="h-[42px] flex-1 border border-[#EAEAEA] rounded-[8px] text-[#4C4C4C] text-[14px] font-medium">Cancel</button>
              <button type="submit" class="h-[42px] flex-1 rounded-[8px] bg-[#4148a3] text-white text-[14px] font-medium">Submit</button>
            </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </transition>
</template>

<script setup>
import { watch } from "vue";

const { $api } = useNuxtApp();

const props = defineProps(["isOpen", "selectedProjectId"]);
const emit = defineEmits(["close"]);
const close = () => {
  emit("close");
};
import { ref } from "vue";
const isOn = ref(true);
const selected = ref("personal");
const companyName = ref("");

function selectAccount(type) {
  selected.value = type;
}

const form = ref({
  name: "",
  key: "",
  description: "",
  defaultValue: false,
  type: "",
  flag_variations: [{ name: "", value: "" }], // ✅ one initial row
});
</script>
