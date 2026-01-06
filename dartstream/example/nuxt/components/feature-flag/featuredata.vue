<template>
  <div class="mt-4 bg-white p-4 rounded-[8px] shadow">
    <div class="flex items-center justify-between mb-4">
      <h2 class="text-lg">Flags List</h2>

      <div class="flex items-center gap-2">
        <!-- Search -->
        <div class="relative">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search..."
            class="pl-10 pr-3 py-2 border border-gray border-radius8 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
          <span class="absolute left-3 top-2.5 text-gray-400"
            ><img src="/assets/images/search.png" alt="" class="w-auto"
          /></span>
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
              <li   @click="filterOn"
                class="px-2 py-1 hover:bg-gray-100 cursor-pointer text-gray-400"
              >
              On
              </li>
              <li @click="filterOff"
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
              <li   @click="sortRecentlyCreated"
                class="px-2 py-1 hover:bg-gray-100 cursor-pointer text-gray-400"
              >
               Recently Created
              </li>
              <li @click="sortOldestCreated"
                class="px-2 py-1 hover:bg-gray-100 cursor-pointer text-gray-400"
              >
               Oldest Created
              </li>
              <li  @click="sortRecentlyUpdated"
                class="px-2 py-1 hover:bg-gray-100 cursor-pointer text-gray-400"
              >
                Recently Updated
              </li>
            </ul>
          </div>
        </div>
        <!-- Create Button -->
        <button
          @click="handleCreateFlag"
          class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2"
        >
          <img src="/assets/images/add.png" alt="" class="w-auto" />
          Create Flag
        </button>
      </div>

      <CreateFlag
        :isOpen="isModalOpen"
        @close="isModalOpen = false"
        :selectedProjectId="selectedProjectId"
        :flag="selectedFlag"
        :mode="modalMode"
        @submitted="handleFlagSubmitted"
      />
    </div>

    <!-- Flags list -->
    <div v-if="paginatedItems.length" class="space-y-4">
      <div
        v-for="item in paginatedItems"
        :key="item.key"
        class="bg-[#F8F8F8] p-4 rounded-[8px] shadow"
      >
        <div class="flex items-center justify-between">
          <div @click="goToTargetPage(item)" class="cursor-pointer w-100">
            <h3 class="">{{ item.name }}</h3>
            <p class="text-sm text-gray-500">
              {{ item.description }}
            </p>
          </div>
          <div class="relative inline-block text-left">
            <!-- Dropdown -->
            <button
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
                  <button
                    @click="handleEditFlag(item)"
                    class="flex items-center w-full gap-3 px-4 py-2 hover:bg-gray-100"
                  >
                    <img src="/assets/images/edit.png" alt="" class="w-auto" />
                    Edit Flag
                  </button>
                </li>
                <li>
                  <button
                    @click="killFlag(item.key)"
                    class="flex items-center w-full gap-3 px-4 py-2 hover:bg-gray-100"
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
                  <button
                    @click="deleteFlag(item.key)"
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

        <div class="flex items-center justify-end pb-2 border-b gap-3 mt-4">
          <!-- <p class="text-sm text-gray-500">Targeting: All users</p> -->
          <p class="text-md text-gray-500">Status (Prod)</p>
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

        <div class="flex items-center justify-between mt-3">
          <p class="text-xs text-gray-400 mt-2">
            Created at:<span
              class="ml-1 strong-blue-text text-[14px] font-semibol"
              > {{ formatDate(item.createdAt) }}</span
            >
          </p>
          <div class="flex gap-3">
            <div class="text-md text-[#525866] font-medium mt-4">Key :</div>
            <button
              @click="copyFlagKey(item.key)"
              class="mt-2 inline-flex items-center gap-2 bg-white strong-blue-text text-sm px-4 py-2 border border-gray border-radius8 hover:bg-gray-100"
            >
              <img src="/assets/images/copy.png" alt="" class="w-auto" />
              {{ item.key || '-' }}
            </button>
          </div>
        </div>
      </div>

      <!-- Pagination Footer -->
      <div
        class="flex items-center justify-between px-4 py-2 bg-white shadow-sm rounded-md"
      >
        <div class="text-sm text-gray-600">
          Page {{ currentPage }} of {{ totalPages }}
        </div>

        <!-- Numbered Pagination -->
        <div class="flex items-center space-x-1">
          <button
            class="border rounded px-2 py-1 text-gray-500 hover:bg-gray-100"
            @click="changePage(1)"
            :disabled="currentPage === 1"
          >
            «
          </button>
          <button
            class="border rounded px-2 py-1 text-gray-500 hover:bg-gray-100"
            @click="changePage(currentPage - 1)"
            :disabled="currentPage === 1"
          >
            ‹
          </button>

          <template v-for="page in visiblePages" :key="page">
            <button
              v-if="page === '...'"
              disabled
              class="px-2 py-1 text-gray-400"
            >
              ...
            </button>
            <button
              v-else
              @click="changePage(page)"
              :class="[
                'border rounded px-2 py-1',
                page === currentPage
                  ? 'bg-[#F5F7FA]'
                  : 'text-gray-600 hover:bg-gray-100',
              ]"
            >
              {{ page }}
            </button>
          </template>

          <button
            class="border rounded px-2 py-1 text-gray-500 hover:bg-gray-100"
            @click="changePage(currentPage + 1)"
            :disabled="currentPage === totalPages"
          >
            ›
          </button>
          <button
            class="border rounded px-2 py-1 text-gray-500 hover:bg-gray-100"
            @click="changePage(totalPages)"
            :disabled="currentPage === totalPages"
          >
            »
          </button>
        </div>

        <!-- Items per page -->
        <select
          class="ml-4 border rounded px-2 py-1 text-sm text-gray-600"
          v-model="itemsPerPage"
        >
          <option v-for="size in [5, 7, 10, 20]" :key="size" :value="size">
            {{ size }} / page
          </option>
        </select>
      </div>
    </div>

    <div v-else class="text-center text-gray-400 py-10">No flags found.</div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue";
import CreateFlag from "~/components/feature-flag/createflag.vue";
import { useToast } from "vue-toastification";
const { $api } = useNuxtApp();
const showSort = ref(false);
const showFilter = ref(false);
// const props = defineProps<{
//   data: Array<{ id: number | string; name: string }>
// }>()
const router = useRouter();
interface FlagSummary {
  key: string | number;
  name?: string;
  description?: string;
}
const goToTargetPage = (flag?: FlagSummary) => {
  if (!flag?.key) {
    toast.error("Unable to open this flag. Missing flag key.");
    return;
  }

  router.push({
    path: "/dashboard/enable-new",
    query: {
      flagKey: flag.key.toString(),
      flagName: flag.name ?? undefined,
    },
  });
};
const props = defineProps<{ data: any }>();

// Local state for sorting
const sortBy = ref<'created-desc' | 'created-asc' | 'updated-desc' | 'on' | 'off' | null>(null)

// Computed list based on sorting
const sortedItems = computed(() => {

  let records = [...filteredItems.value]

  switch (sortBy.value) {
    case 'created-desc':
      return records.sort(
        (a, b) =>
          new Date(b.createdAt).getTime() -
          new Date(a.createdAt).getTime()
      )
    case 'created-asc':
      return records.sort(
        (a, b) =>
          new Date(a.createdAt).getTime() -
          new Date(b.createdAt).getTime()
      )
    case 'updated-desc':
      return records.sort(
        (a, b) =>
          new Date(b.updatedAt).getTime() -
          new Date(a.updatedAt).getTime()
      )
     case 'on':
      // Active flags first
      return records.sort((a, b) => {
        if (a.status === b.status) return 0
        return a.status === 'active' ? -1 : 1
      })
    case 'off':
      // Inactive flags first
      return records.sort((a, b) => {
        if (a.status === b.status) return 0
        return a.status === 'inactive' ? -1 : 1
      })
    default:
      return records
  }
})

// Sort handlers
const sortRecentlyCreated = () => {
  sortBy.value = 'created-desc'
}
const sortOldestCreated = () => {
  sortBy.value = 'created-asc'
}
const sortRecentlyUpdated = () => {
  sortBy.value = 'updated-desc'
}
const filterOn = () => {
  sortBy.value = 'on'
}
const filterOff = () => {
  sortBy.value = 'off'
}
const emit = defineEmits(["getFlags"]);
const toast = useToast();
const { selectedProjectId, setSelectedProject } = useSelectedProject();
const copyFlagKey = async (flagKey: string) => {
  if (!flagKey) {
    toast.error("No flag key to copy.");
    return;
  }
  try {
    await navigator.clipboard?.writeText(flagKey);
    toast.success("Flag key copied to clipboard");
  } catch (error) {
    console.warn("Clipboard copy failed", error);
    toast.success(`Flag key: ${flagKey}`);
  }
};
const isModalOpen = ref(false);
const modalMode = ref("create");
const selectedFlag = ref<Flag | null>(null);
const searchQuery = ref("");
const toggles = ref<Record<string, boolean>>({});
const dropdownStates = ref<Record<string, boolean>>({});

// Replace mock data with props
const rawData = computed(() => props.data ?? []);

const filteredItems = computed(() => {
  if (!searchQuery.value.trim()) return rawData.value;
  return rawData.value.filter((item: any) =>
    item.name.toLowerCase().includes(searchQuery.value.toLowerCase())
  );
});

// Pagination
const currentPage = ref(1);
const itemsPerPage = ref(7);

const totalPages = computed(() =>
  Math.ceil(filteredItems.value.length / itemsPerPage.value)
);

const paginatedItems = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value;
return sortedItems.value.slice(start, start + itemsPerPage.value)
});

const changePage = (page: number) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page;
  }
};

// Smart pagination with ellipses
const visiblePages = computed(() => {
  const pages: (number | string)[] = [];
  const total = totalPages.value;
  const current = currentPage.value;

  if (total <= 7) {
    for (let i = 1; i <= total; i++) pages.push(i);
  } else {
    if (current > 3) pages.push(1, "...");
    const start = Math.max(2, current - 2);
    const end = Math.min(total - 1, current + 2);
    for (let i = start; i <= end; i++) pages.push(i);
    if (current < total - 2) pages.push("...", total);
  }

  return pages;
});

// Toggles and dropdowns
function toggle(id: string | number) {
  toggles.value[id] = !toggles.value[id];
}
function toggleDropdown(id: string | number) {
  dropdownStates.value[id] = !dropdownStates.value[id];
}
interface UserStatus {
  isSandbox: boolean;
  tenantName?: string;
  // add other fields as needed
}
const userStatus = ref<UserStatus | null>(null);

onMounted(() => {
  const rawUserStatus = localStorage.getItem("user_status");
  userStatus.value = rawUserStatus ? JSON.parse(rawUserStatus) : null;
});

const handleCreateFlag = () => {
  if (userStatus.value?.isSandbox) {
    toast.warning("Sandbox user cannot create a flag.");
    return;
  }
  modalMode.value = "create";
  selectedFlag.value = null;

  if (selectedProjectId.value) {
    isModalOpen.value = true;
  } else {
    toast.error("Please create your project first!");
    return;
  }
};


const handleEditFlag = (flag: Flag) => {

  dropdownStates.value[flag.key] = false;

  // Set modal state
  modalMode.value = "edit";
  
  selectedFlag.value = flag;
  isModalOpen.value = true;
};

// Accept either a message string OR an object { message, updatedFlag }
const handleFlagSubmitted = (payload: any) => {
  // close modal and clear selection
  isModalOpen.value = false;
  selectedFlag.value = null;
  modalMode.value = "create";

  // show toast
  const msg = payload?.message ?? payload ?? "Flag saved successfully!";
  toast.success(msg);

  // If child returned updated flag object, we can optimistically update local list (optional)
  const updatedFlag = payload?.updatedFlag ?? null;

  // Prefer parent refresh (safe)
  emit("getFlags");

  // Optional: if you maintain local data here (rawData/props), update it immediately:
  // if (updatedFlag) {
  //   const idx = rawData.value.findIndex((f:any) => f.key === updatedFlag.key)
  //   if (idx !== -1) rawData.value.splice(idx, 1, updatedFlag)
  //   else rawData.value.unshift(updatedFlag)
  // }
};


const deleteFlag = async (flagKey) => {
  console.log("Deleting flag:", flagKey); // 👈 check which flag you’re deleting

  try {
    const res = await $api(`/api/flags/${flagKey}`, {
      method: "DELETE",
    });

    if (res.success) {
      toast.success("Flag is Deleted Successfully!");
      if (selectedFlag.value && selectedFlag.value.key === flagKey) {
        selectedFlag.value = null;
        modalMode.value = "create";
        isModalOpen.value = false;
      }
      emit("getFlags");
    }
  } catch (error) {
    console.error("Delete flag error:", error.data || error.message);
  }
};

const killFlag = async (flagKey) => {
  console.log("Kill flag:", flagKey); // 👈 check which flag you’re deleting

  try {
    const res = await $api(
      `/api/flags/projects/${selectedProjectId.value}/flags/${flagKey}/disable`,
      {
        method: "POST",
      }
    );

    if (res.success) {
      toast.success("Flag is Killed Successfully!");
      emit("getFlags");
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
