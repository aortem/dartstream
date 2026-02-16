<template>
  <div class="min-h-screen  flex">
    <!-- Left Image Column -->
    <div class="hidden lg:flex lg:w-6/12 bg-indigo-500">
      <div class="flex items-center justify-center w-full">
        <img src="/assets/images/login-bg.svg" alt="Signup Image" class="w-full h-full object-cover" />
      </div>
    </div>

    <!-- Right Column: Logo + Email + Form -->
    <div class="flex flex-col w-full lg:w-6/12 sm:px-6 lg:px-8 ">
      <!-- Logo + Email Top Row -->
      <div class="flex items-center justify-between w-full px-4 sm:px-6 lg:px-8 py-4">
        <img class="h-12 w-auto" src="/assets/images/logo.png" alt="Workflow" />
        <p class="text-sm text-gray-600 flex items-center">
          <!-- <NuxtIcon name="mdi-lock" class="mr-1" /> -->
          App Support
        </p>
      </div>

      <!-- Centered Form Content -->
      <div class="flex flex-col justify-center items-start flex-grow px-4 sm:px-6 lg:px-8">
        <div class="w-full max-w-md space-y-8">
          <!-- Heading -->
          <div>
            <div>
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
                  <filter id="filter0_d_425_13318" x="14" y="15.2921" width="68" height="68"
                    filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
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

            </div>
            <h5 class="mt-6 text-3xl text-gray-900">
              Forgot Password?
            </h5>
            <p class="mt-2 text-sm text-gray-600">
              No worries, we”ll send you reset instructions.
            </p>
          </div>

          <!-- Form -->
          <form class="mt-8 space-y-8" data-cy="forgot-password-form" @submit.prevent="onSubmit">
            <input type="hidden" name="remember" value="true" />
            <div class="rounded-md shadow-sm space-y-4">
              <div>
                <label for="email-address"
                  class="flex items-center gap-1 text-[14px] leading-[20px] font-medium text-gray-700 tracking-[-0.006em] font-inter" data-cy="email-label">
                  Email Address<span class="text-red-500">*</span><img src="/assets/images/ionic.png" alt="info"
                    class="w-4 h-4" />
                </label>


                <div class="relative w-[560px] h-[50px]">
                  <span class="absolute inset-y-0 left-3 flex items-center pointer-events-none text-gray-400">
                    <!-- Email SVG icon -->
                    <svg width="16" height="13" viewBox="0 0 16 13" fill="none" xmlns="http://www.w3.org/2000/svg">
                      <path
                        d="M1.25 0.0420837H14.75C14.9489 0.0420837 15.1397 0.121101 15.2803 0.261754C15.421 0.402406 15.5 0.593171 15.5 0.792084V11.7921C15.5 11.991 15.421 12.1818 15.2803 12.3224C15.1397 12.4631 14.9489 12.5421 14.75 12.5421H1.25C1.05109 12.5421 0.860322 12.4631 0.71967 12.3224C0.579018 12.1818 0.5 11.991 0.5 11.7921V0.792084C0.5 0.593171 0.579018 0.402406 0.71967 0.261754C0.860322 0.121101 1.05109 0.0420837 1.25 0.0420837ZM14 3.22058L8.054 8.54558L2 3.20408V11.0421H14V3.22058ZM2.38325 1.54208L8.04575 6.53858L13.6265 1.54208H2.38325Z"
                        fill="#99A0AE" />
                    </svg>
                  </span>

                  <input v-model="form.email" id="email-address" name="email" type="email" autocomplete="email" required
                    placeholder="hello@alignui.com"
                    data-cy="email-input"
                    class="appearance-none block w-full h-full rounded-[10px] border border-gray-300 pl-10 pr-[10px] pt-[15px] pb-[15px] text-gray-900 placeholder-gray-500 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" />
                </div>

              </div>


            </div>


            <div class="space-y-4">
              <button type="submit" data-cy="reset-password-button" class="w-[560px] h-12 flex justify-center items-center py-[14px] px-[10px] border text-sm font-medium rounded-[10px] text-white bg-[#42489E] hover:bg-[#373c89] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#42489E]">
                Reset Password
              </button>
            </div>

          </form>
          <!-- Auth links section -->
          <div class="mt-4">
            <div class="flex justify-center text-sm"> <span class="px-2 text-gray-500">
                <NuxtLink to="/auth/login" class="hover:text-indigo-500 flex items-center hover:underline"> <svg
                    width="16" height="16" viewBox="0 0 24 25" fill="none" xmlns="http://www.w3.org/2000/svg"
                    class="mr-1.5" aria-hidden="true">
                    <path d="M4.00002 12.7919H20" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
                      stroke-linejoin="round" />
                    <path d="M8.9999 17.7921C8.9999 17.7921 4 14.1097 4 12.7921C4 11.4745 9 7.79211 9 7.79211"
                      stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                  </svg>
                  Back to login page
                </NuxtLink>
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>


<script setup>
// import useFormErrors from '~/composables/userFormErrors'
import { ref } from 'vue'
import { useToast } from 'vue-toastification';
import { sendPasswordResetEmail } from 'firebase/auth';
const { $firebaseAuth } = useNuxtApp()
const router = useRouter()
const toast = useToast()
const form = ref({
  email: ''
})


const onSubmit = async () => {
  const { email } = form.value

  // Basic validation
  if (!email) {
    toast.warning('Email field is required.')
    return
  }

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    toast.error('Please enter a valid email address.')
    return
  }


  try {
    await sendPasswordResetEmail($firebaseAuth, email)
  
    toast.success("Password reset email sent")
    router.push('/auth/login')

  } catch (error) {
    toast.error(error.data?.message || 'Signup failed. Please try again.')
  }
}

</script>
