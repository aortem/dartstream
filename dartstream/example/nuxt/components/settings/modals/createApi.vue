<template>
  <transition name="fade">
    <div
      v-if="isOpen"
      class="fixed inset-0 bg-black bg-opacity-40 z-50 flex justify-end"
    >
      <template v-if="!showNewForm">
        
          <div
            class="bg-white w-full sm:w-[500px] max-h-screen my-auto sm:my-4 mr-3 rounded-2xl shadow-xl overflow-y-auto relative"
          >
            <div
              class="flex items-center justify-between p-4 border-b bg-[#F3F5F7]"
            >
              <h2 class="text-lg font-medium">Create New API Key</h2>
              <button @click="close" class="text-gray-500 hover:text-gray-700">
                ✕
              </button>
            </div>
<form class="mt-2 space-y-6">
            <div class="p-4 m-4 space-y-4 border border-gray rounded-[16px]">
              <div class="space-y-4">
                <div class="flex gap-4">
                  <div class="w-full">
                    <label class="block font-medium"
                      >Key Name:
                      <span class="text-[#0062FF] font-medium">*</span></label
                    >
                    <input
                      v-model="form.name"
                      class="w-full border rounded-[8px] px-2 py-2 text-gray-900"
                      type="text"
                      name="name"
                    />
                  </div>
                </div>

                <div class="mt-3">
                  <label class="block font-medium">Scope</label>
                  <div class="">
                    <label class="inline-flex items-center space-x-2">
                      <input
                        type="checkbox"
                        v-model="isChecked"
                        class="form-checkbox text-blue-600 h-4 w-4"
                      />
                      <span class="text-gray-400 block font-medium"
                        >Read Flags</span
                      >
                    </label>
                  </div>
                  <div class="">
                    <label class="inline-flex items-center space-x-2">
                      <input
                        type="checkbox"
                        v-model="isChecked2"
                        class="form-checkbox text-blue-600 h-4 w-4"
                      />
                      <span class="text-gray-400 block font-medium"
                        >Write Flags</span
                      >
                    </label>
                  </div>
                  <div class="">
                    <label class="inline-flex items-center space-x-2">
                      <input
                        type="checkbox"
                        v-model="isChecked2"
                        class="form-checkbox text-blue-600 h-4 w-4"
                      />
                      <span class="text-gray-400 block font-medium"
                        >Admin (All)</span
                      >
                    </label>
                  </div>
                  <div class="">
                    <label class="inline-flex items-center space-x-2">
                      <input
                        type="checkbox"
                        v-model="isChecked2"
                        class="form-checkbox text-blue-600 h-4 w-4"
                      />
                      <span class="text-gray-400 block font-medium"
                        >Read Metrics</span
                      >
                    </label>
                  </div>
                </div>
                <div class="flex items-center justify-between mb-1">
                  <label class="text-sm font-medium text-gray-600"
                    >Expiration</label
                  >

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
                <div class="rounded space-y-2 text-sm text-gray-500">
                  <div class="w-full relative">
                    <div class="flex gap-2 mb-1">
                      <label class="block font-medium text-[#0E121B]"
                        >Date</label
                      >

                      <img
                        src="/assets/images/ionic.png"
                        alt=""
                        class="w-auto"
                      />
                    </div>

                    <input
                      class="w-full border rounded-[8px] px-3 py-3 text-[#0E121B] relative"
                      type="date"
                    />
                  </div>
                </div>
              </div>
            </div>

            <div class="p-4 m-4 space-y-4 border-t mt-40">
              <div class="flex justify-between gap-2 pt-4">
                <button
                  @click="close" type="button"
                  class="px-4 py-2 bg-[#F5F7FA] w-full rounded-[8px]"
                >
                  Cancel
                </button>
                <button
                  @click.prevent="showNewForm = true"
                  class="px-4 py-2 bg-[#42489E] text-white w-full rounded-[8px]"
                >
                  Create Key
                </button>
              </div>
            </div>
          </form>
          </div>
      </template>
      <template v-else
        ><form class="mt-2 space-y-6 h-800">
          <div
            class="bg-white w-full sm:w-[500px] max-h-screen my-auto sm:my-4 mr-3 rounded-2xl shadow-xl overflow-y-auto relative"
          >
            <div
              class="flex items-center justify-between p-4 border-b bg-[#F3F5F7]"
            >
              <h2 class="text-lg font-medium">Api Key Details</h2>
              <button @click="close" class="text-gray-500 hover:text-gray-700">
                ✕
              </button>
            </div>

            <div class="p-4 m-4 space-y-4 border border-gray rounded-[16px]">
              <div
                class="flex items-center justify-between bg-[#D8EABC] p-2 m-4 rounded-[8px]"
              >
                You won’t be able to view this key again.
              </div>
              <div class="space-y-4">
                <div class="flex gap-4">
                  <div class="w-full">
                    <label class="block font-medium">Api Key : </label>
                    <div
                      class="w-full border rounded-[8px] px-2 py-2 text-gray-900 flex justify-between"
                    >
                      <div class="">env_abcd123456xyz</div>
                      <div class="">
                        <img
                          src="/assets/images/copy.png"
                          alt=""
                          class="w-4 mt-1"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="p-4 m-4 space-y-4 border-t mt-60">
              <div class="flex justify-between gap-2 pt-4">
                <button
                  @click="close"
                  class="px-4 py-2 bg-[#F5F7FA] w-full rounded-[8px]"
                >
                  Cancel
                </button>
                <button
                  @click.prevent="showNewForm = true"
                  class="px-4 py-2 bg-[#42489E] text-white w-full rounded-[8px]"
                >
                  Revoke Key
                </button>
              </div>
            </div>
          </div>
        </form>
      </template>
    </div>
  </transition>
</template>

<script setup>
import { watch } from "vue";
const showNewForm = ref(false);
const { $api } = useNuxtApp();

const props = defineProps(["isOpen", "selectedProjectId"]);
const emit = defineEmits(["close", "submitted", "error"]);
const close = () => {
  emit("close");
};
import { ref } from "vue";
const isOn = ref(true);

function toggle() {
  isOn.value = !isOn.value;
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
