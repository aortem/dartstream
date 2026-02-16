<script setup lang="ts">
definePageMeta({
  layout: "dashboard",
});
const clients = ref([
  {
    id: '29RKASJ',
    name: 'James Brown',
    email: 'james@alignui.com',
    team: 'QA',
    role: 'Admin',
    date: '12-09-2024',
    avatar: 'https://i.pravatar.cc/100?img=1',
  },
  {
    id: '29RKASJ',
    name: 'James Brown',
    email: 'james@alignui.com',
    team: 'QA',
    role: 'Admin',
    date: '12-09-2024',
    avatar: 'https://i.pravatar.cc/100?img=1',
  },
  // Add more clients...
])


</script>

<template>
  <div class="relative mt-4">
    <div class="min-h-screen p-6">
      <div class="flex items-center justify-between mb-6">
        <div>
          <h1 class="text-2xl">Users & Roles</h1>
          <p class="text-sm text-gray-500">Manage all product categories and their nested subcategories from one place.</p>
        </div>
        <div class="">
          <button
            
            class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2 dashboard-create-button"
          >
            <img src="/assets/images/add.png" alt="" class="w-auto" />
            Add new user
          </button>
        </div>
      </div>
      <div
        class="mt-4 bg-white p-4 rounded-[8px] shadow"
      >
          <div class="">
    <div class="flex items-center justify-between mb-6">
      <!-- Left: Title and Subtitle -->
      <div>
        <h6 class="text-lg text-gray-900">Users list</h6>
        <p class="text-sm text-gray-500">View all your users information.</p>
      </div>
       <div class="flex items-center space-x-2">
        <!-- Search -->
         <div class="relative">
          <input type="text" placeholder="Search..."
            class="pl-10 pr-3 py-2 border border-gray border-radius8 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />
          <span class="absolute left-3 top-2.5 text-gray-400"><img src="/assets/images/search.png" alt=""
              class="w-auto" /></span>
          <span class="absolute right-2 top-2.5 text-xs text-gray-500 bg-gray-100 px-1.5 py-0.5 rounded">
            ⌘1
          </span>
        </div>
      </div>


    </div>

    <div class="flex justify-between items-center w-full space-x-4">

      <!-- Search and Sort -->
     
    </div>


    <!-- Table -->
    <div class="overflow-x-auto bg-white rounded-md shadow">
      <table class="min-w-full divide-y divide-gray-200 text-sm">
        <thead>
          <tr class="text-left text-gray-600 text-sm">
            <th class="p-3"><input type="checkbox" /></th>

            <th class="p-3 cursor-pointer group">
              <div class="flex items-center space-x-1">
                <span>Name</span>
                <div class="flex flex-col">
                  <!-- Up arrow -->
                  <svg class="w-2 h-2 text-gray-400 group-hover:text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M5 12l5-5 5 5H5z" />
                  </svg>
                  <!-- Down arrow -->
                  <svg class="w-2 h-2 text-gray-400 group-hover:text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M5 8l5 5 5-5H5z" />
                  </svg>
                </div>
              </div>
            </th>

            <th class="p-3 cursor-pointer group">
              <div class="flex items-center space-x-1">
                <span>Team</span>
                <div class="flex flex-col">
                  <svg class="w-2 h-2 text-gray-400 group-hover:text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M5 12l5-5 5 5H5z" />
                  </svg>
                  <svg class="w-2 h-2 text-gray-400 group-hover:text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M5 8l5 5 5-5H5z" />
                  </svg>
                </div>
              </div>
            </th>

            <th class="p-3 cursor-pointer group">
              <div class="flex items-center space-x-1">
                <span>Role</span>
                <div class="flex flex-col">
                  <svg class="w-2 h-2 text-gray-400 group-hover:text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M5 12l5-5 5 5H5z" />
                  </svg>
                  <svg class="w-2 h-2 text-gray-400 group-hover:text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M5 8l5 5 5-5H5z" />
                  </svg>
                </div>
              </div>
            </th>

            <th class="p-3 cursor-pointer group">
              <div class="flex items-center space-x-1">
                <span>Date Added</span>
                <div class="flex flex-col">
                  <svg class="w-2 h-2 text-gray-400 group-hover:text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M5 12l5-5 5 5H5z" />
                  </svg>
                  <svg class="w-2 h-2 text-gray-400 group-hover:text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M5 8l5 5 5-5H5z" />
                  </svg>
                </div>
              </div>
            </th>

            <th class="p-3 cursor-pointer group">
              <div class="flex items-center space-x-1">
                <span>Action</span>
                <div class="flex flex-col">
                  <svg class="w-2 h-2 text-gray-400 group-hover:text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M5 12l5-5 5 5H5z" />
                  </svg>
                  <svg class="w-2 h-2 text-gray-400 group-hover:text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M5 8l5 5 5-5H5z" />
                  </svg>
                </div>
              </div>
            </th>



          </tr>
        </thead>

        <tbody>
          <tr v-for="(client, index) in clients" :key="index" class="hover:bg-gray-50">
            <td class="p-3"><input type="checkbox" /></td>
            
            <td class="p-3 flex items-center gap-2">
              <img :src="client.avatar" alt="" class="w-8 h-8 rounded-full" />
              <div>
                <div class="font-medium">{{ client.name }}</div>
                <div class="text-xs text-gray-500">{{ client.email }}</div>
              </div>
            </td>
            <td class="p-3">{{ client.team }} </td>
            <td class="p-3 ">{{ client.role }}</td>
            <td class="p-3">{{ client.date }}</td>
            <td><div>
              <img src="/assets/images/blackdots.png" alt="action" />
            </div></td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
 <div class="flex items-center justify-between px-4 py-3 sm:px-6">
  <div class="flex-1 flex justify-between sm:hidden">
    <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
      Previous
    </a>
    <a href="#" class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
      Next
    </a>
  </div>
  <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
    <div>
      <p class="text-sm text-gray-700">
        Page
        <span class="font-medium">2</span>
        of
        <span class="font-medium">16</span>
       
      </p>
    </div>
    <div>
      <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
        <a href="#" class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
          <span class="sr-only">Previous</span>
          <!-- Heroicon: chevron-left -->
          <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M12.707 14.707a1 1 0 01-1.414 0L7.586 11l3.707-3.707a1 1 0 011.414 1.414L10.414 11l2.293 2.293a1 1 0 010 1.414z" clip-rule="evenodd" />
          </svg>
        </a>

        <!-- Page numbers -->
        <a href="#" class="bg-white border-gray-300 text-gray-500 hover:bg-gray-50 relative inline-flex items-center px-4 py-2 border text-sm font-medium">1</a>
        <a href="#" class="bg-indigo-50 border-indigo-500 text-indigo-600 relative inline-flex items-center px-4 py-2 border text-sm font-medium">2</a>
        <a href="#" class="bg-white border-gray-300 text-gray-500 hover:bg-gray-50 relative inline-flex items-center px-4 py-2 border text-sm font-medium">3</a>
        <span class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700">...</span>
        <a href="#" class="bg-white border-gray-300 text-gray-500 hover:bg-gray-50 relative inline-flex items-center px-4 py-2 border text-sm font-medium">10</a>

        <!-- Next Button -->
        <a href="#" class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
          <span class="sr-only">Next</span>
          <!-- Heroicon: chevron-right -->
          <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 11 7.293 7.707a1 1 0 011.414-1.414L12.414 11l-3.707 3.707a1 1 0 01-1.414 0z" clip-rule="evenodd" />
          </svg>
        </a>
      </nav>
    </div>
  </div>
</div>

  </div>
      </div>
    </div>
  </div>
</template>
