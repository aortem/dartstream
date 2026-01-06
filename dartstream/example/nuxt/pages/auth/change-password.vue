<template>
  <div class="min-h-screen bg-gray-100 flex">
    <!-- Left Image Column -->
    <div class="hidden lg:flex lg:w-6/12 bg-indigo-500">
      <div class="flex items-center justify-center w-full">
        <img src="/assets/images/login-bg.svg" alt="Signup Image" class="w-full h-full object-cover" />
      </div>
    </div>

    <!-- Right Column: Logo + Email + Form -->
    <div class="flex flex-col w-full lg:w-6/12">
      <!-- Logo + Email Top Row -->
      <div class="flex items-center justify-between w-full px-4 sm:px-6 lg:px-8 py-4">
        <img class="h-12 w-auto" src="/assets/images/logo.png" alt="Workflow" />
        <p class="text-sm text-gray-600 flex items-center">
          <NuxtIcon name="mdi-lock" class="mr-1" />
          help@Intelli Toggle.com
        </p>
      </div>

      <!-- Centered Form Content -->
      <div class="flex flex-col justify-center items-center flex-grow px-4 sm:px-6 lg:px-8">
        <div class="w-full max-w-md space-y-8">
          <!-- Heading -->
          <div>
            <h2 class="mt-6 text-3xl font-extrabold text-gray-900">
              New Password
            </h2>
            <p class="mt-2 text-sm text-gray-600">
              Enter your new password.
            </p>
          </div>

          <!-- Form -->
          <form class="mt-8 space-y-6" action="#" method="POST">
            <input type="hidden" name="remember" value="true" />
            <div class="rounded-md shadow-sm space-y-4">
              <div>
                <label for="password" class="block text-sm font-medium text-gray-700">New Password</label>
                <input id="password" name="password" type="password" autocomplete="password" required
                  class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                  placeholder="New Password" />
              </div>
              <div>
                <label for="password" class="block text-sm font-medium text-gray-700">Confirm Password</label>
                <input id="password" name="password" type="password" autocomplete="current-password" required
                  class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                  placeholder="Confrim Password" />
              </div>
            </div>

            <div>
              <button type="submit"
                class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                Confirm Changes
              </button>
            </div>

       <div class="flex justify-center text-sm">
  <span class="px-2 text-gray-500">
    <NuxtLink to="/auth/register" class=" flex items-center hover:underline">
      <svg
        width="16"  
        height="16" 
        viewBox="0 0 24 25"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        class="mr-1.5" 
        aria-hidden="true" 
      >
        <path d="M4.00002 12.7919H20" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M8.9999 17.7921C8.9999 17.7921 4 14.1097 4 12.7921C4 11.4745 9 7.79211 9 7.79211" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
      Back to login page
    </NuxtLink>
  </span>
</div>

          </form>
        </div>
      </div>
    </div>
  </div>
</template>



<script>
import bgLogin from '~/assets/images/login-bg.svg';
import Logo from '~/assets/images/logo.png';

export default {
  name: "SignUp",
  data() {
    return {
      email: "",
      password: "",
      confirmPassword: "",
    };
  },
  methods: {
    signUp() {
      //  Add your sign-up logic here.
      if (this.password !== this.confirmPassword) {
        alert("Passwords do not match!");
        return;
      }
      // You would typically send this data to a server.
      // For this example, we'll just log it to the console.
    },
  },
};
</script>
