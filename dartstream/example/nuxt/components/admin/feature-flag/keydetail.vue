<template>
  <div class="border bg-white p-3 w-full max-w-sm space-y-4">
 
    <div class="flex justify-between items-center">
      <label class="block text-sm font-medium text-gray-700">Key</label>
      <div class="">
        <button
          class="mt-2 inline-flex items-center gap-2 bg-white strong-blue-text text-sm px-4 py-2 border border-gray border-radius8 hover:bg-gray-100"
        >
          <img src="/assets/images/copy.png" alt="" class="w-auto" />

          enable-new-ui
        </button>
      </div>
    </div>

   
    <div>
      <label class="block text-sm font-medium text-gray-600">Description</label>
      <div class="mt-2 text-sm">
        Lorem Ipsum is simply dummy text of the printing and typesetting
        industry.
      </div>
    </div>

   
    <div>
      <label class="block text-sm font-medium text-gray-600"
        >API Key / SDK instructions</label
      >
      <div class="rounded mt-1 underline text-sm">Check Instructions</div>
    </div>

   
    <div>
      <label class="block text-sm font-medium text-gray-600"
        >Code references</label
      >
      <div class="p-2 pl-4 rounded mt-1 underline text-sm">Sample-app</div>
    </div>

    
    <div>
      <label class="block text-sm font-medium text-gray-700 mb-1"
        >Variations</label
      >
      <div class="space-y-1">
        <div class="flex items-center gap-2">
          <div class="w-4 h-4 bg-blue-600 rounded-sm"></div>
          <span class="text-sm text-gray-700">On</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-4 h-4 bg-purple-600 rounded-sm"></div>
          <span class="text-sm text-gray-700">Off</span>
        </div>
      </div>
    </div>
    <div class="my-5 border-t border-gray-200"></div>
   
    <div>
      <label class="block text-sm font-medium text-gray-600"
        >Targeting Rules</label
      >
      <button
        class="border bg-[#F5F7FA] border-gray rounded-[8px] w-full p-3 flex justify-center gap-3 rounded mt-1 text-gray-600 text-sm text-center"
      >
        <img src="/assets/images/grayadd.png" alt="" class="w-auto" /> Add new
        rules
      </button>
    </div>
    <div class="my-5 border-t border-gray-200"></div>
   
    <div>
      <div class="flex items-center justify-between mb-1">
        <label class="text-sm font-medium text-gray-600">Scheduling</label>
        <span class="bg-[#344E18] text-white text-xs px-2 py-0.5 rounded-full"
          >Upgrade</span
        >
      </div>
      <div class="p-3 rounded space-y-2 text-sm text-gray-500">
        <div class="w-full">
          <div class="flex gap-2 mb-1">
            <label class="block font-medium text-gray-300">Date</label>
           
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 20 20"
              fill="currentColor"
              class="w-5 h-5 text-gray-300 cursor-pointer"
            >
              <path
                fill-rule="evenodd"
                d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0ZM8.94 6.94a.75.75 0 1 1-1.061-1.061 3 3 0 1 1 2.871 5.026v.345a.75.75 0 0 1-1.5 0v-.5c0-.72.57-1.172 1.081-1.287A1.5 1.5 0 1 0 8.94 6.94ZM10 15a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z"
                clip-rule="evenodd"
              />
            </svg>
          </div>
          <select class="w-full border rounded-[8px] px-3 py-3 text-gray-300">
            <option>12/02/205</option>
          </select>
        </div>

        <div class="w-full">
          <div class="flex gap-2 mb-1">
            <label class="block font-medium text-gray-300">Time</label>
           
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 20 20"
              fill="currentColor"
              class="w-5 h-5 text-gray-300 cursor-pointer"
            >
              <path
                fill-rule="evenodd"
                d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0ZM8.94 6.94a.75.75 0 1 1-1.061-1.061 3 3 0 1 1 2.871 5.026v.345a.75.75 0 0 1-1.5 0v-.5c0-.72.57-1.172 1.081-1.287A1.5 1.5 0 1 0 8.94 6.94ZM10 15a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z"
                clip-rule="evenodd"
              />
            </svg>
          </div>
          <select class="w-full border rounded-[8px] px-3 py-3 text-gray-300">
            <option>12:20 PM</option>
          </select>
        </div>
      </div>
    </div>
    <div class="my-5 border-t border-gray-200"></div>
  
    <div>
      <div class="flex items-center justify-between mb-5">
        <label class="text-sm font-medium text-gray-600">Audit Log</label>
        <span class="bg-[#344E18] text-white text-xs px-2 py-0.5 rounded-full"
          >Coming soon</span
        >
      </div>
    </div>
  </div>
</template>
