<template>
  <div class="min-h-screen flex">
    <SuccessDeactivateAccount v-if="showSuccessDeactivateAccountModal" :message="message" :button-text="buttonText" @close="toggleDeactivationModal" />

    <!-- Left Image Column -->
    <div class="hidden lg:flex lg:w-6/12 bg-indigo-500">
      <div class="flex items-center justify-center w-full">
        <img src="/assets/images/login-bg.svg" alt="Signup Image" class="w-full h-full object-cover" />
      </div>
    </div>

    <!-- Right Column: Logo + Email + Form -->
    <div class="flex flex-col w-full lg:w-6/12 sm:px-6 lg:px-8">
      <!-- Top Row -->
      <div class="flex items-center justify-between w-full px-4 sm:px-6 lg:px-8 py-4">
        <img class="h-12 w-auto" src="/assets/images/logo.png" alt="Workflow" />
        <p class="text-sm text-gray-600">App Support</p>
      </div>

      <!-- Centered Form Content -->
      <div class="flex flex-col justify-center items-start flex-grow px-4 sm:px-6 lg:px-8">
        <div class="w-full max-w-[560px] space-y-8">
          <!-- Heading -->
          <div>
            <!-- Circle SVG Icon -->
            <svg width="96" height="97" viewBox="0 0 96 97" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path
                d="M0 48.2921C0 21.7824 21.4903 0.292084 48 0.292084C74.5097 0.292084 96 21.7824 96 48.2921C96 74.8018 74.5097 96.2921 48 96.2921C21.4903 96.2921 0 74.8018 0 48.2921Z"
                fill="url(#paint0_linear_425_13318)" fill-opacity="0.1" />
              <g filter="url(#filter0_d_425_13318)">
                <path
                  d="M16 48.2921C16 30.619 30.3269 16.2921 48 16.2921C65.6731 16.2921 80 30.619 80 48.2921C80 65.9652 65.6731 80.2921 48 80.2921C30.3269 80.2921 16 65.9652 16 48.2921Z"
                  fill="white" />
                <path
                  d="M48 16.7921C65.397 16.7921 79.5 30.8951 79.5 48.2921C79.5 65.6891 65.397 79.7921 48 79.7921C30.603 79.7921 16.5 65.6891 16.5 48.2921C16.5 30.8951 30.603 16.7921 48 16.7921Z"
                  stroke="#E1E4EA" />
                <path
                  d="M38.4 60.2921C38.4 57.746 39.4115 55.3042 41.2118 53.5038C43.0121 51.7035 45.4539 50.6921 48 50.6921C50.5461 50.6921 52.9879 51.7035 54.7882 53.5038C56.5886 55.3042 57.6 57.746 57.6 60.2921H55.2C55.2 58.3825 54.4415 56.5512 53.0912 55.2009C51.7409 53.8506 49.9096 53.0921 48 53.0921C46.0905 53.0921 44.2591 53.8506 42.9089 55.2009C41.5586 56.5512 40.8 58.3825 40.8 60.2921H38.4ZM48 49.4921C44.022 49.4921 40.8 46.2701 40.8 42.2921C40.8 38.3141 44.022 35.0921 48 35.0921C51.978 35.0921 55.2 38.3141 55.2 42.2921C55.2 46.2701 51.978 49.4921 48 49.4921ZM48 47.0921C50.652 47.0921 52.8 44.9441 52.8 42.2921C52.8 39.6401 50.652 37.4921 48 37.4921C45.348 37.4921 43.2 39.6401 43.2 42.2921C43.2 44.9441 45.348 47.0921 48 47.0921Z"
                  fill="#525866" />
              </g>
              <defs>
                <filter id="filter0_d_425_13318" x="14" y="15.2921" width="68" height="68" filterUnits="userSpaceOnUse"
                  color-interpolation-filters="sRGB">
                  <feFlood flood-opacity="0" result="BackgroundImageFix" />
                  <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0"
                    result="hardAlpha" />
                  <feOffset dy="1" />
                  <feGaussianBlur stdDeviation="1" />
                  <feComposite in2="hardAlpha" operator="out" />
                  <feColorMatrix type="matrix"
                    values="0 0 0 0 0.0392157 0 0 0 0 0.0509804 0 0 0 0 0.0784314 0 0 0 0.03 0" />
                  <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_425_13318" />
                  <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_425_13318" result="shape" />
                </filter>
                <linearGradient id="paint0_linear_425_13318" x1="48" y1="0.292084" x2="48" y2="96.2921"
                  gradientUnits="userSpaceOnUse">
                  <stop stop-color="#717784" />
                  <stop offset="1" stop-color="#717784" stop-opacity="0" />
                </linearGradient>
              </defs>
            </svg>
            <h5 class="mt-6 text-3xl text-gray-900">Create your account</h5>
            <p class="mt-2 text-sm text-gray-600">Enter your details to register.</p>
          </div>

          <!-- Form -->
          <form class="mt-8 space-y-6" @submit.prevent="onSubmit">
            <input type="hidden" name="remember" value="true" />

            <!-- Email Field -->
            <div>
              <label for="email" class="flex items-center gap-1 text-sm font-medium text-gray-700">
                Email Address <span class="text-red-500">*</span>
                <img src="/assets/images/ionic.png" alt="info" class="w-4 h-4" />
              </label>
              <div class="relative w-full max-w-[560px] h-[50px]">
                <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
                  <!-- Email SVG icon -->
                  <svg width="16" height="13" viewBox="0 0 16 13" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path
                      d="M1.25 0.0420837H14.75C14.9489 0.0420837 15.1397 0.121101 15.2803 0.261754C15.421 0.402406 15.5 0.593171 15.5 0.792084V11.7921C15.5 11.991 15.421 12.1818 15.2803 12.3224C15.1397 12.4631 14.9489 12.5421 14.75 12.5421H1.25C1.05109 12.5421 0.860322 12.4631 0.71967 12.3224C0.579018 12.1818 0.5 11.991 0.5 11.7921V0.792084C0.5 0.593171 0.579018 0.402406 0.71967 0.261754C0.860322 0.121101 1.05109 0.0420837 1.25 0.0420837ZM14 3.22058L8.054 8.54558L2 3.20408V11.0421H14V3.22058ZM2.38325 1.54208L8.04575 6.53858L13.6265 1.54208H2.38325Z"
                      fill="#99A0AE" />
                  </svg>
                </span>
                <!-- data attribute is for cypress test -->
                <input v-model="form.email" id="email" name="email" type="email" required data-cy="input-email"
                  class="block w-full h-full rounded-[10px] border border-gray-300 pl-10 pr-3 text-gray-900 placeholder-gray-500 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  placeholder="hello@alignui.com" />
              </div>
            </div>

            <!-- Password Field -->
            <div>
              <label for="password" class="flex items-center gap-1 text-sm font-medium text-gray-700">
                Password <span class="text-red-500">*</span>
              </label>
              <div class="relative w-full max-w-[560px] h-[50px]">
                <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
                  <!-- lock icon -->
                  <svg width="20" height="21" viewBox="0 0 20 21" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path
                      d="M5.5 7.29208V6.54208C5.5 5.34861 5.97411 4.20402 6.81802 3.3601C7.66193 2.51619 8.80653 2.04208 10 2.04208C11.1935 2.04208 12.3381 2.51619 13.182 3.3601C14.0259 4.20402 14.5 5.34861 14.5 6.54208V7.29208H16C16.1989 7.29208 16.3897 7.3711 16.5303 7.51175C16.671 7.65241 16.75 7.84317 16.75 8.04208V17.0421C16.75 17.241 16.671 17.4318 16.5303 17.5724C16.3897 17.7131 16.1989 17.7921 16 17.7921H4C3.80109 17.7921 3.61032 17.7131 3.46967 17.5724C3.32902 17.4318 3.25 17.241 3.25 17.0421V8.04208C3.25 7.84317 3.32902 7.65241 3.46967 7.51175C3.61032 7.3711 3.80109 7.29208 4 7.29208H5.5ZM15.25 8.79208H4.75V16.2921H15.25V8.79208ZM9.25 13.0911C8.96404 12.926 8.74054 12.6711 8.61418 12.3661C8.48782 12.061 8.46565 11.7228 8.55111 11.4038C8.63657 11.0849 8.82489 10.803 9.08686 10.602C9.34882 10.401 9.6698 10.292 10 10.292C10.3302 10.292 10.6512 10.401 10.9131 10.602C11.1751 10.803 11.3634 11.0849 11.4489 11.4038C11.5344 11.7228 11.5122 12.061 11.3858 12.3661C11.2595 12.6711 11.036 12.926 10.75 13.0911V14.7921H9.25V13.0911ZM7 7.29208H13V6.54208C13 5.74643 12.6839 4.98337 12.1213 4.42076C11.5587 3.85815 10.7956 3.54208 10 3.54208C9.20435 3.54208 8.44129 3.85815 7.87868 4.42076C7.31607 4.98337 7 5.74643 7 6.54208V7.29208Z"
                      fill="#99A0AE" />
                  </svg>
                </span>
                <input v-model="form.password" id="password" name="password" :type="showPassword ? 'text' : 'password'"
                  required data-cy="input-password"
                  class="block w-full h-full rounded-[10px] border border-gray-300 pl-10 pr-10 text-gray-900 placeholder-gray-500 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  placeholder="********" />
                <button type="button" @click="togglePassword"
                  class="absolute inset-y-0 right-3 flex items-center text-gray-400 focus:outline-none">
                  <!-- eye icon -->
                  <svg v-if="!showPassword" id="eyeIcon" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                    viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round"
                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                  </svg>
                  <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round"
                      d="M13.875 18.825A10.05 10.05 0 0112 19c-4.477 0-8.268-2.943-9.542-7a9.964 9.964 0 013.64-4.568m3.235-1.462A9.956 9.956 0 0112 5c4.478 0 8.268 2.943 9.542 7a9.968 9.968 0 01-1.357 2.572M15 12a3 3 0 11-6 0 3 3 0 016 0zM3 3l18 18" />
                  </svg>
                </button>
              </div>
            </div>

            <!-- Confirm Password -->
            <div>
              <label for="confirmPassword" class="flex items-center gap-1 text-sm font-medium text-gray-700">
                Confirm Password <span class="text-red-500">*</span>
              </label>
              <div class="relative w-full max-w-[560px] h-[50px]">
                <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
                  <!-- lock icon -->
                  <svg width="20" height="21" viewBox="0 0 20 21" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path
                      d="M5.5 7.29208V6.54208C5.5 5.34861 5.97411 4.20402 6.81802 3.3601C7.66193 2.51619 8.80653 2.04208 10 2.04208C11.1935 2.04208 12.3381 2.51619 13.182 3.3601C14.0259 4.20402 14.5 5.34861 14.5 6.54208V7.29208H16C16.1989 7.29208 16.3897 7.3711 16.5303 7.51175C16.671 7.65241 16.75 7.84317 16.75 8.04208V17.0421C16.75 17.241 16.671 17.4318 16.5303 17.5724C16.3897 17.7131 16.1989 17.7921 16 17.7921H4C3.80109 17.7921 3.61032 17.7131 3.46967 17.5724C3.32902 17.4318 3.25 17.241 3.25 17.0421V8.04208C3.25 7.84317 3.32902 7.65241 3.46967 7.51175C3.61032 7.3711 3.80109 7.29208 4 7.29208H5.5ZM15.25 8.79208H4.75V16.2921H15.25V8.79208ZM9.25 13.0911C8.96404 12.926 8.74054 12.6711 8.61418 12.3661C8.48782 12.061 8.46565 11.7228 8.55111 11.4038C8.63657 11.0849 8.82489 10.803 9.08686 10.602C9.34882 10.401 9.6698 10.292 10 10.292C10.3302 10.292 10.6512 10.401 10.9131 10.602C11.1751 10.803 11.3634 11.0849 11.4489 11.4038C11.5344 11.7228 11.5122 12.061 11.3858 12.3661C11.2595 12.6711 11.036 12.926 10.75 13.0911V14.7921H9.25V13.0911ZM7 7.29208H13V6.54208C13 5.74643 12.6839 4.98337 12.1213 4.42076C11.5587 3.85815 10.7956 3.54208 10 3.54208C9.20435 3.54208 8.44129 3.85815 7.87868 4.42076C7.31607 4.98337 7 5.74643 7 6.54208V7.29208Z"
                      fill="#99A0AE" />
                  </svg>
                </span>
                <input v-model="form.confirmPassword" id="confirmPassword" name="confirmPassword" data-cy="input-confirm-password"
                  :type="showConfirmPassword ? 'text' : 'password'" required
                  class="block w-full h-full rounded-[10px] border border-gray-300 pl-10 pr-10 text-gray-900 placeholder-gray-500 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  placeholder="********" />
                <button type="button" @click="toggleConfirmPassword"
                  class="absolute inset-y-0 right-3 flex items-center text-gray-400 focus:outline-none">
                  <!-- eye icon -->
                  <svg v-if="!showConfirmPassword" id="confirmEyeIcon" xmlns="http://www.w3.org/2000/svg"
                    class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round"
                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                  </svg>
                  <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round"
                      d="M13.875 18.825A10.05 10.05 0 0112 19c-4.477 0-8.268-2.943-9.542-7a9.964 9.964 0 013.64-4.568m3.235-1.462A9.956 9.956 0 0112 5c4.478 0 8.268 2.943 9.542 7a9.968 9.968 0 01-1.357 2.572M15 12a3 3 0 11-6 0 3 3 0 016 0zM3 3l18 18" />
                  </svg>
                </button>
              </div>
            </div>

            <!-- Submit Button -->
            <button type="submit"
              data-cy="button-submit"
              class="w-full max-w-[560px] h-12 flex items-center justify-center rounded-[10px] bg-[#42489E] text-white hover:bg-[#373c89] focus:ring-2 focus:ring-offset-2 focus:ring-[#42489E] text-sm font-medium">
              Create an Account
            </button>

            <!-- Already have an account -->
            <div class="text-center text-sm text-gray-500">
              Already have an account?
              <NuxtLink to="/auth/login" class="text-[#42489E] hover:underline">Login</NuxtLink>
            </div>
            <div class="text-center text-sm text-gray-500 mt-1">Or create account with</div>
          </form>

          <!-- Social Auth Buttons -->
          <div class="space-y-3 w-full max-w-[560px]">
            <button @click="signInWithGoogle"
              class="flex items-center justify-center w-full h-[52px] gap-2.5 border border-gray-300 rounded-[10px] bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              <!-- Google SVG -->
              <svg width="23" height="23" viewBox="0 0 23 23" fill="none" xmlns="http://www.w3.org/2000/svg">
                <g clip-path="url(#clip0_425_13334)">
                  <g clip-path="url(#clip1_425_13334)">
                    <path
                      d="M22.2663 11.5393C22.2663 10.8152 22.2021 10.1277 22.0921 9.4585H11.7338V13.5927H17.6646C17.3988 14.9493 16.6196 16.0952 15.4646 16.8743V19.6243H19.0029C21.0746 17.7085 22.2663 14.8852 22.2663 11.5393Z"
                      fill="#4285F4" />
                    <path
                      d="M11.7336 22.2921C14.7036 22.2921 17.1878 21.3021 19.0028 19.6246L15.4645 16.8746C14.4745 17.5346 13.2186 17.938 11.7336 17.938C8.86447 17.938 6.43531 16.0038 5.56447 13.3913H1.91614V16.2238C3.72197 19.8171 7.43447 22.2921 11.7336 22.2921Z"
                      fill="#34A853" />
                    <path
                      d="M5.56448 13.3909C5.33531 12.7309 5.21614 12.025 5.21614 11.2917C5.21614 10.5584 5.34448 9.85255 5.56448 9.19255V6.36005H1.91614C1.16448 7.84505 0.733643 9.51338 0.733643 11.2917C0.733643 13.07 1.16448 14.7384 1.91614 16.2234L5.56448 13.3909Z"
                      fill="#FBBC05" />
                    <path
                      d="M11.7336 4.64625C13.3561 4.64625 14.8045 5.20542 15.9503 6.29625L19.0853 3.16125C17.1878 1.38292 14.7036 0.292084 11.7336 0.292084C7.43447 0.292084 3.72197 2.76709 1.91614 6.36042L5.56447 9.19292C6.43531 6.58042 8.86447 4.64625 11.7336 4.64625Z"
                      fill="#EA4335" />
                  </g>
                </g>
                <defs>
                  <clipPath id="clip0_425_13334">
                    <rect width="22" height="22" fill="white" transform="translate(0.5 0.292084)" />
                  </clipPath>
                  <clipPath id="clip1_425_13334">
                    <rect width="22" height="22" fill="white" transform="translate(0.5 0.292084)" />
                  </clipPath>
                </defs>
              </svg>
              <span>Google</span>
            </button>

            <!-- <button
              class="flex items-center justify-center w-full h-[52px] gap-2.5 border border-gray-300 rounded-[10px] bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
               Apple SVG 
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

            <button
              class="flex items-center justify-center w-full h-[52px] gap-2.5 border border-gray-300 rounded-[10px] bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              <!-- GitHub SVG -->
              <svg width="20" height="21" viewBox="0 0 20 21" fill="none" xmlns="http://www.w3.org/2000/svg"
                xmlns:xlink="http://www.w3.org/1999/xlink">
                <rect y="0.292084" width="20" height="20" fill="url(#pattern0_425_13342)" />
                <defs>
                  <pattern id="pattern0_425_13342" patternContentUnits="objectBoundingBox" width="1" height="1">
                    <use xlink:href="#image0_425_13342" transform="scale(0.02)" />
                  </pattern>
                  <image id="image0_425_13342" width="50" height="50" preserveAspectRatio="none"
                    xlink:href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAAsTAAALEwEAmpwYAAADDElEQVR4nO2ZSWgUQRSGv0SiqIkLRhSi4oYQBD0IYq7iJfEUiHEDDy4HQUEQXKKHXNSgCAZxCXrwIG4xYDB68eLFgyC4xYu4BJOD4gYacYuOPHiBoenuququngTpDwoGuuf99ddU1XtVAzk5OTmOjAHqgBagC3gGfAJ+aZPPvfpM3lkBlDOKmA20AQNAwbH1A0eAWSNpYDrQAfxMYCDYJMYZoLrUJjYAHz0YCLYPwLpSGKgAzmVgINjOqlYmTABul8BEQdst1fRKRYlNFLTdAcb6NFKK6RTVZBPwwsYYkavANuA08DlFZ58CrcAm4E3I87U+tti43am26N1JmhP+OBh4BzQCZUVxWkPeew9MS2Okw9AR6XwQGb1rwHZgGVADjAOqgIXASu1sNzAn5PtbI7ROpcnYpmRXiX82R2j9SFoBtFlMjeKp5YvWGD2Zuk6Uax1kMiIZ3jfdMXoDWpxaU2e5WLMwctOgudwlWIuFCdl6s2CmYafc5xKsy2BCNoG5ZMeeGO1Ol0C9BiM9ZEs1MBSh/cQlkKlE3032PIzQluRojSl/rCd7emLyiTWDBiOSfbPmboS29M2a1wYjzokpAf0R2n0uQe4bjDgtuAQsjdF+4BLoukUeWZ2dDy7H6EpBas1OCyOvgBkZmGgC/sbo7nAJttjCiLRHnhNjE/DdoLnEJWCZZdFY0JOh/ILjUxiYB1yw0OpLcjt50NLIcHurR956i9OcdGa+buNS7f621NifZJSkM98CgV4Cu4AXFqInI0ZPToXPHQepoIlQjt6JaA8Ek5Fr1pPhvRjRK4FzeJAaLTVcjBwnBZND1oqULwv02eMQQengFIvYzQ4m+vXMn4r6kMByKTFcpR7SX+A8cBRosIxbrlPVxkgjnjgRCPzF08XDMQsTh/GIjN5FHztIgC0GE52GtZb4/vdGkciQTqVFKW7O18SYuKT3YZkgo7PXcJvow0h7qf6Wa9DrTt9G+jIuRkOp0su0rx6MDOrCr2QEkQr4QFFOcZnXq3SqTmWUUQtMHOlO5OTk/Mf8A7AmvPgC4k8yAAAAAElFTkSuQmCC" />
                </defs>
              </svg>


              <span>GitHub</span>
            </button>

            <button @click="signInWithMicrosoft"
              class="flex items-center justify-center w-full h-[52px] gap-2.5 border border-gray-300 rounded-[10px] bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              <!-- Microsoft SVG -->
              <svg width="21" height="21" viewBox="0 0 21 21" fill="none" xmlns="http://www.w3.org/2000/svg"
                xmlns:xlink="http://www.w3.org/1999/xlink">
                <rect x="0.5" y="0.292084" width="20" height="20" fill="url(#pattern0_425_13346)" />
                <defs>
                  <pattern id="pattern0_425_13346" patternContentUnits="objectBoundingBox" width="1" height="1">
                    <use xlink:href="#image0_425_13346" transform="scale(0.02)" />
                  </pattern>
                  <image id="image0_425_13346" width="50" height="50" preserveAspectRatio="none"
                    xlink:href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAAsTAAALEwEAmpwYAAAA7ElEQVR4nO2ZwQ2EIBBFjSZSB7ajCZ6wLcuQy0IJWIVFcJT7bIi3ZUPCeDG7/yX/amYCb8jEpgEAgJ+AtFxpGTw7WrrPb45WudEqz81k1VrfyFUQsaNlyBp5zWGyM3EzWuXRCOFEJK7WBEe+gKm1YPwS3pEScGSBIwRH/sMRLV0qhp/hyBqx6kjNsGNVtuMAAG7SmtN1JgZ2tpjJTrs4aO8DO17Uy95u0Xcm0o1k4/cqSBA7vq8fv2jE4EQIV6sEHDFwhOBICThi4AjBkRJwxDzMkW6LazoVdsyZ7Q5pn0jFsLOL+p+hAADQPJE3bI1IcFQNCT0AAAAASUVORK5CYII=" />
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



<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useToast } from 'vue-toastification'
import SuccessDeactivateAccount from '@/components/settings/modals/successDeactivateAccount.vue'
import { useAnalytics } from '@/composables/useAnalytics'

const router = useRouter()
const toast = useToast()

const { trackSignupLogin, track } = useAnalytics()

/* ----------------------------------
 * UI state
 * ---------------------------------- */
const showPassword = ref(false)
const showConfirmPassword = ref(false)

const togglePassword = () => (showPassword.value = !showPassword.value)
const toggleConfirmPassword = () =>
  (showConfirmPassword.value = !showConfirmPassword.value)

const form = ref({
  email: '',
  password: '',
  confirmPassword: '',
})

/* ----------------------------------
 * Email/password signup
 * ---------------------------------- */
const onSubmit = async () => {
  const { email, password, confirmPassword } = form.value

  if (!email || !password || !confirmPassword) {
    toast.error('All fields are required.')
    return
  }

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    toast.error('Please enter a valid email address.')
    return
  }

  if (password !== confirmPassword) {
    toast.error('Passwords do not match.')
    return
  }

  if (password.length < 8) {
    toast.error('Password must be at least 8 characters.')
    return
  }

  track?.('signup_started', { method: 'email' })

  try {
    await $fetch('/auth/register', {
      method: 'POST',
      body: { email, password },
    })

    trackSignupLogin({
      email,
      signup_ts: Date.now(),
      method: 'email',
    })

    track?.('signup_completed', { method: 'email' })

    toast.success('Account created successfully!')
    router.push('/dashboard')
  } catch (err: any) {
    toast.error(err?.data?.message || 'Signup failed.')
  }
}

/* ----------------------------------
 * Social signup (redirect-based)
 * ---------------------------------- */
const signInWithGoogle = () => {
  track?.('signup_started', { method: 'google' })
  window.location.href = '/auth/oauth/google'
}

const signInWithGitHub = () => {
  track?.('signup_started', { method: 'github' })
  window.location.href = '/auth/oauth/github'
}

const signInWithMicrosoft = () => {
  track?.('signup_started', { method: 'microsoft' })
  window.location.href = '/auth/oauth/microsoft'
}

/* ----------------------------------
 * Deactivation success modal (unchanged)
 * ---------------------------------- */
const showSuccessDeactivateAccountModal = ref(false)
const message = ref('')
const buttonText = ref('')

const toggleDeactivationModal = () => {
  showSuccessDeactivateAccountModal.value =
    !showSuccessDeactivateAccountModal.value
}

onMounted(() => {
  const params = new URLSearchParams(window.location.search)

  const clean = (str: string | null) =>
    str ? str.replace(/^'(.*)'$/, '$1') : ''

  message.value = clean(params.get('message'))
  buttonText.value = clean(params.get('buttonText'))

  window.history.replaceState({}, document.title, window.location.pathname)

  if (message.value) {
    showSuccessDeactivateAccountModal.value = true
  }
})
</script>
