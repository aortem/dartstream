<script setup lang="ts">
const props = defineProps<{
  message: string;
  buttonText: string
}>();

const emit = defineEmits<{
  (e: "close"): void;
}>();
</script>

<template>
  <div class="fixed top-0 left-0 h-screen w-full bg-black/70 z-20">
    <div
      class="lg:w-[30%] sm:w-[448px] w-4/5 fixed top-[50%] left-[50%] -translate-y-[50%] -translate-x-[50%] sm:p-[16px] p-8 bg-white border border-[#DBDBDB] rounded-[8px] flex flex-col gap-[18px]"
    >
      <svg
        width="18"
        height="18"
        viewBox="0 0 18 18"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        class="grid place-self-end cursor-pointer"
        @click="emit('close')"
      >
        <path
          d="M4.5 13.5L13.5 4.5M4.5 4.5L13.5 13.5"
          stroke="#32363E"
          stroke-width="1.5"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      </svg>
      
      <div class="flex flex-col gap-[18px]">
       <p class="text-[#525866] text-center text-[16px]"> {{ props.message }}</p>
        <button class="bg-[#42489E] lg:w-[90%] xl:w-[366px] w-full sm:w-[366px] h-[48px] mx-auto rounded-[11.62px] text-[13.55px] font-medium text-white" @click="emit('close')">{{ props.buttonText }}</button>
      </div>
    </div>
  </div>
</template>
