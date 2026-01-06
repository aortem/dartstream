<template>
  <div class="mt-3">
    <div class="flex gap-1 mb-1">
      <label class="block font-medium">Name</label>
      
        <img src="/assets/images/ionic.png" alt="" class="h-5 w-5" />
    </div>
    <select class="w-full border-gray rounded-[8px] px-3 py-2 ">
      <option>Enable new ui</option>
    </select>
  </div>

  <div class="mt-3">
    <div class="flex  mb-1">
      <label class="block font-medium">Key</label>
    
       <img src="/assets/images/ionic.png" alt="" class="h-5 w-5" />
    </div>
    <select class="w-full border-gray rounded-[8px] px-3 py-2 text-gray-600">
      <option>enable-new-ui</option>
    </select>
  </div>
  <div class="mt-3">
    <label class="block font-medium">
      Description <span class="text-red-600">*</span></label
    >
    <textarea
      class="w-full border-gray rounded-[8px] px-3 py-2"
      placeholder="Message..."
      maxlength="600"
    ></textarea>
  </div>
  <div class="my-5 border-t border-gray-200"></div>
  <div class="mt-4">
    <div class="w-full">
      <p class="semibold">Custome properties</p>
      <p class="text-gray-400 text-sm">
        Custom properties are used to associate feature flags with our
        integrations.
      </p>
    </div>
  </div>
  <div class="mt-4 mb-5">
    <buttton
      class="border bg-[#F5F7FA] border-gray rounded-[8px] w-full p-3 flex justify-center gap-3 rounded mt-1 text-gray-600 text-sm text-center"
    >
      <img src="/assets/images/grayadd.png" alt="" class="w-auto" /> Add custom
      property
    </buttton>
  </div>
</template>
