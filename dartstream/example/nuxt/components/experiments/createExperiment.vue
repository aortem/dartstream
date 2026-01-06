<template>
  <transition name="fade">
    <div
      v-if="isOpen"
      class="fixed inset-0 bg-black bg-opacity-40 z-50 flex justify-end"
    >
     
        <div
          class="bg-white w-full sm:w-[500px] max-h-screen my-auto sm:my-4 mr-3 rounded-2xl shadow-xl overflow-y-auto relative"
        >
          <div
            class="flex items-center justify-between p-4 border-b bg-[#F3F5F7]"
          >
            <h2 class="text-lg font-medium">Create new Experiment</h2>
            <button @click="close" class="text-gray-500 hover:text-gray-700">
              ✕
            </button>
          </div>
 <form class="">
          <div class="p-4 m-4 space-y-4 border border-gray rounded-[16px]">
            <div class="flex gap-3">
              <div
                class="flex items-center space-x-2 h-9 w-9 px-2 py-2 bg-[#E5E5E5] rounded-full"
              >
                <img src="/assets/images/flag.png" alt="" class="w-auto" />
              </div>
              <div class="">
                <label class="block font-medium text-black"
                  >Experiment Details</label
                >
                <p class="text-xs text-gray-500">Enter flag details</p>
              </div>
            </div>
            <div class="">
              <img src="/assets/images/divider.png" alt="" class="w-auto" />
            </div>
            <div class="space-y-4">
              <div class="flex gap-4">
                <div class="w-full">
                  <label class="block font-medium"
                    >Expriment name
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
              <div>
                <label class="block font-medium">Linked Feature Flag</label>
                <Multiselect
                  v-model="selected"
                  :options="options"
                  :multiple="true"
                  :close-on-select="false"
                  placeholder="Select options"
                  label="label"
                  track-by="value"
                />
              </div>
              <div class="p-4 border rounded-[8px]">
                <label class="block font-medium">Variants </label>
                <div class="border rounded-[8px] mt-4">
                  <div class="bg-[#F5F7FA] p-2">
                    <label class="block font-medium">Variants Name</label>
                  </div>
                  <div class="p-2">
                    <label class="inline-flex items-center space-x-2">
                      <input
                        type="checkbox"
                        v-model="isChecked"
                        class="form-checkbox text-blue-600 h-4 w-4"
                      />
                      <span class="text-gray-700 block font-medium"
                        >Variant A</span
                      >
                    </label>
                  </div>
                  <div class="p-2">
                    <label class="inline-flex items-center space-x-2">
                      <input
                        type="checkbox"
                        v-model="isChecked2"
                        class="form-checkbox text-blue-600 h-4 w-4"
                      />
                      <span class="text-gray-700 block font-medium"
                        >Variant B</span
                      >
                    </label>
                  </div>
                </div>
              </div>
              <div>
                <label class="block font-medium">Primary Metric</label>
                <Multiselect
                  v-model="selected"
                  :options="options"
                  :multiple="true"
                  :close-on-select="false"
                  placeholder="Select options"
                  label="label"
                  track-by="value"
                />
              </div>
              <div class="w-full">
                <button
                  type="button"
                  class="px-4 py-2 w-full border flex gap-3 justify-center rounded-[8px] text-black bg-[#F5F7FA]"
                >
                  <img src="/assets/images/grayadd.png" alt="" class="w-6" />
                  Add More Metrics
                </button>
              </div>
              <div>
                <label class="block font-medium">Targeting Context</label>
                <Multiselect
                  v-model="selected"
                  :options="options"
                  :multiple="true"
                  :close-on-select="false"
                  placeholder="Select options"
                  label="label"
                  track-by="value"
                />
              </div>
              <div class="mt-3">
                <label class="block font-medium">Start Time & Duration</label>
                <div class="">
                  <label class="inline-flex items-center space-x-2">
                    <input
                      type="checkbox"
                      v-model="isChecked"
                      class="form-checkbox text-blue-600 h-4 w-4"
                    />
                    <span class="text-gray-700 block font-medium"
                      >Immediate</span
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
                    <span class="text-gray-700 block font-medium"
                      >Schedule</span
                    >
                  </label>
                </div>
              </div>
              <div class="rounded space-y-2 text-sm text-gray-500">
                <div class="w-full relative">
                  <div class="flex gap-2 mb-1">
                    <label class="block font-medium text-[#0E121B]">Date</label>

                    <img src="/assets/images/ionic.png" alt="" class="w-auto" />
                  </div>

                  <input
                    class="w-full border rounded-[8px] px-3 py-3 text-[#0E121B] relative"
                    type="date"
                  />
                </div>

                <div class="w-full">
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
          </div>

          <div class="p-4 m-4 space-y-4 border-t">
            <div class="flex justify-between gap-2 pt-4">
              <button
                @click="close" type="button"
                class="px-4 py-2 bg-[#F5F7FA] w-full rounded-[8px]"
              >
                Cancel
              </button>
              <button
                class="px-4 py-2 bg-[#42489E] text-white w-full rounded-[8px]"
              >
                Create
              </button>
            </div>
          </div>
        </form>
        </div>
    </div>
  </transition>
</template>

<script setup>
import { watch } from "vue";

const { $api } = useNuxtApp();

const props = defineProps(["isOpen", "selectedProjectId"]);
const emit = defineEmits(["close", "submitted", "error"]);
const close = () => {
  emit("close");
};
import Multiselect from "vue-multiselect";

const options = [
  { label: "flag1", value: "flag1" },
  { label: "flag2", value: "flag2" },
  { label: "flag3", value: "flag3" },
];
const options2 = [
  { label: "close", value: "close" },
  { label: "flag2", value: "flag2" },
  { label: "flag3", value: "flag3" },
];
const selected = ref([]);
const tagInput = ref("");
const tags = ref([]);
const form = ref({
  name: "",
  key: "",
  description: "",
  defaultValue: false,
  type: "",
  flag_variations: [{ name: "", value: "" }], // ✅ one initial row
});
</script>
