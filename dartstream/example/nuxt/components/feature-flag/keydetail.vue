<template>
  <div class="border bg-white p-3 w-full max-w-sm space-y-4">
    <div class="flex justify-between items-center">
      <label class="block text-sm font-medium text-gray-700">Key</label>
      <div class="">
        <button
          class="mt-2 inline-flex items-center gap-2 bg-white strong-blue-text text-sm px-4 py-2 border border-gray border-radius8 hover:bg-gray-100"
          type="button"
        >
          <img src="/assets/images/copy.png" alt="" class="w-auto" />

          {{ displayKey }}
        </button>
      </div>
    </div>

    <div>
      <label class="block text-sm font-medium text-gray-600">Description</label>
      <div class="mt-2 text-[14px] text-[#2B2B2B]">
        {{ displayDescription }}
      </div>
    </div>

    <!-- <div>
      <label class="block text-sm font-medium text-gray-600"
        >API Key / SDK instructions</label
      >
      <div class="rounded mt-1 underline text-sm">Check Instructions</div>
    </div> -->

    <div>
      <label class="block text-sm font-medium text-gray-600"
        >Code references</label
      >
      <div class="p-2 pl-4 rounded mt-1 underline text-sm">Sample-app</div>
    </div>

    <div>
      <label class="block text-sm font-medium text-gray-700 mb-1"
        >Variations</label
      >
      <div class="space-y-1">
        <div class="flex items-center gap-2">
          <div class="w-4 h-4 bg-blue-600 rounded-sm"></div>
          <span class="text-sm text-gray-700">On</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-4 h-4 bg-purple-600 rounded-sm"></div>
          <span class="text-sm text-gray-700">Off</span>
        </div>
      </div>
    </div>
    <div class="my-5 border-t border-gray-200"></div>

    <!-- <div>
      <label class="block text-sm font-medium text-gray-600"
        >Targeting Rules</label
      >
      <button
        class="border bg-[#F5F7FA] border-gray rounded-[8px] w-full p-3 flex justify-center gap-3 rounded mt-1 text-gray-600 text-sm text-center"
      >
        <img src="/assets/images/grayadd.png" alt="" class="w-auto" /> Add new
        rules
      </button>
    </div>
    <div class="my-5 border-t border-gray-200"></div> -->

    <div>
      <div class="flex items-center justify-between mb-1">
        <label class="text-sm font-medium text-gray-600">Scheduling</label>
        <!-- <span class="bg-[#344E18] text-white text-xs px-2 py-0.5 rounded-full"
          >Upgrade</span
        > -->
        <div class="flex gap-2">
          <div
            @click="toggle"
            class="relative inline-flex items-center h-5 w-10 rounded-full cursor-pointer transition-colors duration-300"
            :class="isOn ? 'bg-green-500' : 'bg-gray-300'"
          >
            <span
              class="inline-block w-5 h-5 transform bg-white rounded-full shadow transition-transform duration-300"
              :class="isOn ? 'translate-x-5' : 'translate-x-0'"
            ></span>
          </div>
          <div class="text-gray-400">On</div>
        </div>
      </div>

      <div class="p-3 rounded space-y-2 text-sm text-gray-500">
        <div
          class="w-full relative"
          :class="{ 'opacity-50 pointer-events-none': !isOn }"
        >
          <div class="flex gap-2 mb-1">
            <label class="block font-medium text-[#0E121B]">Date</label>
            <img src="/assets/images/ionic.png" alt="" class="w-auto" />
          </div>
          <input
            class="w-full border rounded-[8px] px-3 py-3 text-[#0E121B] relative"
            type="date"
          />
        </div>

        <div
          class="w-full"
          :class="{ 'opacity-50 pointer-events-none': !isOn }"
        >
          <div class="flex gap-2 mb-1">
            <label class="block font-medium text-[#0E121B]">Time</label>

            <img src="/assets/images/ionic.png" alt="" class="w-auto" />
          </div>
          <input
            class="w-full border rounded-[8px] px-3 py-3 text-[#0E121B] relative"
            type="time"
          />
        </div>
      </div>
    </div>
    <div class="my-5 border-t border-gray-200"></div>

    <div>
      <div class="flex items-center justify-between mb-5">
        <label class="text-sm font-medium text-gray-600">Audit Log</label>
      </div>
    </div>
    <div class="overflow-x-auto">
      <table class="min-w-full table-auto">
        <tbody>
          <tr v-for="(user, index) in users" :key="index">
            <td class="px-4 py-3 text-sm text-gray-800 border-b"></td>
            <td class="px-4 py-3 text-[#0E121B] border-b">
              <div class="font-medium text-[12px]">
                {{ user.name }}
              </div>
              <div class="text-[10px]">
                <span>{{ user.email }}</span>
              </div>
            </td>
            <td class="px-4 py-3 text-[#0E121B] border-b font-medium text-md">
              <div class="flex justify-end text-[11px]">
                {{ user.date }}
              </div>
              <div class="flex justify-end text-[11px]">
                {{ user.time }}
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
<script setup lang="ts">
import { computed, ref } from "vue";
import type { FlagDetail } from "~/types/flags";

const props = defineProps<{
  flag?: FlagDetail | null;
}>();

const fallbackKey = "Flag key unavailable";
const fallbackDescription = "No description provided.";

const displayKey = computed(() => props.flag?.key || fallbackKey);
const displayDescription = computed(
  () => props.flag?.description?.trim() || fallbackDescription,
);

const isOn = ref(true);

function toggle() {
  isOn.value = !isOn.value;
}
const users = [
  {
    name: "James Brown",
    email: "james@alignui.com",
    date: "Apr 29, 2025",
    time: "15:04",
  },
  {
    name: "James Brown",
    email: "james@alignui.com",
    date: "Apr 29, 2025",
    time: "15:04",
  },
  {
    name: "James Brown",
    email: "james@alignui.com",
    date: "Apr 29, 2025",
    time: "15:04",
  },
];
</script>
