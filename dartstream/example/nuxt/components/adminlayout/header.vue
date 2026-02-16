<template>
  <header
    class="bg-[#42489E] shadow-md px-6 py-4 flex items-center justify-between"
  >
    <div class="flex items-center space-x-6 w-full max-w-3xl">
      <div class="flex items-center space-x-2">
        <img
          src="/assets/images/header-logo.png"
          alt="Logo"
          class="h-10 w-auto"
        />
      </div>

      <div class="relative w-full max-w-sm">
        <input
          type="text"
          placeholder="Search..."
          class="w-full bg-white/20 text-white placeholder-white rounded-full py-2 px-4 pl-10 focus:outline-none focus:ring-2 focus:ring-white/30"
        />
        <svg
          class="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-white"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          viewBox="0 0 24 24"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M21 21l-4-4m0 0a7 7 0 10-9.9 0 7 7 0 009.9 0z"
          />
        </svg>
      </div>
    </div>

    <div class="flex items-center space-x-6 text-white">
      <div class="relative bg-white/20 p-2 rounded-full">
        <img src="/assets/images/bell.png" alt="" class="w-auto" />

        <!-- <span
          class="absolute top-2 right-2 h-2.5 w-2.5 bg-red-600 rounded-full"
        ></span> -->
      </div>

      <div class="h-7 w-px bg-[#474747]"></div>
<img src="/assets/images/avatar.png" alt="profile" />
      <div class="flex items-center space-x-2">
        <div class="flex flex-col text-white ml-4">
          <div class="flex items-center space-x-2">
            <span class="font-medium " style="font-size: 16px"
              >Sophia Williams</span
            >

            <div
              class="h-5 w-5 text-white rounded-full flex items-center justify-center"
            >
              <img src="/assets/images/verify.png" alt="" class="w-auto" />
            </div>
          </div>

          <span
            class="text-sm "
            style="font-size: 12px"
          >
            sophia@example.com
          </span>
        </div>
      </div>
    </div>
  </header>
</template>
