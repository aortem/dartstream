<script setup lang="ts">

definePageMeta({
  layout: "dashboard",
});

const tabs = ['All', 'Enhanced', 'Enterprise', 'Standard', 'Sandbox']
const selectedTab = ref('All')
const searchQuery = ref('')

const clients = ref([
  {
    id: '29RKASJ',
    name: 'James Brown',
    email: 'james@alignui.com',
    flags: 120,
    spend: '120,203',
    date: '12-09-2024',
    type: 'Enterprise user',
    avatar: 'https://i.pravatar.cc/100?img=1',
  },
  {
    id: '29RKASJ',
    name: 'Sophia Williams',
    email: 'sophia@alignui.com',
    flags: 450,
    spend: '120,203',
    date: '12-09-2024',
    type: 'Standard user',
    avatar: 'https://i.pravatar.cc/100?img=2',
  },
  // Add more clients...
])

const filteredClients = computed(() => {
  return clients.value.filter((client) => {
    return (
      (selectedTab.value === 'All' || client.type.includes(selectedTab.value)) &&
      (searchQuery.value === '' ||
        client.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
        client.email.toLowerCase().includes(searchQuery.value.toLowerCase()))
    )
  })
})
</script>
<template>
  <div class="mt-4 bg-white p-4 rounded-[8px] ">
    <div class="flex items-center justify-between mb-6">
      <!-- Left: Title and Subtitle -->
      <div>
        <h6 class="text-lg text-gray-900">Clients list</h6>
        <p class="text-sm text-gray-500">View all your clients information.</p>
      </div>

      <!-- Right: Export Button -->
      <button class="flex items-center gap-1 w-[89px] h-[41px] px-2 py-2
         rounded-lg border border-gray-200 bg-white 
         shadow-sm text-sm font-medium text-gray-600 
         hover:bg-gray-50">
        <!-- Custom SVG Icon -->
        <svg width="16" height="19" viewBox="0 0 16 19" fill="none" xmlns="http://www.w3.org/2000/svg" class="mr-1">
          <path opacity="0.3"
            d="M8.5659 1.1665H5.83862C3.4816 1.1665 2.30309 1.1665 1.57086 1.89874C0.838623 2.63097 0.838623 3.80948 0.838623 6.1665V12.9847C0.838623 14.3957 0.838623 15.1012 1.06193 15.6647C1.42092 16.5706 2.18012 17.2851 3.1426 17.623C3.7413 17.8332 4.49091 17.8332 5.99014 17.8332C8.61378 17.8332 9.9256 17.8332 10.9733 17.4654C12.6577 16.8741 13.9863 15.6237 14.6145 14.0384C15.0053 13.0523 15.0053 11.8176 15.0053 9.34832V7.22711C15.0053 4.6693 15.0053 3.3904 14.2989 2.50224C14.0965 2.24777 13.8564 2.02186 13.5861 1.83137C12.6424 1.1665 11.2836 1.1665 8.5659 1.1665Z"
            fill="#525866" />
          <path
            d="M12.2274 12.2778C13.7616 12.2778 15.0052 11.0341 15.0052 9.5C15.3756 11.1667 15.3385 15 12.2274 17C11.7645 17.2778 10.0052 17.8333 6.67188 17.8333C8.206 17.8333 9.44965 16.5897 9.44965 15.0556C9.44965 14.5007 9.35244 13.8466 9.49698 13.3072C9.6254 12.8279 9.99978 12.4535 10.4791 12.3251C11.0185 12.1806 11.6726 12.2778 12.2274 12.2778Z"
            fill="white" stroke="#525866" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
          <path
            d="M8.41675 1.1665H8.64402C11.3617 1.1665 12.7205 1.1665 13.6642 1.83137C13.9346 2.02186 14.1746 2.24777 14.377 2.50224C15.0834 3.3904 15.0834 4.6693 15.0834 7.22711V9.34832C15.0834 11.8176 15.0834 13.0523 14.6926 14.0384C14.0644 15.6237 12.7358 16.8741 11.0514 17.4654C10.0037 17.8332 8.69191 17.8332 6.06826 17.8332C4.56904 17.8332 3.81943 17.8332 3.22073 17.623C2.25824 17.2851 1.49904 16.5706 1.14005 15.6647C0.916748 15.1012 0.916748 14.3957 0.916748 12.9847V9.49984"
            stroke="#525866" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
          <path
            d="M15.0833 9.5C15.0833 11.0341 13.8397 12.2778 12.3056 12.2778C11.7507 12.2778 11.0966 12.1806 10.5572 12.3251C10.0779 12.4535 9.70353 12.8279 9.5751 13.3072C9.43056 13.8466 9.52778 14.5007 9.52778 15.0556C9.52778 16.5897 8.28412 17.8333 6.75 17.8333"
            stroke="#525866" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
          <path
            d="M1.75 3.24984C2.15961 2.82842 3.24981 1.1665 3.83333 1.1665M5.91667 3.24984C5.50706 2.82842 4.41686 1.1665 3.83333 1.1665M3.83333 1.1665L3.83333 7.83317"
            stroke="#525866" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
        Export
      </button>

    </div>

    <div class="flex justify-between items-center w-full space-x-4">
      <!-- Filter Group -->
      <div class="flex bg-gray-100 rounded-lg p-1 space-x-1">
        <button class="px-3 py-1.5 text-sm font-medium rounded-md bg-white shadow text-gray-800">All</button>
        <button class="px-3 py-1.5 text-sm text-gray-500 rounded-md hover:bg-white">Enhanced</button>
        <button class="px-3 py-1.5 text-sm text-gray-500 rounded-md hover:bg-white">Enterprise</button>
        <button class="px-3 py-1.5 text-sm text-gray-500 rounded-md hover:bg-white">Standard</button>
        <button class="px-3 py-1.5 text-sm text-gray-500 rounded-md hover:bg-white">Sandbox</button>
      </div>

      <!-- Search and Sort -->
      <div class="flex items-center space-x-2">
        <!-- Search -->
        <div class="relative">
          <input type="text" placeholder="Search..."
            class="pl-9 pr-3 py-1.5 text-sm border border-gray-200 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-gray-300" />
          <svg class="absolute left-2 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" fill="none" stroke="currentColor"
            viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M21 21l-4.35-4.35m0 0A7.5 7.5 0 1116.65 16.65z" />
          </svg>
        </div>

        <!-- Sort Dropdown -->
        <div class="relative">
          <button
            class="flex items-center px-3 py-1.5 text-sm font-medium border border-gray-200 rounded-md text-gray-600 bg-white hover:bg-gray-50 shadow-sm">
            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" d="M3 4h18M4 8h16M5 12h14M6 16h12M7 20h10" />
            </svg>
            Sort by
            <svg class="w-3 h-3 ml-1 text-gray-400" fill="none" stroke="currentColor" stroke-width="2"
              viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
            </svg>
          </button>
        </div>
      </div>
    </div>


    <!-- Table -->
    <div class="overflow-x-auto bg-white rounded-md shadow">
      <table class="min-w-full divide-y divide-gray-200 text-sm">
        <thead>
          <tr class="text-left text-gray-600 text-sm">
            <th class="p-3"><input type="checkbox" /></th>

            <th class="p-3 cursor-pointer group">
              <div class="flex items-center space-x-1">
                <span>Client ID</span>
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
                <span>Client name</span>
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
                <span>Total Feature flags</span>
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
                <span>Total Spend</span>
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
                <span>Registered At</span>
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
                <span>Client type</span>
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
          <tr v-for="(client, index) in filteredClients" :key="index" class="hover:bg-gray-50">
            <td class="p-3"><input type="checkbox" /></td>
            <td class="p-3 text-blue-600 font-medium">#{{ client.id }}</td>
            <td class="p-3 flex items-center gap-2">
              <img :src="client.avatar" alt="" class="w-8 h-8 rounded-full" />
              <div>
                <div class="font-medium">{{ client.name }}</div>
                <div class="text-xs text-gray-500">{{ client.email }}</div>
              </div>
            </td>
            <td class="p-3">{{ client.flags }} Flags</td>
            <td class="p-3 ">${{ client.spend }}</td>
            <td class="p-3">{{ client.date }}</td>
            <td class="p-3">
              <span :class="[
                'text-xs px-2 py-1 rounded-full',
                client.type === 'Enterprise user' ? 'bg-purple-100 text-purple-700' :
                  client.type === 'Standard user' ? 'bg-green-100 text-green-700' :
                    client.type === 'Enhanced user' ? 'bg-blue-100 text-blue-700' :
                      'bg-gray-200 text-gray-600'
              ]">
                {{ client.type }}
              </span>
            </td>
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
</template>
