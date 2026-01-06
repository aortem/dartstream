<template>
  <div class="min-h-screen flex">
    <SuccessDeactivateAccount v-if="showSuccessDeactivateAccountModal" :message="message" :button-text="buttonText" @close="toggleDeactivationModal" />

    <!-- Left Image Column -->
    <div class="hidden lg:flex lg:w-6/12 bg-indigo-500">
      <div class="flex items-center justify-center w-full">
        <img
          src="/assets/images/login-bg.svg"
          alt="Signup Image"
          class="w-full h-full object-cover"
        />
      </div>
    </div>

    <!-- Right Column: Logo + Email + Form -->
    <div class="flex flex-col w-full lg:w-6/12 sm:px-6 lg:px-8">
      <!-- Logo + Email Top Row -->
      <div
        class="flex items-center justify-between w-full px-4 sm:px-6 lg:px-8 py-4"
      >
        <img class="h-12 w-auto" src="/assets/images/logo.png" alt="Workflow" />
        <p class="text-sm text-gray-600 flex items-center">
          <!-- <NuxtIcon name="mdi-lock" class="mr-1" /> -->
          App Support
        </p>
      </div>

      <!-- Centered Form Content -->
      <div
        class="flex flex-col justify-center items-start flex-grow px-4 sm:px-6 lg:px-8"
      >
        <div class="w-full max-w-md space-y-8">
          <!-- Heading -->
          <div>
            <div>
              <svg
                width="96"
                height="97"
                viewBox="0 0 96 97"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M0 48.2921C0 21.7824 21.4903 0.292084 48 0.292084C74.5097 0.292084 96 21.7824 96 48.2921C96 74.8018 74.5097 96.2921 48 96.2921C21.4903 96.2921 0 74.8018 0 48.2921Z"
                  fill="url(#paint0_linear_425_13318)"
                  fill-opacity="0.1"
                />
                <g filter="url(#filter0_d_425_13318)">
                  <path
                    d="M16 48.2921C16 30.619 30.3269 16.2921 48 16.2921C65.6731 16.2921 80 30.619 80 48.2921C80 65.9652 65.6731 80.2921 48 80.2921C30.3269 80.2921 16 65.9652 16 48.2921Z"
                    fill="white"
                  />
                  <path
                    d="M48 16.7921C65.397 16.7921 79.5 30.8951 79.5 48.2921C79.5 65.6891 65.397 79.7921 48 79.7921C30.603 79.7921 16.5 65.6891 16.5 48.2921C16.5 30.8951 30.603 16.7921 48 16.7921Z"
                    stroke="#E1E4EA"
                  />
                  <path
                    d="M38.4 60.2921C38.4 57.746 39.4115 55.3042 41.2118 53.5038C43.0121 51.7035 45.4539 50.6921 48 50.6921C50.5461 50.6921 52.9879 51.7035 54.7882 53.5038C56.5886 55.3042 57.6 57.746 57.6 60.2921H55.2C55.2 58.3825 54.4415 56.5512 53.0912 55.2009C51.7409 53.8506 49.9096 53.0921 48 53.0921C46.0905 53.0921 44.2591 53.8506 42.9089 55.2009C41.5586 56.5512 40.8 58.3825 40.8 60.2921H38.4ZM48 49.4921C44.022 49.4921 40.8 46.2701 40.8 42.2921C40.8 38.3141 44.022 35.0921 48 35.0921C51.978 35.0921 55.2 38.3141 55.2 42.2921C55.2 46.2701 51.978 49.4921 48 49.4921ZM48 47.0921C50.652 47.0921 52.8 44.9441 52.8 42.2921C52.8 39.6401 50.652 37.4921 48 37.4921C45.348 37.4921 43.2 39.6401 43.2 42.2921C43.2 44.9441 45.348 47.0921 48 47.0921Z"
                    fill="#525866"
                  />
                </g>
                <defs>
                  <filter
                    id="filter0_d_425_13318"
                    x="14"
                    y="15.2921"
                    width="68"
                    height="68"
                    filterUnits="userSpaceOnUse"
                    color-interpolation-filters="sRGB"
                  >
                    <feFlood flood-opacity="0" result="BackgroundImageFix" />
                    <feColorMatrix
                      in="SourceAlpha"
                      type="matrix"
                      values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0"
                      result="hardAlpha"
                    />
                    <feOffset dy="1" />
                    <feGaussianBlur stdDeviation="1" />
                    <feComposite in2="hardAlpha" operator="out" />
                    <feColorMatrix
                      type="matrix"
                      values="0 0 0 0 0.0392157 0 0 0 0 0.0509804 0 0 0 0 0.0784314 0 0 0 0.03 0"
                    />
                    <feBlend
                      mode="normal"
                      in2="BackgroundImageFix"
                      result="effect1_dropShadow_425_13318"
                    />
                    <feBlend
                      mode="normal"
                      in="SourceGraphic"
                      in2="effect1_dropShadow_425_13318"
                      result="shape"
                    />
                  </filter>
                  <linearGradient
                    id="paint0_linear_425_13318"
                    x1="48"
                    y1="0.292084"
                    x2="48"
                    y2="96.2921"
                    gradientUnits="userSpaceOnUse"
                  >
                    <stop stop-color="#717784" />
                    <stop offset="1" stop-color="#717784" stop-opacity="0" />
                  </linearGradient>
                </defs>
              </svg>
            </div>
            <h5 class="mt-6 text-3xl text-gray-900">Login to your account</h5>
            <p class="mt-2 text-sm text-gray-600">
              Enter your details to login.
            </p>
          </div>

          <!-- Form -->
          <form class="mt-8 space-y-8" @submit.prevent="onSubmit">
            <input type="hidden" name="remember" value="true" />
            <div class="rounded-md shadow-sm space-y-4">
              <div>
                <label
                  for="email-address"
                  class="flex items-center gap-1 text-[14px] leading-[20px] font-medium text-gray-700 tracking-[-0.006em] font-inter"
                >
                  Email Address<span class="text-red-500">*</span
                  ><img
                    src="/assets/images/ionic.png"
                    alt="info"
                    class="w-4 h-4"
                  />
                </label>

                <div class="relative w-[560px] h-[50px]">
                  <span
                    class="absolute inset-y-0 left-3 flex items-center pointer-events-none text-gray-400"
                  >
                    <!-- Email SVG icon -->
                    <svg
                      width="16"
                      height="13"
                      viewBox="0 0 16 13"
                      fill="none"
                      xmlns="http://www.w3.org/2000/svg"
                    >
                      <path
                        d="M1.25 0.0420837H14.75C14.9489 0.0420837 15.1397 0.121101 15.2803 0.261754C15.421 0.402406 15.5 0.593171 15.5 0.792084V11.7921C15.5 11.991 15.421 12.1818 15.2803 12.3224C15.1397 12.4631 14.9489 12.5421 14.75 12.5421H1.25C1.05109 12.5421 0.860322 12.4631 0.71967 12.3224C0.579018 12.1818 0.5 11.991 0.5 11.7921V0.792084C0.5 0.593171 0.579018 0.402406 0.71967 0.261754C0.860322 0.121101 1.05109 0.0420837 1.25 0.0420837ZM14 3.22058L8.054 8.54558L2 3.20408V11.0421H14V3.22058ZM2.38325 1.54208L8.04575 6.53858L13.6265 1.54208H2.38325Z"
                        fill="#99A0AE"
                      />
                    </svg>
                  </span>

                  <input
                    v-model="form.email"
                    id="email-address"
                    name="email"
                    type="email"
                    data-cy = "input-email"
                    autocomplete="email"
                    required
                    placeholder="hello@alignui.com"
                    class="appearance-none block w-full h-full rounded-[10px] border border-gray-300 pl-10 pr-[10px] pt-[15px] pb-[15px] text-gray-900 placeholder-gray-500 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                  />
                </div>
              </div>
              <div>
                <!-- Label -->
                <label
                  for="password"
                  class="flex items-center gap-1 text-[14px] leading-[20px] font-medium text-gray-700 tracking-[-0.006em] font-inter"
                >
                  Password<span class="text-red-500">*</span>
                </label>

                <!-- Input Wrapper -->
                <div class="relative w-[560px] h-[50px]">
                  <!-- Left Lock Icon -->
                  <span
                    class="absolute inset-y-0 left-3 flex items-center pointer-events-none text-gray-400"
                  >
                    <!-- [LOCK ICON] -->
                    <!-- ... (unchanged SVG) -->
                    <svg
                      width="20"
                      height="21"
                      viewBox="0 0 20 21"
                      fill="none"
                      xmlns="http://www.w3.org/2000/svg"
                    >
                      <path
                        d="M5.5 7.29208V6.54208C5.5 5.34861 5.97411 4.20402 6.81802 3.3601C7.66193 2.51619 8.80653 2.04208 10 2.04208C11.1935 2.04208 12.3381 2.51619 13.182 3.3601C14.0259 4.20402 14.5 5.34861 14.5 6.54208V7.29208H16C16.1989 7.29208 16.3897 7.3711 16.5303 7.51175C16.671 7.65241 16.75 7.84317 16.75 8.04208V17.0421C16.75 17.241 16.671 17.4318 16.5303 17.5724C16.3897 17.7131 16.1989 17.7921 16 17.7921H4C3.80109 17.7921 3.61032 17.7131 3.46967 17.5724C3.32902 17.4318 3.25 17.241 3.25 17.0421V8.04208C3.25 7.84317 3.32902 7.65241 3.46967 7.51175C3.61032 7.3711 3.80109 7.29208 4 7.29208H5.5ZM15.25 8.79208H4.75V16.2921H15.25V8.79208ZM9.25 13.0911C8.96404 12.926 8.74054 12.6711 8.61418 12.3661C8.48782 12.061 8.46565 11.7228 8.55111 11.4038C8.63657 11.0849 8.82489 10.803 9.08686 10.602C9.34882 10.401 9.6698 10.292 10 10.292C10.3302 10.292 10.6512 10.401 10.9131 10.602C11.1751 10.803 11.3634 11.0849 11.4489 11.4038C11.5344 11.7228 11.5122 12.061 11.3858 12.3661C11.2595 12.6711 11.036 12.926 10.75 13.0911V14.7921H9.25V13.0911ZM7 7.29208H13V6.54208C13 5.74643 12.6839 4.98337 12.1213 4.42076C11.5587 3.85815 10.7956 3.54208 10 3.54208C9.20435 3.54208 8.44129 3.85815 7.87868 4.42076C7.31607 4.98337 7 5.74643 7 6.54208V7.29208Z"
                        fill="#99A0AE"
                      />
                    </svg>
                  </span>

                  <!-- Password Input -->
                  <!-- <input id="password" name="password" :type="showPassword ? 'text' : 'password'"
                    v-model="form.password" placeholder="........" autocomplete="password" :class="[
                      'appearance-none block w-full h-full rounded-[10px] border pl-10 pr-10 pt-[15px] pb-[15px] text-gray-900 placeholder-gray-500 focus:outline-none focus:ring-2 sm:text-sm',
                      errors.password ? 'border-red-500 ring-red-500 focus:border-red-500' : 'border-gray-300 focus:ring-indigo-500 focus:border-indigo-500'
                    ]" required /> -->
                  <input
                    v-model="form.password"
                    id="password"
                    name="password"
                    :type="showPassword ? 'text' : 'password'"
                    autocomplete="password"
                    data-cy="input-password"
                    required
                    placeholder="........"
                    class="appearance-none block w-full h-full rounded-[10px] border border-gray-300 pl-10 pr-10 pt-[15px] pb-[15px] text-gray-900 placeholder-gray-500 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                  />

                  <!-- Right Eye Icon -->
                  <button
                    type="button"
                    @click="togglePassword"
                    class="absolute inset-y-0 right-3 flex items-center text-gray-400 focus:outline-none"
                  >
                    <svg
                      v-if="!showPassword"
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-5 w-5"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                      stroke-width="2"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                      />
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                      />
                    </svg>
                    <svg
                      v-else
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-5 w-5"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                      stroke-width="2"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M13.875 18.825A10.05 10.05 0 0112 19c-4.477 0-8.268-2.943-9.542-7a9.964 9.964 0 013.64-4.568m3.235-1.462A9.956 9.956 0 0112 5c4.478 0 8.268 2.943 9.542 7a9.968 9.968 0 01-1.357 2.572M15 12a3 3 0 11-6 0 3 3 0 016 0zM3 3l18 18"
                      />
                    </svg>
                  </button>
                </div>
              </div>
            </div>
            <div class="w-[560px] flex justify-end text-sm mt-1">
              <NuxtLink to="/auth/forgot" class="text-[#42489E] hover:underline"
                >Forgot Password?</NuxtLink
              >
            </div>

            <div class="space-y-4">
              <button
                type="submit"
                data-cy="button-login"

                class="w-[560px] h-12 flex justify-center items-center py-[14px] px-[10px] border text-sm font-medium rounded-[10px] text-white bg-[#42489E] hover:bg-[#373c89] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#42489E]"
              >
                Login
              </button>
            </div>
          </form>
          <!-- Auth links section -->
          <div class="mt-4 w-[560px] mx-auto">
            <div class="flex justify-center text-sm">
              <span class="px-2 text-gray-500">
                Don't have an account?
                <NuxtLink
                  to="/auth/register"
                  class="text-[#42489E] hover:underline"
                  >Sign Up</NuxtLink
                >
              </span>
            </div>

            <!-- Use tighter margin here -->
            <div class="flex justify-center text-sm mt-1">
              <span class="px-2 text-gray-500">Or login with</span>
            </div>
          </div>

          <div class="space-y-3 max-w-[560px] w-full">
            <!-- Google Button -->
            <button
              @click="signInWithGoogle"
              class="w-[560px] h-[52px] flex items-center justify-center gap-2.5 px-[12px] pr-[10px] py-[15px] border border-gray-300 rounded-[10px] text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              <!-- Inline SVG (GoogleIcon) -->
              <svg
                width="23"
                height="23"
                viewBox="0 0 23 23"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <g clip-path="url(#clip0_425_13334)">
                  <g clip-path="url(#clip1_425_13334)">
                    <path
                      d="M22.2663 11.5393C22.2663 10.8152 22.2021 10.1277 22.0921 9.4585H11.7338V13.5927H17.6646C17.3988 14.9493 16.6196 16.0952 15.4646 16.8743V19.6243H19.0029C21.0746 17.7085 22.2663 14.8852 22.2663 11.5393Z"
                      fill="#4285F4"
                    />
                    <path
                      d="M11.7336 22.2921C14.7036 22.2921 17.1878 21.3021 19.0028 19.6246L15.4645 16.8746C14.4745 17.5346 13.2186 17.938 11.7336 17.938C8.86447 17.938 6.43531 16.0038 5.56447 13.3913H1.91614V16.2238C3.72197 19.8171 7.43447 22.2921 11.7336 22.2921Z"
                      fill="#34A853"
                    />
                    <path
                      d="M5.56448 13.3909C5.33531 12.7309 5.21614 12.025 5.21614 11.2917C5.21614 10.5584 5.34448 9.85255 5.56448 9.19255V6.36005H1.91614C1.16448 7.84505 0.733643 9.51338 0.733643 11.2917C0.733643 13.07 1.16448 14.7384 1.91614 16.2234L5.56448 13.3909Z"
                      fill="#FBBC05"
                    />
                    <path
                      d="M11.7336 4.64625C13.3561 4.64625 14.8045 5.20542 15.9503 6.29625L19.0853 3.16125C17.1878 1.38292 14.7036 0.292084 11.7336 0.292084C7.43447 0.292084 3.72197 2.76709 1.91614 6.36042L5.56447 9.19292C6.43531 6.58042 8.86447 4.64625 11.7336 4.64625Z"
                      fill="#EA4335"
                    />
                  </g>
                </g>
                <defs>
                  <clipPath id="clip0_425_13334">
                    <rect
                      width="22"
                      height="22"
                      fill="white"
                      transform="translate(0.5 0.292084)"
                    />
                  </clipPath>
                  <clipPath id="clip1_425_13334">
                    <rect
                      width="22"
                      height="22"
                      fill="white"
                      transform="translate(0.5 0.292084)"
                    />
                  </clipPath>
                </defs>
              </svg>

              <span>Google</span>
            </button>

            <!-- Apple Button -->
            <!-- <button
              class="w-[560px] h-[52px] flex items-center justify-center gap-2.5 px-[12px] pr-[10px] py-[15px] border border-gray-300 rounded-[10px] text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              <svg width="22" height="23" viewBox="0 0 22 23" fill="none" xmlns="http://www.w3.org/2000/svg"
                xmlns:xlink="http://www.w3.org/1999/xlink">
                <rect y="0.292084" width="22" height="22" fill="url(#pattern0_425_13338)" />
                <defs>
                  <pattern id="pattern0_425_13338" patternContentUnits="objectBoundingBox" width="1" height="1">
                    <use xlink:href="#image0_425_13338" transform="scale(0.02)" />
                  </pattern>
                  <image id="image0_425_13338" width="50" height="50" preserveAspectRatio="none"
                    xlink:href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAAsTAAALEwEAmpwYAAACS0lEQVR4nO2aTUgVURSAv3wRhq7SlMoQI6OfjZEUFSikRATWto0ErVqEtQhq50ppY4t+tkWBG38SAluJJVht+ltGCIW/i6hEqoXmu3HhBCIzj2f3zpy54gdn9w7MN3Pm3HvuPNBnL9AG7CJASoBLwFvASJwkMOwTeLVC4F8cJCAOADMREvNAjkCoBGYjJGwMEBB9MRJBvR+HgXyMxBAB8SBGYhKoICCmIiS+htapKiMkPgCHCIxtqwSuAlvIGDlgP9AEHC9Q7/uA6pj8eulaJ4A9wCZS5AwwCCysKpm8rNpX5ElEsRO4DDwFfkaU3RzwCGhOUsDe2bEC68HK+C0X1A6cAq4Dz4HlIvMNMJzEZvJczB1MOqZ9NobzwJKChJGw7bvKVcL2+l+KEgb4AZx2kbAd5LWyxIR0NifOKkvMAbV4YFRRIg+0+JCwi9sfRZF+PHFBuayO+hLpVpSY9rlVGVAUGcIjI4oi932KjCuK3PUpotl6h32KPFEU+eJT5J6iiAGO+RLpUBZ56EukWVlkWcZnZ8qUZxAjO1/nOUS7BRuJd8AOV5GbGRAxsmWxBx7/Td0aDwuSjh4XmWcZEDASF11E2jIgYGRuL3cRsaeBnzMg0sU6GLIWgO144oWiyDU80qA0w78HNuOZzpQlFoFGEiCXcondIEHsS/cpBYlB+YdEotTFfPiPCvu7N7Jn+lZkzktgKylRU6DMPkpZ7I7Ia5SZ/HtM7mPZeaeKPXtqBW4DvcAtmWOKOZMqlfXpjuTac7QjKVzzBhuwBv4C1UlE5bkoRY0AAAAASUVORK5CYII=" />
                </defs>
              </svg>

              <span>Apple</span>
            </button> -->

            <!-- GitHub Button -->
            <button  @click="signInWithGitHub"
              class="w-[560px] h-[52px] flex items-center justify-center gap-2.5 px-[12px] pr-[10px] py-[15px] border border-gray-300 rounded-[10px] text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              <svg
                width="20"
                height="21"
                viewBox="0 0 20 21"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
                xmlns:xlink="http://www.w3.org/1999/xlink"
              >
                <rect
                  y="0.292084"
                  width="20"
                  height="20"
                  fill="url(#pattern0_425_13342)"
                />
                <defs>
                  <pattern
                    id="pattern0_425_13342"
                    patternContentUnits="objectBoundingBox"
                    width="1"
                    height="1"
                  >
                    <use
                      xlink:href="#image0_425_13342"
                      transform="scale(0.02)"
                    />
                  </pattern>
                  <image
                    id="image0_425_13342"
                    width="50"
                    height="50"
                    preserveAspectRatio="none"
                    xlink:href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAAsTAAALEwEAmpwYAAADDElEQVR4nO2ZSWgUQRSGv0SiqIkLRhSi4oYQBD0IYq7iJfEUiHEDDy4HQUEQXKKHXNSgCAZxCXrwIG4xYDB68eLFgyC4xYu4BJOD4gYacYuOPHiBoenuququngTpDwoGuuf99ddU1XtVAzk5OTmOjAHqgBagC3gGfAJ+aZPPvfpM3lkBlDOKmA20AQNAwbH1A0eAWSNpYDrQAfxMYCDYJMYZoLrUJjYAHz0YCLYPwLpSGKgAzmVgINjOqlYmTABul8BEQdst1fRKRYlNFLTdAcb6NFKK6RTVZBPwwsYYkavANuA08DlFZ58CrcAm4E3I87U+tti43am26N1JmhP+OBh4BzQCZUVxWkPeew9MS2Okw9AR6XwQGb1rwHZgGVADjAOqgIXASu1sNzAn5PtbI7ROpcnYpmRXiX82R2j9SFoBtFlMjeKp5YvWGD2Zuk6Uax1kMiIZ3jfdMXoDWpxaU2e5WLMwctOgudwlWIuFCdl6s2CmYafc5xKsy2BCNoG5ZMeeGO1Ol0C9BiM9ZEs1MBSh/cQlkKlE3032PIzQluRojSl/rCd7emLyiTWDBiOSfbPmboS29M2a1wYjzokpAf0R2n0uQe4bjDgtuAQsjdF+4BLoukUeWZ2dDy7H6EpBas1OCyOvgBkZmGgC/sbo7nAJttjCiLRHnhNjE/DdoLnEJWCZZdFY0JOh/ILjUxiYB1yw0OpLcjt50NLIcHurR956i9OcdGa+buNS7f621NifZJSkM98CgV4Cu4AXFqInI0ZPToXPHQepoIlQjt6JaA8Ek5Fr1pPhvRjRK4FzeJAaLTVcjBwnBZND1oqULwv02eMQQengFIvYzQ4m+vXMn4r6kMByKTFcpR7SX+A8cBRosIxbrlPVxkgjnjgRCPzF08XDMQsTh/GIjN5FHztIgC0GE52GtZb4/vdGkciQTqVFKW7O18SYuKT3YZkgo7PXcJvow0h7qf6Wa9DrTt9G+jIuRkOp0su0rx6MDOrCr2QEkQr4QFFOcZnXq3SqTmWUUQtMHOlO5OTk/Mf8A7AmvPgC4k8yAAAAAElFTkSuQmCC"
                  />
                </defs>
              </svg>

              <span>GitHub</span>
            </button>

            <!-- Microsoft Button -->
            <button
              @click="signInWithMicrosoft"
              class="w-[560px] h-[52px] flex items-center justify-center gap-2.5 px-[12px] pr-[10px] py-[15px] border border-gray-300 rounded-[10px] text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              <svg
                width="21"
                height="21"
                viewBox="0 0 21 21"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
                xmlns:xlink="http://www.w3.org/1999/xlink"
              >
                <rect
                  x="0.5"
                  y="0.292084"
                  width="20"
                  height="20"
                  fill="url(#pattern0_425_13346)"
                />
                <defs>
                  <pattern
                    id="pattern0_425_13346"
                    patternContentUnits="objectBoundingBox"
                    width="1"
                    height="1"
                  >
                    <use
                      xlink:href="#image0_425_13346"
                      transform="scale(0.02)"
                    />
                  </pattern>
                  <image
                    id="image0_425_13346"
                    width="50"
                    height="50"
                    preserveAspectRatio="none"
                    xlink:href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAAsTAAALEwEAmpwYAAAA7ElEQVR4nO2ZwQ2EIBBFjSZSB7ajCZ6wLcuQy0IJWIVFcJT7bIi3ZUPCeDG7/yX/amYCb8jEpgEAgJ+AtFxpGTw7WrrPb45WudEqz81k1VrfyFUQsaNlyBp5zWGyM3EzWuXRCOFEJK7WBEe+gKm1YPwS3pEScGSBIwRH/sMRLV0qhp/hyBqx6kjNsGNVtuMAAG7SmtN1JgZ2tpjJTrs4aO8DO17Uy95u0Xcm0o1k4/cqSBA7vq8fv2jE4EQIV6sEHDFwhOBICThi4AjBkRJwxDzMkW6LazoVdsyZ7Q5pn0jFsLOL+p+hAADQPJE3bI1IcFQNCT0AAAAASUVORK5CYII="
                  />
                </defs>
              </svg>

              <span>Microsoft</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>

import {
  signInWithPopup,
  GoogleAuthProvider,
  GithubAuthProvider,
  OAuthProvider,
  signInWithEmailAndPassword
} from 'firebase/auth';
import { ref } from "vue";
// noop: keep file touched for CI; no UI change

import { useRouter } from "vue-router"; 
import { useToast } from "vue-toastification";
import { useAnalytics } from "@/composables/useAnalytics";
import SuccessDeactivateAccount from "../../components/settings/modals/successDeactivateAccount.vue"

const router = useRouter();
const route = useRoute(); // 🔹 ADD
const toast = useToast();

const user = ref(null);
const errorMessage = ref('');

// keep trackSignupLogin; add `track` + `trackPageView` (guarded with optional chaining below)
const { trackSignupLogin, track: mpTrack, trackPageView } = useAnalytics();

const { $firebaseAuth, $api } = useNuxtApp();

const handlePopupSignIn = async (provider) => {
  errorMessage.value = ''; // Clear previous errors
  try {
    // 2. The signInWithPopup function is called
    const result = await signInWithPopup($firebaseAuth, provider);

    // 3. If successful, the user object is available in the result
    user.value = result.user;
    console.log("Sign-in successful. User:", user.value.displayName);

    // 4. Get the ID Token from the user object
    const idToken = await user.value.getIdToken();
    console.log("Successfully retrieved ID Token.");

    // 5. Send the token to your backend API
   const response =  await sendTokenToBackend(idToken, provider.providerId);
   

  } catch (error) {
    // 6. Handle errors, such as the user closing the popup
    if (error.code === 'auth/popup-closed-by-user') {
      errorMessage.value = 'Sign-in cancelled. The popup was closed.';
      console.warn('Popup closed by user.');
    } else {
      
      errorMessage.value = `An error occurred: ${error.message}`;
      console.error("Authentication Error:", error);
    }
    user.value = null;
  }
};

 const signInWithGoogle = () => {
  // 1. A new provider object is created
  const provider = new GoogleAuthProvider();
    provider.setCustomParameters({
    prompt: 'select_account',
  });
  handlePopupSignIn(provider);
};

 const signInWithGitHub = () => {
  const provider = new GithubAuthProvider();
    provider.setCustomParameters({
    prompt: 'select_account',
  });
  handlePopupSignIn(provider);
};

 const signInWithMicrosoft = () => {
  const provider = new OAuthProvider('microsoft.com');
    provider.setCustomParameters({
    prompt: 'select_account',
  });
  handlePopupSignIn(provider);
};


const sendTokenToBackend = async (token, method) => {
   const providerName = method.split('.')[0];
  try {
    const res = await $api("/auth/google", {
          method: "POST",
          body: { idToken : token ,providerName : providerName  },
        });
    

      if (res.token && res.user) {
          useCookie("auth_token", { maxAge: 3600 }).value = res.token;
          localStorage.setItem("auth_token", res.token);
          localStorage.setItem("refresh_token", res.refreshToken);
          localStorage.setItem("auth_user", JSON.stringify(res.user));
          await new Promise((resolve) => setTimeout(resolve, 10));

          const userStatus = await $api("/auth/user-status", { method: "GET" });

          if (userStatus) {
            localStorage.setItem("user_status", JSON.stringify(userStatus));
          }

          // 🔹 ADD: track login (google)
          trackSignupLogin({
            user_id: res.user.id || res.user._id,
            email: res.user.email,
            full_name:
              [res.user.firstName, res.user.lastName].filter(Boolean).join(" ") ||
              res.user.name,
            plan: res.user.plan || "standard",
            user_role: res.user.role || userStatus?.firebaseRole || "user",
            signup_ts: Date.now(),
             method: providerName,
          });

          // 🔹 ADD: success breadcrumb
         mpTrack?.("login_success", { method: providerName }); 

          if (userStatus.firebaseRole == "user" && userStatus.isSandbox) {
            router.push("/dashboard");
          } else {
            router.push("/membership");
          }
          toast.success(`${providerName.charAt(0).toUpperCase() + providerName.slice(1)} Sign-In successful!`);
        }
  } catch (error) {
    console.error(`Failed to send token to backend for ${providerName}:`, error);
     const errorMessage = error.data?.message;
      toast.error(errorMessage);
  }
};



// signin with credential starts
const form = ref({
  email: "",
  password: "",
});

const showPassword = ref(false);
const togglePassword = () => {
  showPassword.value = !showPassword.value;
};

const validateForm = () => {
  const { email, password } = form.value;
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    toast.error("Please enter a valid email address.");
    return false;
  }
  if (!password || password.length < 6) {
    toast.error("Password must be at least 6 characters.");
    return false;
  }
  return true;
};

const onSubmit = async () => {
  if (!validateForm()) return;

  const { email, password } = form.value;

  // 🔹 ADD: breadcrumb for funnels
  mpTrack?.("login_started", { method: "email" });

  // Use Firebase Email/Password to sign in, then send ID token to backend
  try {
    const cred = await signInWithEmailAndPassword($firebaseAuth, email, password)
    const idToken = await cred.user.getIdToken()
    await sendTokenToBackend(idToken, 'password')
    return
  } catch (error) {
    console.error('Firebase sign-in error:', error)
    const code = error?.code || ''
    const map = {
      'auth/invalid-email': 'Please enter a valid email address.',
      'auth/user-disabled': 'Account disabled. Contact support.',
      'auth/user-not-found': 'No account found with this email.',
      'auth/wrong-password': 'Incorrect password. Please try again.',
      'auth/invalid-credential': 'Invalid credentials. Please try again.',
      'auth/too-many-requests': 'Too many attempts. Try again later.',
    }
    toast.error(map[code] || (error?.message || 'Login failed. Please try again.'))
    return
  }

  try {
    const res = await $api("/auth/signin", {
      method: "POST",
      body: { email, password },
    });

    if (res.token && res.user) {
      useCookie("auth_token", { maxAge: 3600 }).value = res.token;
      localStorage.setItem("auth_token", res.token);
      localStorage.setItem("refresh_token", res.refreshToken);
      localStorage.setItem("auth_user", JSON.stringify(res.user));

      await new Promise((resolve) => setTimeout(resolve, 10));
      const userStatus = await $api("/auth/user-status", { method: "GET" });

      if (userStatus) {
        localStorage.setItem("user_status", JSON.stringify(userStatus));
      }

      // 🔹 ADD: track login (email/password)
      trackSignupLogin({
        user_id: res.user.id || res.user._id,
        email: res.user.email,
        full_name:
          [res.user.firstName, res.user.lastName].filter(Boolean).join(" ") ||
          res.user.name,
        plan: res.user.plan || "standard",
        user_role: res.user.role || userStatus?.firebaseRole || "user",
        signup_ts: Date.now(),
        method: "email",
      });

      // 🔹 ADD: success breadcrumb
      mpTrack?.("login_success", { method: "email" });

      if (res.firebaseRole === "admin") {
        router.push("/admin");
      } else {
        router.push(res.isSandbox ? "/dashboard" : "/membership");
      }
      toast.success("Login successful!");
    } else {
      toast.error("Login succeeded but no token or user returned.");
      // 🔹 ADD: failure breadcrumb (edge-case)
      mpTrack?.("login_failed", {
        method: "email",
        reason: "no_token_or_user",
      });
    }
  } catch (error) {
    console.error("Login error:", error?.data || error?.message);
    toast.error(error?.data?.message || "Login failed. Please try again.");

    // 🔹 ADD: failure breadcrumb
    const reason =
      (error?.data?.code || error?.data?.error || error?.status || "unknown") +
      "";
    mpTrack?.("login_failed", { method: "email", reason });
  }
};

// signin with credential ends


const showSuccessDeactivateAccountModal = ref(false);
const message = ref("");
const buttonText = ref("");

const toggleDeactivationModal = () => {
  showSuccessDeactivateAccountModal.value = !showSuccessDeactivateAccountModal.value;
};

onMounted(() => {
  const params = new URLSearchParams(window.location.search);

  const clean = (str) => (str ? str.replace(/^'(.*)'$/, "$1") : "");

  message.value = clean(params.get("message"));
  buttonText.value = clean(params.get("buttonText"));

  // Clear query params from URL
  window.history.replaceState({}, document.title, window.location.pathname);

  if (message.value.length > 0) {
    showSuccessDeactivateAccountModal.value = true;
  }
});



// const signInWithGoogle = () => {
//   if (!window.google || !window.google.accounts?.id) {
//     console.error("Google Identity Services not loaded");
//     return;
//   }

//   // 🔹 ADD: funnel breadcrumb
//   mpTrack?.("login_started", { method: "google" });

//   window.google.accounts.id.initialize({
//     client_id:
//       "811694630640-iv0lftqlvqoeo60losd98gp82si7d3me.apps.googleusercontent.com",
//     callback: async (response) => {
//       try {
//         const idToken = response.credential;
//         const res = await $api("/auth/google", {
//           method: "POST",
//           body: { idToken },
//         });

//         if (res.token && res.user) {
//           useCookie("auth_token", { maxAge: 3600 }).value = res.token;
//           localStorage.setItem("auth_token", res.token);
//           localStorage.setItem("refresh_token", res.refreshToken);
//           localStorage.setItem("auth_user", JSON.stringify(res.user));
//           await new Promise((resolve) => setTimeout(resolve, 10));

//           const userStatus = await $api("/auth/user-status", { method: "GET" });

//           if (userStatus) {
//             localStorage.setItem("user_status", JSON.stringify(userStatus));
//           }

//           // 🔹 ADD: track login (google)
//           trackSignupLogin({
//             user_id: res.user.id || res.user._id,
//             email: res.user.email,
//             full_name:
//               [res.user.firstName, res.user.lastName].filter(Boolean).join(" ") ||
//               res.user.name,
//             plan: res.user.plan || "standard",
//             user_role: res.user.role || userStatus?.firebaseRole || "user",
//             signup_ts: Date.now(),
//             method: "google",
//           });

//           // 🔹 ADD: success breadcrumb
//           mpTrack?.("login_success", { method: "google" });

//           if (userStatus.firebaseRole == "user" && userStatus.isSandbox) {
//             router.push("/dashboard");
//           } else {
//             router.push("/membership");
//           }
//           toast.success("Google Sign-In successful!");
//           // router.push('/dashboard')
//         }
//       } catch (err) {
//         console.error("Sign-In error:", err);
//         toast.error(err?.data?.message || "Sign-in failed");

//         // 🔹 ADD: failure breadcrumb
//         const reason =
//           (err?.data?.code || err?.data?.error || err?.status || "unknown") + "";
//         mpTrack?.("login_failed", { method: "google", reason });
//       }
//     },
//     ux_mode: "popup",
//   });

//   window.google.accounts.id.prompt();
// };

// onMounted(async () => {
//   // 🔹 ADD: SPA page view breadcrumb
//   trackPageView?.({ page: "login" });

//   const scriptId = "google-client-script";
//   if (!document.getElementById(scriptId)) {
//     const script = document.createElement("script");
//     script.id = scriptId;
//     script.src = "https://accounts.google.com/gsi/client";
//     script.async = true;
//     script.defer = true;
//     document.head.appendChild(script);
//   }

//   if (window.location.hash.includes("id_token")) {
//     const hash = window.location.hash.substring(1);
//     const params = new URLSearchParams(hash);
//     const idToken = params.get("id_token");

//     if (!idToken) {
//       toast.error("Microsoft login failed: No token found.");
//       // 🔹 ADD: failure breadcrumb
//       mpTrack?.("login_failed", { method: "microsoft", reason: "no_token" });
//       return;
//     }

//     try {
//       const res = await $api("/auth/microsoft", {
//         method: "POST",
//         body: { idToken },
//       });

//       if (res.token && res.user) {
//         // localStorage.setItem("auth_user", JSON.stringify(res.user)); // 🔸 COMMENTED: duplicate line (set below)
//         useCookie("auth_token", { maxAge: 3600 }).value = res.token;
//         localStorage.setItem("auth_token", res.token);
//         localStorage.setItem("refresh_token", res.refreshToken);
//         localStorage.setItem("auth_user", JSON.stringify(res.user));
//         await new Promise((resolve) => setTimeout(resolve, 10));

//         const userStatus = await $api("/auth/user-status", { method: "GET" });

//         if (userStatus) {
//           localStorage.setItem("user_status", JSON.stringify(userStatus));
//         }

//         // 🔹 ADD: track login (Microsoft)
//         trackSignupLogin({
//           user_id: res.user.id || res.user._id,
//           email: res.user.email,
//           full_name:
//             [res.user.firstName, res.user.lastName].filter(Boolean).join(" ") ||
//             res.user.name,
//           plan: res.user.plan || "standard",
//           user_role: res.user.role || "user",
//           signup_ts: Date.now(),
//           method: "microsoft",
//         });

//         // 🔹 ADD: success breadcrumb
//         mpTrack?.("login_success", { method: "microsoft" });
//       }

//       toast.success("Logged in successfully!");
//       router.push("/"); // go to home/dashboard
//     } catch (err) {
//       console.error("Login error:", err);
//       toast.error(err?.data?.message || "Sign-in failed.");

//       // 🔹 ADD: failure breadcrumb
//       const reason =
//         (err?.data?.code || err?.data?.error || err?.status || "unknown") + "";
//       mpTrack?.("login_failed", { method: "microsoft", reason });
//     } finally {
//       // Clean the hash from URL
//       window.history.replaceState(null, "", route.path);
//     }
//   }
// });

// const MICROSOFT_CLIENT_ID = "634f4c4f-068a-4e85-9b1c-e8b1c677147b";
// const REDIRECT_URI = `${location.origin}/auth/login`;

// // Handle Microsoft Sign-in
// const signInWithMicrosoft = () => {
//   // 🔹 ADD: funnel breadcrumb for MS OAuth entry
//   mpTrack?.("login_started", { method: "microsoft" });

//   const authUrl =
//     "https://login.microsoftonline.com/common/oauth2/v2.0/authorize" +
//     `?client_id=${MICROSOFT_CLIENT_ID}` +
//     "&response_type=id_token" +
//     `&redirect_uri=${encodeURIComponent(REDIRECT_URI)}` +
//     "&scope=openid email profile" +
//     "&response_mode=fragment" +
//     `&nonce=${crypto.randomUUID()}` +
//     `&state=${crypto.randomUUID()}`;

//   window.location.href = authUrl;
// };
</script>
