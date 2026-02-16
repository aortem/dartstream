<template>
  <div class="flex flex-col items-center justify-center h-screen">
    <div class="">
      <img src="/assets/images/404.png" alt="" class="" />
      <img src="/assets/images/404text.png" alt="" class="mt-9" />
      <div class="text-center text-[18px] mt-3 text-[#3C4A47]">
        Try to use a correct url or go back to homepage to start again
      </div>
    </div>
  </div>
</template>
<script setup lang="ts">
const isModalOpen = ref(false);
definePageMeta({
  layout: "membership",
});
</script>
