<template>
  <div class="dashboard-welcome">
    <div class="grid grid-flow-col grid-rows-1 gap-4">
      <div class="grid grid-cols-2 grid-rows-2 gap-4 w-full dashboard-cards">
        <div
          class="bg-white flex items-center h-[190px] w-full p-4 rounded-[16px]"
        >
          <div class="">
            <div
              class="bg-[#F8F8F8] rounded-full p-2 flex items-center justify-center w-10 h-10"
            >
              <img src="/assets/images/bag.png" alt="" class="w-auto" />
            </div>

            <div>
              <p class="text-2xl text-[#042F2C] mt-3">
                {{ props.totalFlags || 0 }}
              </p>
              <p class="text-gray-500 text-sm">Total Flags</p>
            </div>
          </div>
        </div>

        <div
          class="bg-white flex items-center h-[190px] w-full p-4 rounded-[16px]"
        >
          <div class="">
            <div
              class="bg-[#F8F8F8] rounded-full p-2 flex items-center justify-center w-10 h-10"
            >
              <img src="/assets/images/doc.png" alt="" class="w-auto" />
            </div>
            <div>
              <p class="text-2xl text-[#042F2C] mt-3">1</p>
              <p class="text-gray-500 text-sm">Total Users</p>
            </div>
          </div>
        </div>

        <div
          class="bg-white flex items-center h-[190px] w-full p-4 rounded-[16px]"
        >
          <div class="">
            <div
              class="bg-[#F8F8F8] rounded-full p-2 flex items-center justify-center w-10 h-10"
            >
              <img src="/assets/images/eye.png" alt="" class="w-auto" />
            </div>
            <div>
              <p class="text-2xl text-[#042F2C] mt-3">1</p>
              <p class="text-gray-500 text-sm">Environments</p>
            </div>
          </div>
        </div>

        <div
          class="bg-white flex items-center h-[190px] w-full p-4 rounded-[16px]"
        >
          <div class="">
            <div
              class="bg-[#F8F8F8] rounded-full p-2 flex items-center justify-center w-10 h-10"
            >
              <img src="/assets/images/eye.png" alt="" class="w-auto" />
            </div>
            <div>
              <p class="text-2xl text-[#042F2C] mt-3">0</p>
              <p class="text-gray-500 text-sm">Flags Currently Live in Prod</p>
            </div>
          </div>
        </div>
      </div>
      <div class="bg-white p-4 rounded-[16px] row-span-2 h-[400px] w-full">
        <h2 class="text-lg text-[#1C1C1C] mb-2">Recent activity</h2>
        <p class="text-gray-400 text-sm">
          Total jobs applied by candidates in your company
        </p>

        <div class="flex items-center justify-center h-full w-full">
          <div class="text-center p-6 max-w-md w-full space-y-4">
            <h6
              class="flex items-center justify-center text-xl text-gray-800 gap-2"
            >
              <!-- SVG Icon -->
              <svg
                width="21"
                height="20"
                viewBox="0 0 21 20"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M10.5 0.149902L14.3034 5.7146L20.7717 7.6127L16.6542 12.9497L16.8477 19.6871L10.5 17.4209L4.15227 19.6871L4.34577 12.9497L0.228271 7.6127L6.69657 5.7146L10.5 0.149902ZM10.5 3.3395L7.81977 7.2617L3.26127 8.5982L6.16377 12.3584L6.02607 17.1059L10.5 15.5093L14.973 17.1059L14.8362 12.3584L17.7378 8.5982L13.1802 7.2617L10.5 3.3395ZM8.69997 10.4999C8.69997 10.9773 8.88961 11.4351 9.22718 11.7727C9.56474 12.1103 10.0226 12.2999 10.5 12.2999C10.9774 12.2999 11.4352 12.1103 11.7728 11.7727C12.1103 11.4351 12.3 10.9773 12.3 10.4999H14.1C14.1 11.4547 13.7207 12.3704 13.0456 13.0455C12.3704 13.7206 11.4548 14.0999 10.5 14.0999C9.54519 14.0999 8.62952 13.7206 7.95439 13.0455C7.27926 12.3704 6.89997 11.4547 6.89997 10.4999H8.69997Z"
                  fill="#525866"
                />
              </svg>
              No Activity Yet
            </h6>
            <p class="text-gray-500 text-sm">
              You can invite people to your web app project and manage them
              while seeing their activity in real-time.
            </p>
            <div class="flex justify-center">
              <button
                @click="inviteUser"
                class="w-[113px] h-[40px] px-2 py-1.5 border rounded-full flex items-center justify-center gap-1 bg-white text-gray-900 hover:bg-gray-100 transition"
              >
                Invite Users
              </button>
            </div>
          </div>
        </div>

        <!-- <div class="overflow-x-auto">
          <table class="w-full divide-y divide-gray-200 bg-white  rounded-[16px] mt-5">
            <tbody class="divide-y divide-gray-200 text-sm text-gray-700">
              <tr>
                <td class="px-2 py-2 whitespace-nowrap text-[#0E121B] text-lg">Apr 29, 2025 15:04</td>
                <td class="px-2 py-2 whitespace-nowrap text-[#0E121B] text-lg">Flag toggled ON</td>
                <td class="px-2 py-2 whitespace-nowrap text-[#0E121B] text-lg">
                  <div class="text-[#0E121B] text-lg">James Brown</div>
                  <div class="text-[#525866] text-sm">james@alignui.com</div>
                </td>
              </tr>
              <tr>
                <td class="px-2 py-2 whitespace-nowrap text-[#0E121B] text-lg">Apr 28, 2025 18:12</td>
                <td class="px-2 py-2 whitespace-nowrap text-[#0E121B] text-lg">May 6, 2025</td>
                <td class="px-2 py-2 whitespace-nowrap text-[#0E121B] text-lg">
                  <div class="text-[#0E121B] text-lg">John Dev</div>
                  <p class="text-[#525866] text-sm">james@alignui.com</p>
                </td>
              </tr>
              <tr>
                <td class="px-2 py-2 whitespace-nowrap text-[#0E121B] text-lg">Apr 27, 2025 18:12</td>
                <td class="px-2 py-2 whitespace-nowrap text-[#0E121B] text-lg">May 6, 2025</td>
                <td class="px-2 py-2 whitespace-nowrap text-[#0E121B] text-lg">
                  <div class="text-[#0E121B] text-lg">Admin</div>
                  <div class="text-[#525866] text-sm">james@alignui.com</div>
                </td>
              </tr>
              <tr>
                <td class="px-2 py-2 whitespace-nowrap text-[#0E121B] text-lg">Apr 27, 2025 18:12</td>
                <td class="px-2 py-2 whitespace-nowrap text-[#0E121B] text-lg">May 6, 2025</td>
                <td class="px-2 py-2 whitespace-nowrap text-[#0E121B] text-lg">
                  <div class="text-[#0E121B] text-lg">Admin</div>
                  <div class="text-[#525866] text-sm">james@alignui.com</div>
                </td>
              </tr>
            </tbody>
          </table>
        </div> -->
      </div>
    </div>

    <div class="mt-4 bg-white p-4 rounded-[16px] dashboard-flag-list">
      <div class="flex items-center justify-between mb-4">
        <div class="">
          <h2 class="text-lg strong-blue">Flags List</h2>
          <p class="text-gray-400 text-sm">
            View all your clients information.
          </p>
        </div>

        <div class="flex items-center gap-2">
          <div class="relative">
            <input
              type="text"
              placeholder="Search..."
              class="pl-10 pr-3 py-2 border border-gray border-radius8 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
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

          <div class="relative">
            <button
              @click="showFilter = !showFilter"
              class="flex items-center gap-1 px-3 py-2 border border-gray border-radius8 text-gray-600 hover:bg-gray-100"
            >
              <img src="/assets/images/filter.png" alt="" class="w-auto" />
              <span>Filter</span>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-4 w-4 ml-2 text-gray-400"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M19 9l-7 7-7-7"
                />
              </svg>
            </button>
            <div
              v-if="showFilter"
              class="absolute mt-1 right-0 w-[125%] bg-white border border-gray border-radius8 z-10"
            >
              <ul>
                <li
                  @click="filterOn"
                  class="px-2 py-1 hover:bg-gray-100 cursor-pointer text-gray-400"
                >
                  On
                </li>
                <li
                  @click="filterOff"
                  class="px-2 py-1 hover:bg-gray-100 cursor-pointer text-gray-400"
                >
                  Off
                </li>
              </ul>
            </div>
          </div>

          <div class="relative">
            <button
              @click="showSort = !showSort"
              class="flex items-center gap-1 px-3 py-2 border border-gray border-radius8 text-gray-600 hover:bg-gray-100"
            >
              <img src="/assets/images/sort.png" alt="" class="w-auto" />
              <span>Sort by</span>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-4 w-4 ml-2 text-gray-400"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M19 9l-7 7-7-7"
                />
              </svg>
            </button>
            <div
              v-if="showSort"
              class="absolute mt-1 right-0 w-[125%] bg-white border border-gray border-radius8 z-10"
            >
              <ul>
                <li
                  @click="sortRecentlyCreated"
                  class="px-2 py-1 hover:bg-gray-100 cursor-pointer text-gray-400"
                >
                  Recently Created
                </li>
                <li
                  @click="sortOldestCreated"
                  class="px-2 py-1 hover:bg-gray-100 cursor-pointer text-gray-400"
                >
                  Oldest Created
                </li>
                <li
                  @click="sortRecentlyUpdated"
                  class="px-2 py-1 hover:bg-gray-100 cursor-pointer text-gray-400"
                >
                  Recently Updated
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <div class="space-y-4" v-if="props.totalFlags">
        <div
          class="bg-[#F8F8F8] p-4 rounded-lg shadow divide-y divide-gray-300"
          v-for="item in sortedItems"
          :key="item.key"
        >
          <div class="">
            <div data-cy="flag-list" class="flex items-center justify-between">
              <div class="">
                <h3 class="">{{ item.name }}</h3>
                <p class="text-sm text-gray-500">
                  {{ item.description }}
                </p>
              </div>
              <div class="relative inline-block text-left">
                <button
                  data-cy="dropdown-button"
                  @click="toggleDropdown(item.key)"
                  class="p-2 rounded-full hover:bg-gray-200"
                >
                  <svg
                    class="w-5 h-5 text-gray-600"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                  >
                    <path
                      d="M6 10a2 2 0 11-4 0 2 2 0 014 0zm6 0a2 2 0 11-4 0 2 2 0 014 0zm6 0a2 2 0 11-4 0 2 2 0 014 0z"
                    />
                  </svg>
                </button>

                <div
                  v-if="dropdownStates[item.key]"
                  class="absolute right-0 mt-2 w-48 bg-white border flex justify-center border-gray-200 rounded-md shadow-md z-50"
                >
                  <ul class="py-2 text-sm text-gray-700 space-y-1">
                    <li>
                      <button  @click="handleEditFlag(item)"
                        class="flex items-center w-full px-4 gap-3 py-2 hover:bg-gray-100"
                      >
                        <img
                          src="/assets/images/edit.png"
                          alt=""
                          class="w-auto"
                        />
                        Edit Flag
                      </button>
                    </li>

                    <li>
                      <button  @click="killFlag(item.key)"
                        class="flex items-center w-full px-4 gap-3 py-2 hover:bg-gray-100"
                      >
                        <img
                          src="/assets/images/switch.png"
                          alt=""
                          class="w-auto"
                        />
                        Kill Switch
                      </button>
                    </li>

                    <li>
                      <button data-cy="delete-flag"  @click="deleteFlag(item.key)"
                        class="flex items-center w-full px-4 gap-3 py-2 text-red-600 hover:bg-red-50"
                      >
                        <img
                          src="/assets/images/delete.png"
                          alt=""
                          class="w-auto"
                        />
                        Delete Flag
                      </button>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div class="flex items-center justify-between mb-2 mt-4">
              <!-- <p class="text-sm text-gray-500">Targeting: All users</p> -->
              <p class="text-sm text-gray-500"></p>
              <div
                @click="toggle(item.key)"
                class="relative inline-flex items-center h-5 w-10 rounded-full cursor-pointer transition-colors duration-300"
                :class="
                  (toggles[item.key] ?? item.status === 'active')
                    ? 'bg-green-500'
                    : 'bg-gray-300'
                "
              >
                <span
                  class="inline-block w-5 h-5 transform bg-white rounded-full shadow transition-transform duration-300"
                  :class="
                    (toggles[item.key] ?? item.status === 'active')
                      ? 'translate-x-5'
                      : 'translate-x-0'
                  "
                ></span>
              </div>
            </div>
          </div>

          <div class="flex items-center justify-between">
            <p class="text-xs text-gray-400 mt-2">
              Created at :<span
                class="ml-1 strong-blue-text text-[14px] font-semibol"
                > {{ formatDate(item.createdAt) }}</span
              >
            </p>
            <button
              @click="navigateToEnableNew"
              class="mt-2 inline-flex items-center gap-2 bg-white strong-blue-text text-sm px-4 py-2 border border-gray border-radius8 hover:bg-gray-100"
            >
              <img src="/assets/images/copy.png" alt="" class="w-auto" />

              {{ item.key || '—' }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
  <CreateFlag
  :isOpen="isModalOpen"
  @close="isModalOpen = false"
  :selectedProjectId="selectedProjectId"
  :flag="selectedFlag"
  :mode="modalMode"
  @submitted="() => { isModalOpen = false; emit('refreshFlags') }"
/>

</template>

<script setup lang="ts">
import { ref, computed } from "vue";
import { useToast } from "vue-toastification";
import CreateFlag from "~/components/feature-flag/createflag.vue";
const emit = defineEmits<{
  (e: "openFlag", payload: { modalMode: "create" | "edit"; selectedFlag?: Flag }): void;
  (e: "refreshFlags"): void;
  (e: "getFlags"): void;
}>();
const { $api } = useNuxtApp();
const { selectedProjectId, setSelectedProject } = useSelectedProject();

// ✅ defineProps with types
interface Flag {
  key: string | number;
  name: string;
  description: string;
  status: "active" | "inactive";
  createdAt: string;
  updatedAt: string;
}
const props = defineProps<{
  totalFlags: number;
  flagsList: Flag[];
}>();

const toast = useToast();

// UI states
const showSort = ref(false);
const showFilter = ref(false);
const dropdownStates = ref<Record<string | number, boolean>>({});
const toggles = ref<Record<string | number, boolean>>({});
const isSandbox = ref(false);

// Dropdown toggle
function toggleDropdown(id: string | number) {
  dropdownStates.value[id] = !dropdownStates.value[id];
}


const refreshFlags = () => {
  emit("refreshFlags");
};


// Switch toggle
function toggle(id: string | number) {
  toggles.value[id] = !(
    toggles.value[id] ??
    props.flagsList.find((f) => f.key === id)?.status === "active"
  );
}

// Toast example
const navigateToEnableNew = () => {
  toast.success("Copied!");
};

// Invite example
const inviteUser = () => {
  if (isSandbox.value) {
    toast.error("Sandbox user not allowed to invite users!");
  } else {
    toast.error("Standard user not allowed to invite users!");
  }
};

// Sorting state
const sortBy = ref<
  "created-desc" | "created-asc" | "updated-desc" | "on" | "off" | null
>(null);

// Computed list (sorting + filtering)
const sortedItems = computed(() => {
  let records = [...(props.flagsList ?? [])];

  switch (sortBy.value) {
    case "created-desc":
      return records.sort(
        (a, b) =>
          new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
      );
    case "created-asc":
      return records.sort(
        (a, b) =>
          new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime()
      );
    case "updated-desc":
      return records.sort(
        (a, b) =>
          new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime()
      );
    case "on":
      return records.filter((f) => f.status === "active");
    case "off":
      return records.filter((f) => f.status === "inactive");
    default:
      return records;
  }
});

// Sort & Filter handlers
const sortRecentlyCreated = () => (sortBy.value = "created-desc");
const sortOldestCreated = () => (sortBy.value = "created-asc");
const sortRecentlyUpdated = () => (sortBy.value = "updated-desc");
const filterOn = () => (sortBy.value = "on");
const filterOff = () => (sortBy.value = "off");
const isModalOpen = ref(false);
const modalMode = ref<"create" | "edit">("create");
const selectedFlag = ref<Flag | null>(null);



  // When editing an existing flag
const handleEditFlag = (flag: Flag) => {

  dropdownStates.value[flag.key] = false;

  // Set modal state
  modalMode.value = "edit";
  
  selectedFlag.value = flag;
  isModalOpen.value = true;
};


const deleteFlag = async (flagKey) => {
  console.log("Deleting flag:", flagKey); // 👈 check which flag you’re deleting

  try {
    const res = await $api(`/api/flags/${flagKey}`, {
      method: "DELETE",
    });

    if (res.success) {
      toast.success("Flag is Deleted Successfully!");
    refreshFlags();
    }
  } catch (error) {
    console.error("Delete flag error:", error.data || error.message);
  }
};

const killFlag = async (flagKey) => {

  try {
    const res = await $api(
      `/api/flags/projects/${selectedProjectId.value}/flags/${flagKey}/disable`,
      {
        method: "POST",
      }
    );

    if (res.success) {
      toast.success("Flag is Killed Successfully!");
     refreshFlags();
    }
  } catch (error) {
    console.error("Kill flag error:", error.data || error.message);
  }
};

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString("en-US", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
};
</script>
