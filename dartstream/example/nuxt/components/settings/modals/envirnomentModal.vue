<template>
  <transition name="fade">
    <div
      v-if="isOpen"
      class="fixed inset-0 bg-black bg-opacity-40 z-50 flex justify-end"
    >
      <form class="mt-2 space-y-6"  @submit.prevent="onCreate">
        <div
          class="bg-white w-full sm:w-[500px] max-h-screen my-auto sm:my-4 mr-3 rounded-2xl shadow-xl overflow-y-auto relative"
        >
          <div
            class="flex items-center justify-between p-4 border-b bg-[#F3F5F7]"
          >
            <h2 class="text-lg">Add Environment</h2>
            <button @click="close" class="text-gray-500 hover:text-gray-700">
              ✕
            </button>
          </div>

          <div class="p-4 m-4 space-y-4 border border-gray rounded-[16px]">
            <div class="flex gap-3">
              <div
                class="flex items-center space-x-2 h-9 w-9 px-2 py-2 bg-[#E5E5E5] rounded-full"
              >
                <img src="/assets/images/envir.png" alt="" class="w-auto" />
              </div>
              <div class="">
                <label class="block font-medium text-black"
                  >Environment details</label
                >
                <p class="text-xs text-gray-500">Enter flag details</p>
              </div>
            </div>
            <div class="">
              <img src="/assets/images/divider.png" alt="" class="w-auto" />
            </div>
            <div class="">
              <div class="flex w-full gap-3">
                <div class="w-1/2">
                  <label class="block font-medium">
                    Name:
                    <span class="text-[#FC5050] font-medium">*</span></label
                  >
                  <input
                    class="w-full border rounded-[8px] px-2 py-2 text-gray-900"
                    type="text"
                    name="name"
                  />
                </div>
                <div class="w-1/2">
                  <label class="block font-medium">
                    Environment Type:
                    <span class="text-[#FC5050] font-medium">*</span></label
                  >
                   <select
                  class="w-full border rounded-[8px] px-3 py-2"
                  v-model="form.type"
                >
                  <option value="">All</option>
                  <option value="production">Production</option>
                  <option value="development">Development</option>
                  <option value="staging">Staging</option>
                </select>
                </div>
              </div>
            </div>
            <div>
              <label class="block font-medium">
                A short note about this environment:
                <span class="text-[#FC5050] font-medium">*</span></label
              >
              <textarea
                name="description"
                class="w-full border rounded-[8px] px-3 py-2"
                placeholder="Message..."
                rows="5"
              ></textarea>
            </div>
            <div class="w-full">
              <label class="block font-medium"
                >SDK auto-generated
                <span class="text-[#FC5050] font-medium">*</span></label
              >
              <div
                class="w-full border rounded-[8px] px-2 py-2 text-gray-900 flex justify-between"
              >
                <div class="">env_x2190JSskLé&à</div>
                <div class="">
                  <img src="/assets/images/copy.png" alt="" class="w-4 mt-1" />
                </div>
              </div>
            </div>
          </div>

          <div class="p-4 m-4 space-y-4 border-t mt-40">
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
                Create
              </button>
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
import Multiselect from "vue-multiselect";

const options = [
  { label: "flag1", value: "flag1" },
  { label: "flag2", value: "flag2" },
  { label: "flag3", value: "flag3" },
];
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

const onCreate = () => {
  // do your create logic or:
  // emit('create', form.value)
}
</script>
