<template>
  <div class=" ">

    <div class="flex items-center justify-between">
      <div class="flex items-center gap-2">
        <img src="/assets/images/notifyb.png" alt="" class="h-7 w-7" />
        <h2 class="text-lg  text-gray-800">Notifications</h2>
      </div>
    </div>
    <div class="flex items-center justify-between mt-5">
      <div class="flex items-center gap-2">
        <p class="text-md">Notify me when</p>
      </div>
      <a href="#" class="text-sm text-[#42489E] hover:underline"
        >About notifications?</a
      >
    </div>
   
    <div class="">
      <label class="flex items-center space-x-2 mt-3">
        <input
          type="checkbox"
          class="h-5 w-5 rounded border-2 border-[#42489E] checked:border-[#42489E] checked:bg-[#42489E] checked:text-[#42489E] focus:ring-[#42489E]"
          checked
        />
        <span class="text-gray-700 text-sm">New Action</span>
      </label>

      <label class="flex items-center space-x-2 mt-3">
        <input
          type="checkbox"
          class="h-5 w-5 rounded border-2 border-[#42489E] text-[#42489E] bg-indigo-100 focus:ring-[#42489E]"
          checked
        />
        <span class="text-gray-700 text-sm">New environment</span>
      </label>
      <label class="flex items-center space-x-2 mt-3">
        <input
          type="checkbox"
          class="h-5 w-5 rounded border-2 border-gray-200 text-gray-200 bg-gray-200 focus:ring-gray-200"
          disabled
        />
        <span class="text-gray-400 text-sm">New user</span>
      </label>
      <label class="flex items-center space-x-2 mt-3">
        <input
          type="checkbox"
          class="h-5 w-5 rounded border-2 border-[#42489E] text-[#42489E] bg-indigo-100 focus:ring-[#42489E]"
          checked
        />
        <span class="text-gray-700 text-sm">Flags</span>
      </label>
    </div>

   
    <div class="space-y-4 pt-6">
      <div class="flex items-center justify-between border-t pt-4">
        <div>
          <p class="font-medium text-sm text-gray-800">
            Mobile push notifications
          </p>
          <p class="text-xs text-gray-500">
            Receive push notification whenever your organisation requires your
            attentions
          </p>
        </div>
        <label class="inline-flex items-center cursor-pointer">
          <input type="checkbox" value="" class="sr-only peer" checked />
          <div
            class="relative w-11 h-6 bg-gray-200 rounded-full peer-focus:ring-[#42489E] dark:peer-focus:ring-[#42489E] dark:bg-gray-400 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-[#42489E] dark:peer-checked:bg-[#42489E]"
          ></div>
        </label>
      </div>

      <div class="flex items-center justify-between border-t pt-4">
        <div>
          <p class="font-medium text-sm text-gray-800">Desktop notifications</p>
          <p class="text-xs text-gray-500">
            Receive push notification whenever your organisation requires your
            attentions
          </p>
        </div>
        <label class="inline-flex items-center cursor-pointer">
          <input type="checkbox" value="" class="sr-only peer" disabled />
          <div
            class="relative w-11 h-6 bg-gray-200 rounded-full peer-focus:ring-[#42489E] dark:peer-focus:ring-[#42489E] dark:bg-gray-400 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-[#42489E] dark:peer-checked:bg-[#42489E]"
          ></div>
        </label>
      </div>

      <div class="flex items-center justify-between border-t pt-4">
        <div>
          <p class="font-medium text-sm text-gray-800">Email notifications</p>
          <p class="text-xs text-gray-500">
            Receive push notification whenever your organisation requires your
            attentions
          </p>
        </div>
        <label class="inline-flex items-center cursor-pointer">
          <input type="checkbox" value="" class="sr-only peer" checked />
          <div
            class="relative w-11 h-6 bg-gray-200 rounded-full peer-focus:ring-[#42489E] dark:peer-focus:ring-[#42489E] dark:bg-gray-400 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-[#42489E] dark:peer-checked:bg-[#42489E]"
          ></div>
        </label>
      </div>
    </div>
  </div>
</template>
