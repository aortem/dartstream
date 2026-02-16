<template>
  <div
    v-if="show"
    class="fixed inset-0 flex items-center justify-center z-50 bg-black/40"
  >
    <div class="bg-white rounded-lg w-full max-w-md mx-auto shadow-lg relative">
      <div class="bg-[#F3F5F7] flex justify-between p-3 rounded-[8px]">
        <h2 class="text-center text-lg font-medium">Upgrade Your membership</h2>
        <button @click="closeModal" class="text-gray-500 hover:text-black">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>
      </div>
      <div class="p-6">
        <div class="flex justify-center">
          <div
            class="h-14 w-14 rounded-full bg-gray-100 flex items-center justify-center"
          >
            <img src="/assets/images/upgrade.png" alt="" class="" />
          </div>
        </div>

        <div class="text-center mt-3">
          <p class="text-lg font-medium mb-2">
            Upgrade Your plan to <br />
            get more insights
          </p>
          <p class="text-gray-500 text-sm mb-6">
            Lorem Ipsum is simply dummy text of the<br />
            printing and typesetting industry.
          </p>
          <button
            @click="upgradeNow"
            class="bg-[#4036A9] text-white px-4 py-2 rounded-[8px] hover:bg-[#352e93] transition"
          >
            Upgrade Now
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";

const show = ref(true);

function closeModal() {
  show.value = false;
}

function upgradeNow() {
  // Redirect or call API
  alert("Upgrade Now Clicked");
}
</script>
