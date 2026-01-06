<template>
  <transition name="fade">
    <div
      v-if="isOpen"
      class="fixed inset-0 bg-black bg-opacity-40 z-50 flex justify-end"
    >
      <form class="space-y-6">
        <div
          class="bg-white w-full sm:w-[500px] max-h-screen my-auto sm:my-4 mr-3 rounded-2xl shadow-xl overflow-y-auto relative"
        >
          <div class="p-4 m-4 space-y-4 border border-gray rounded-[16px]">
            <div class="flex justify-between">
              <div class="flex gap-3">
                <div class="flex items-center mt-2 space-x-2 h-7 w-7">
                  <img
                    src="/assets/images/addblack.png"
                    alt=""
                    class="w-auto"
                  />
                </div>
                <div class="">
                  <label class="block font-medium text-black"
                    >Invite people to your Dashboard</label
                  >
                  <p class="text-xs text-gray-500">
                    we’ll email them instructions and a link to create an
                    account.
                  </p>
                </div>
              </div>
              <button @click="close" type="button" class="text-gray-500 hover:text-gray-700">
                ✕
              </button>
            </div>
            <div class="">
              <label class="text-gray-400"> Invite email </label>
              <div class="relative w-full">
                <input
                  type="text"
                  placeholder="Email Address"
                  class="pl-10 pr-3 py-2 w-full border border-gray border-radius8 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                />
                <span class="absolute left-3 top-2.5 text-gray-400">
                  <img src="/assets/images/search.png" alt="" class="w-auto" />
                </span>
                <span
                  class="absolute right-2 top-2.5 text-xs text-gray-500 bg-gray-100 px-1.5 py-0.5 rounded"
                >
                  ⌘1
                </span>
              </div>
            </div>
            <div class="">
              <div class="flex">
                <div class="w-full">
                  <label class="block font-medium">
                    Name:
                    <span class="text-[#0062FF] font-medium">*</span></label
                  >
                  <input
                    class="w-full border rounded-[8px] px-2 py-2 text-gray-900"
                    type="text"
                    name="name"
                  />
                </div>
              </div>
            </div>

            <div class="relative w-full">
              <label class="block font-medium text-[#0E121B] mb-1"
                >Select Team</label
              >

              <!-- Select Box -->
              <div
                @click="toggleDropdown"
                class="border rounded-[8px] px-3 py-3 text-[#0E121B] cursor-pointer"
              >
                {{ selectedTeam || "Select a role" }}
              </div>

              <!-- Dropdown Options -->
              <div
                v-if="showDropdown"
                class="absolute w-full border bg-white rounded-md shadow-md z-10 mt-1"
              >
                <!-- If no roles -->
                <div
                  v-if="TeamOptions.length === 0"
                  class="p-3 font-medium text-center"
                >
                  No Team yet
                  <div class="flex justify-center">
                    <button
                      @click="
                        showCreateInput = true;
                        showDropdown = false;
                      "
                      class="mt-2 px-4 py-2 bg-[#42489E] w-[40%] text-white rounded-[8px]"
                    >
                      Create Team
                    </button>
                  </div>
                </div>

                <!-- If roles exist -->
                <div v-else>
                  <div
                    v-for="(role, index) in TeamOptions"
                    :key="index"
                    class="p-2 hover:bg-gray-100 cursor-pointer"
                    @click="selectRole(role)"
                  >
                    {{ role }}
                  </div>

                  <!-- Add More Role Button -->
                  <div class="p-3">
                    <button
                      @click="
                        showCreateInput = true;
                        showDropdown = false;
                      "
                      class="px-4 py-2 bg-[#42489E] w-full text-white rounded-[8px]"
                    >
                      Add More Team
                    </button>
                  </div>
                </div>
              </div>

              <!-- Input Field to Create New Role -->
              <div
                v-if="showCreateInput"
                class="mt-2 bg-white border rounded-[8px] p-3"
              >
                <!--  -->
                <div class="" v-if="TeamOptions.length === 0">
                  <div class="font-medium text-center">No Team yet</div>
                </div>
                <div class="flex gap-2 mt-2">
                  <div class="w-full">
                    <div class="flex gap-2 mb-1">
                      <label class="block font-medium text-[#0E121B]"
                        >Team Name:</label
                      >

                      <img
                        src="/assets/images/ionic.png"
                        alt=""
                        class="w-auto"
                      />
                    </div>
                    <select
                      v-model="newRole"
                      class="border px-2 py-1 rounded w-full"
                    >
                      <option>Team1</option>
                      <option>Team2</option>
                      <option>Team3</option>
                    </select>
                  </div>
                  <button
                    @click="createRole"
                    class="px-2 py-1 bg-[#42489E] mt-7 text-white w-[40%] rounded-[8px]"
                  >
                    Create Team
                  </button>
                </div>
              </div>
            </div>
            <div class="w-full">
              <div class="flex gap-2 mb-1">
                <label class="block font-medium text-[#0E121B]"
                  >Select Role</label
                >

                <img src="/assets/images/ionic.png" alt="" class="w-auto" />
              </div>
              <select
                class="w-full border rounded-[8px] px-3 py-3 text-[#0E121B]"
              >
                <option></option>
              </select>
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
                Invite
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
const TeamOptions = ref([]);
const selectedTeam = ref("");
const showDropdown = ref(false);
const showCreateInput = ref(false);
const newRole = ref("");

const toggleDropdown = () => {
  showDropdown.value = !showDropdown.value;
};

const selectRole = (role) => {
  selectedTeam.value = role;
  showDropdown.value = false;
};

const createRole = () => {
  const trimmed = newRole.value.trim();
  if (trimmed !== "") {
    TeamOptions.value.push(trimmed);
    selectedTeam.value = trimmed;
    newRole.value = "";
    showCreateInput.value = false;
  }
};
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
