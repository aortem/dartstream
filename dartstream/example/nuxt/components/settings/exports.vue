<template>
  <div class="">
    <div class="flex gap-2">
      <img src="/assets/images/timer.png" alt="" class="h-7 w-7" />
      <h2 class="text-2xl mb-6">Export & Backups</h2>
    </div>
    <div class="mt-5">
      <div class="">
        <label class="block mb-1 text-sm font-medium flex">Export </label>
        <label class="flex items-center space-x-2 mt-3">
          <input
            type="checkbox"
            class="h-4 w-4 rounded border-2 border-[#42489E] checked:border-[#42489E] checked:bg-[#42489E] checked:text-[#42489E] focus:ring-[#42489E]"
            checked
          />
          <span class="text-gray-700 text-sm">Flags</span>
        </label>

        <label class="flex items-center space-x-2 mt-3">
          <input
            type="checkbox"
            class="h-4 w-4 rounded border-2 border-[#42489E] text-[#42489E] bg-indigo-100 focus:ring-[#42489E]"
            checked
          />
          <span class="text-gray-700 text-sm">Users</span>
        </label>
        <label class="flex items-center space-x-2 mt-3">
          <input
            type="checkbox"
            class="h-4 w-4 rounded border-2 border-gray-200 text-gray-200 bg-gray-200 focus:ring-gray-200"
            disabled
          />
          <span class="text-gray-400 text-sm">SDK settings</span>
        </label>
      </div>
      <div class="mt-4">
        <label class="block mb-1 text-sm font-medium flex"
          >Export formats
          <img src="/assets/images/ionic.png" alt="" class="h-5 w-5" />
        </label>
        <select
          class="w-full border rounded-[8px] px-3 py-3 text-[#0E121B] relative"
        >
          <option>CSV</option>
        </select>
      </div>
      <div class="mt-4">
        <label class="block mb-1 text-sm font-medium flex"
          >Backup frequency
          <img src="/assets/images/ionic.png" alt="" class="h-5 w-5" />
        </label>
        <select
          class="w-full border rounded-[8px] px-3 py-3 text-[#0E121B] relative"
        >
          <option>Weekly</option>
        </select>
      </div>
      <div class="w-full mt-5">
        <button
          type="button"
          class="px-4 py-2 w-full border flex gap-3 justify-center rounded-[8px] text-black bg-[#F5F7FA]"
        >
          Request full org backup
        </button>
      </div>
    </div>
  </div>
</template>
