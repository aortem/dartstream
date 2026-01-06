<template>
  <div class="flex gap-2">
    <img src="/assets/images/envir.png" alt="" class="h-7 w-7" />
    <h2 class="text-2xl mb-6">IP Restrictions</h2>
  </div>
  <div class="mt-[100px] flex justify-center items-center">
    <div
      class="flex w-[810px] px-12 py-3 justify-center items-center gap-3 rounded-[10px] bg-[#FC5050]"
    >
      <div>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="15"
          height="15"
          viewBox="0 0 15 15"
          fill="none"
        >
          <path
            d="M7.5 15C3.35775 15 0 11.6423 0 7.5C0 3.35775 3.35775 0 7.5 0C11.6423 0 15 3.35775 15 7.5C15 11.6423 11.6423 15 7.5 15ZM6.75 9.75V11.25H8.25V9.75H6.75ZM6.75 3.75V8.25H8.25V3.75H6.75Z"
            fill="white"
          />
        </svg>
      </div>
      <div data-cy="upgrade-prompt" class="text-[#fff]">
        Upgrade your membership To set your IP Restrictions
      </div>
      <div @click="upgrade"
        class="text-[14px] font-medium leading-[20px] tracking-[-0.084px] underline font-[Satoshi] text-[var(--neutral-0,#FFF)] cursor-pointer"
        style="
          text-decoration-skip-ink: none;
          text-underline-position: from-font;
          font-feature-settings:
            &quot;ss11&quot; on,
            &quot;cv09&quot; on,
            &quot;liga&quot; off,
            &quot;calt&quot; off;
        "
      >
        Upgrade Now
      </div>
    </div>
  </div>
  <div class="flex justify-center">
    <img src="/assets/images/Light.png" alt="" />
  </div>
  <!-- <div class="mt-5">
      <div>
        <label class="block mb-1 text-sm font-medium flex"
          >Allowed IPs
          <img src="/assets/images/ionic.png" alt="" class="h-5 w-5" />
        </label>
        <input
          type="text"
          class="w-full border border-[#E1E4EA] rounded-[8px] p-2"
        />
      </div>
      <div class="w-full mt-5">
        <button
          type="button"
          class="px-4 py-2 w-full border cursor-pointer flex gap-3 justify-center rounded-[8px] text-black bg-[#F5F7FA]"
        >
          <img src="/assets/images/grayadd.png" alt="" class="w-6" />
          Add Another IP
        </button>
      </div>
      <div class="pt-5 border-t mt-5">
        <label class="block mb-1 text-sm font-medium flex"
          >Mode
          <img src="/assets/images/ionic.png" alt="" class="h-5 w-5" />
        </label>
        <select
          class="w-full border rounded-[8px] px-3 py-3 text-[#0E121B] relative"
        >
          <option>Allow All</option>
        </select>
      </div>
    </div> -->
</template>
<script setup>
import { useToast } from "vue-toastification";
const toast = useToast();

const upgrade = () =>
{
  toast.warning("Coming Soon!");
}

</script>