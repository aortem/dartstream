<template>
  <div class="mt-4 bg-white p-4 rounded-[8px] shadow ">
    <div class="flex items-center justify-between mb-4">
      <h2 class="text-lg ">Flags List</h2>
      <div class="flex items-center gap-2">
   
        <div class="relative">
          <input
          v-model="searchQuery"
            type="text"
            placeholder="Search..."
            class="pl-10 pr-3 py-2 border border-gray border-radius8 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
          <span class="absolute left-3 top-2.5 text-gray-400"
            ><img src="/assets/images/search.png" alt="" class="w-auto" />
          </span>
          <span
            class="absolute right-2 top-2.5 text-xs text-gray-500 bg-gray-100 px-1.5 py-0.5 rounded"
          >
            ⌘1
          </span>
        </div>

        <button
          class="flex items-center gap-1 px-3 py-2 border border-gray border-radius8 text-gray-600 hover:bg-gray-100"
        >
          <img src="/assets/images/filter.png" alt="" class="w-auto" />
          <span>Filter</span>
        </button>

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
            class="absolute mt-1 right-0 w-32 bg-white border border-gray-200 rounded shadow-md z-10"
          >
            <ul>
              <li
                class="px-4 py-2 hover:bg-gray-100 cursor-pointer text-gray-600"
              >
                Newest
              </li>
              <li
                class="px-4 py-2 hover:bg-gray-100 cursor-pointer text-gray-600"
              >
                Oldest
              </li>
              <li
                class="px-4 py-2 hover:bg-gray-100 cursor-pointer text-gray-600"
              >
                Name
              </li>
            </ul>
          </div>
        </div>
        <button
          @click="isModalOpen = true"
          class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2 "
        >
          <img src="/assets/images/add.png" alt="" class="w-auto" />
          Create Flag
        </button>
      </div>
      <CreateFlag :isOpen="isModalOpen" @close="isModalOpen = false" />
    </div>

    <div class="space-y-4">
      <div
         v-for="item in paginatedItems"
        :key="item.id"
        class="bg-[#F8F8F8] p-4 rounded-[8px] shadow divide-y divide-gray-300"
      >
        <div>
          <div class="flex items-center justify-between">
            <div>
              <h3 class="">Enable-New-Ui {{ item.id }}</h3>
              <p class="text-sm text-gray-500">
                Gates the new onboarding experience.
              </p>
            </div>
            <div class="relative inline-block text-left">
             
              <button
                @click="toggleDropdown(item.id)"
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
                v-if="dropdownStates[item.id]"
                class="absolute right-0 mt-2 w-48 bg-white border flex justify-center border-gray-200 rounded-md shadow-md z-50"
              >
                <ul class="py-2 text-sm text-gray-700 space-y-1">
                 
                  <li>
                    <button
                      class="flex items-center w-full gap-3 px-4 py-2 hover:bg-gray-100"
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
                    <button
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
            <p class="text-sm text-gray-500">Targeting: All users</p>
         
            <div
            @click="toggle(item.id)"

              class="relative inline-flex items-center h-5 w-10 rounded-full cursor-pointer transition-colors duration-300"
              :class="toggles[item.id] ?'bg-green-500' : 'bg-gray-300'"
            >
              <span
                class="inline-block w-5 h-5 transform bg-white rounded-full shadow transition-transform duration-300"
                :class="toggles[item.id] ? 'translate-x-5' : 'translate-x-0'"
              ></span>
            </div>
          </div>
        </div>

        <div class="flex items-center justify-between">
          <p class="text-xs text-gray-400 mt-2">
            Created at:<span class="ml-1 strong-blue-text text-[14px] font-semibol"> {{ formatDate(item.createdAt) }}</span>
          </p>
           <button
           @click="navigateToEnableNew"
              class="mt-2 inline-flex items-center gap-2 bg-white strong-blue-text text-sm px-4 py-2  border border-gray border-radius8 hover:bg-gray-100"
            >
              <img src="/assets/images/copy.png" alt="" class="w-auto" />

              
              enable-new-ui
            </button>
         
        </div>
      </div>

      
      <div class="flex items-center justify-between px-4 py-2 bg-white shadow-sm rounded-md">
    <!-- Left: Page Info -->
    <div class="text-sm text-gray-600">
      Page {{ currentPage }} of {{ totalPages }}
    </div>

    <!-- Middle: Pagination Buttons -->
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

      <!-- Page numbers with ellipsis -->
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
              ? 'bg-[#F5F7FA]  '
              : 'text-gray-600 hover:bg-gray-100'
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

    <!-- Right: Items per page -->
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
  </div>
</template>
<script setup>
import { ref, computed } from 'vue'
import CreateFlag from '~/components/feature-flag/createflag.vue'
const navigateToEnableNew = () => {
  navigateTo('/admin/enable-new')
}
// Modal control
const isModalOpen = ref(false)

// Toggle states for each flag switch
const toggles = ref({})
function toggle(id) {
  toggles.value[id] = !toggles.value[id]
}

// Dropdown state for each flag
const dropdownStates = ref({})
function toggleDropdown(id) {
  dropdownStates.value[id] = !dropdownStates.value[id]
}

// Search functionality (optional extension)
const searchQuery = ref('')

// Pagination logic
const currentPage = ref(1)
const itemsPerPage = ref(7)

// Mock data (replace with real data or API call)
const data = Array.from({ length: 110 }, (_, i) => ({
  id: i + 1,
  name: `Item ${i + 1}`
}))

// Computed pagination
const totalPages = computed(() => Math.ceil(filteredItems.value.length / itemsPerPage.value))

const paginatedItems = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredItems.value.slice(start, end)
})

// Search filtering (optional)
const filteredItems = computed(() => {
  if (!searchQuery.value.trim()) return data
  return data.filter(item =>
    item.name.toLowerCase().includes(searchQuery.value.toLowerCase())
  )
})

// Change page handler
function changePage(page) {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
  }
}

// Smart pagination with ellipsis (optional)
const visiblePages = computed(() => {
  const pages = []
  const total = totalPages.value
  const current = currentPage.value

  if (total <= 7) {
    for (let i = 1; i <= total; i++) pages.push(i)
  } else {
    if (current > 3) pages.push(1, '...')
    const start = Math.max(2, current - 2)
    const end = Math.min(total - 1, current + 2)
    for (let i = start; i <= end; i++) pages.push(i)
    if (current < total - 2) pages.push('...', total)
  }

  return pages
});

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString("en-US", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
};
</script>

