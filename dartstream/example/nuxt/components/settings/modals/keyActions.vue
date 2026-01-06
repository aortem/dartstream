<!-- components/KeyActions.vue -->
<template>
  <div class="relative">
    <img
      src="/images/blackdots.png"
      alt="More options"
      class="w-5 h-5 cursor-pointer"
      @click="toggleDropdown"
    />
    <div
      v-if="open"
      class="absolute right-0 z-10 mt-2 w-40 bg-white border rounded shadow-lg"
    >
      <ul class="text-sm text-gray-700">
        <li
          @click="handle('rotate')"
          class="px-4 py-2 hover:bg-gray-100 cursor-pointer"
        >
          <div class="flex justify-start gap-2">
            <div class="">♻️</div>
            Rotate Key
          </div>
        </li>
        <li
          @click="handle('revoke')"
          class="px-4 py-2 hover:bg-gray-100 cursor-pointer"
        >
          <div class="flex justify-start gap-2">
            <div class="">🗑</div>
            Revoke Key
          </div>
        </li>
        <li
          @click="handle('regenerate')"
          class="px-4 py-2 hover:bg-gray-100 text-red-500 cursor-pointer"
        >
          <div class="flex justify-start gap-2">
            <div class="">🔒</div>
            Regenerate Key
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup lang="ts">
const open = ref(false);

const toggleDropdown = () => {
  open.value = !open.value;
};

const handle = (action: string) => {
  console.log("Action:", action);
  open.value = false;
};
</script>
