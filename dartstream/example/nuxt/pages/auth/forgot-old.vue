<template>
  <div class="min-h-screen bg-gray-100 flex">
    <div class="hidden lg:flex lg:w-6/12 bg-indigo-500">
      <div class="flex items-center justify-center w-full">
        <img src="/assets/images/login-bg.svg" alt="Signup Image" class="w-full h-full object-cover" />
      </div>
    </div>

    <div class="flex flex-col w-full lg:w-6/12">
      <div class="flex items-center justify-between w-full px-4 sm:px-6 lg:px-8 py-4">
        <img class="h-12 w-auto" src="/assets/images/logo.png" alt="Workflow" />
        <p class="text-sm text-gray-600 flex items-center">
          <NuxtIcon name="mdi-lock" class="mr-1" /> help@Intelli Toggle.com
        </p>
      </div>

      <div class="flex flex-col justify-center items-center flex-grow px-4 sm:px-6 lg:px-8">
        <div class="w-full max-w-md space-y-8">

          <div v-if="currentStep === 'enterEmail'">
            <div>
              <h2 class="mt-6 text-3xl font-extrabold text-gray-900">Forgot Password?</h2>
              <p class="mt-2 text-sm text-gray-600">No worries, we’ll send you reset instructions.</p>
            </div>
            <form class="mt-8 space-y-6" @submit.prevent="handleResetPassword">
              <input type="hidden" name="remember" value="true" />
              <div class="rounded-md shadow-sm space-y-4">
                <div>
                  <label for="email-address" class="block text-sm font-medium text-gray-700">Email address</label>
                  <input id="email-address" name="email" type="email" autocomplete="email" required
                         v-model="email"
                         class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                         placeholder="Email address" />
                </div>
              </div>
              <div>
                <button type="submit"
                  class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                  Reset Password
                </button>
              </div>
              <div class="flex justify-center text-sm"> <span class="px-2 text-gray-500">
                  <NuxtLink to="/auth/login" class="text-indigo-600 hover:text-indigo-500 flex items-center hover:underline"> <svg width="16" height="16" viewBox="0 0 24 25" fill="none" xmlns="http://www.w3.org/2000/svg"
                       class="mr-1.5" aria-hidden="true">
                       <path d="M4.00002 12.7919H20" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                       <path d="M8.9999 17.7921C8.9999 17.7921 4 14.1097 4 12.7921C4 11.4745 9 7.79211 9 7.79211" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                     </svg>
                     Back to login page
                  </NuxtLink>
                </span>
              </div>
            </form>
          </div>

          <div v-if="currentStep === 'enterCode'" class="text-center">
            <div class="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-gray-100 mb-4">
                 <svg class="h-10 w-10 text-indigo-500" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
            </div>
            <h2 class="text-2xl font-bold text-gray-900">Password reset</h2>
            <p class="mt-2 text-sm text-gray-600">
              We sent a verification code to <span class="font-medium text-gray-800">{{ submittedEmail }}</span>.
            </p>
            <form class="mt-8 space-y-6" @submit.prevent="handleVerifyCode">
              <div class="flex justify-center space-x-2 sm:space-x-3">
                <input
                  v-for="(digit, index) in verificationCode"
                  :key="index"
                  :ref="el => { if (el) otpInputRefs[index] = el as HTMLInputElement }"
                  type="text"
                  v-model="verificationCode[index]"
                  @input="handleOtpInput(index, $event)"
                  @keydown="handleOtpKeydown(index, $event)"
                  maxlength="1"
                  class="w-12 h-14 sm:w-14 sm:h-16 text-center text-2xl font-medium border border-gray-300 rounded-md focus:ring-indigo-500 focus:border-indigo-500"
                />
              </div>
              <div class="text-sm text-right mt-2">
                <button type="button" @click="handleResendCode" class="font-medium text-indigo-600 hover:text-indigo-500">
                  Resend code
                </button>
              </div>
              <div>
                <button type="submit"
                  class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                  Continue
                </button>
              </div>
               <div class="flex justify-center text-sm">
                <button type="button" @click="goBackToEnterEmail" class="text-indigo-600 hover:text-indigo-500 flex items-center hover:underline">
                     <svg width="16" height="16" viewBox="0 0 24 25" fill="none" xmlns="http://www.w3.org/2000/svg"
                       class="mr-1.5" aria-hidden="true">
                       <path d="M4.00002 12.7919H20" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                       <path d="M8.9999 17.7921C8.9999 17.7921 4 14.1097 4 12.7921C4 11.4745 9 7.79211 9 7.79211" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                     </svg>
                     Back to login page
                </button> </div>
            </form>
          </div>

        </div>
      </div>
    </div>
  </div>
</template>
<style>
/* Basic styling for OTP inputs, can be enhanced */
input[type="text"]:focus {
    box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.5); /* Example focus style */
}
</style>


<script setup lang="ts">
import { ref } from 'vue';
import { useToast } from 'vue-toastification'; // Assuming you're using this

// State for UI steps
type Step = 'enterEmail' | 'enterCode';
const currentStep = ref<Step>('enterEmail');

const email = ref(''); // For the "Enter Email" form
const submittedEmail = ref(''); // To display the email on the "Enter Code" step
const verificationCode = ref(['', '', '', '', '']); // For the 5 digit inputs

const toast = useToast();

// --- Step 1: Handle Reset Password (Email Submission) ---
const handleResetPassword = async () => {
  if (!email.value) {
    toast.error("Please enter your email address.");
    return;
  }
  try {
    // TODO: Replace with your actual API call
    // For example: await $fetch('/api/auth/request-password-reset', { method: 'POST', body: { email: email.value } });

    // Simulate successful API call
    await new Promise(resolve => setTimeout(resolve, 1000)); 

    submittedEmail.value = email.value; // Store the email
    currentStep.value = 'enterCode';    // Switch to the next step
    toast.success(`A verification code has been sent to ${submittedEmail.value}.`);
    // email.value = ''; // Optionally clear the email input from the first step
  } catch (error: any) {
    // Handle real API errors appropriately
    toast.error(error.data?.message || "Failed to send reset instructions. Please try again.");
    console.error("Password reset request error:", error);
  }
};

// --- Step 2: Handle Verification Code Submission ---
const handleVerifyCode = async () => {
  const code = verificationCode.value.join('');
  if (code.length !== 5) {
    toast.error("Please enter the complete 5-digit code.");
    return;
  }
  try {
    // TODO: Replace with your actual API call to verify the code
    // For example: await $fetch('/api/auth/verify-reset-code', { method: 'POST', body: { email: submittedEmail.value, code } });

    // Simulate successful API call
    await new Promise(resolve => setTimeout(resolve, 1000));

    toast.success("Code verified successfully! You can now reset your password.");
    // TODO: Navigate to the actual password reset page (where user enters new password)
    // navigateTo('/auth/set-new-password?email=' + encodeURIComponent(submittedEmail.value) + '&token=' + 'VERIFIED_TOKEN_FROM_API'); 
  } catch (error: any) {
    toast.error(error.data?.message || "Invalid or expired code. Please try again.");
    console.error("Code verification error:", error);
  }
};

// --- Step 2: Handle Resend Code ---
const handleResendCode = async () => {
  if (!submittedEmail.value) return; // Should not happen if on this step
  try {
    // TODO: Replace with your actual API call to resend the code
    // For example: await $fetch('/api/auth/request-password-reset', { method: 'POST', body: { email: submittedEmail.value } });

    // Simulate successful API call
    await new Promise(resolve => setTimeout(resolve, 1000));
    toast.info(`A new verification code has been sent to ${submittedEmail.value}.`);
  } catch (error: any) {
    toast.error(error.data?.message || "Failed to resend code. Please try again.");
    console.error("Resend code error:", error);
  }
};

// Helper for OTP input fields (focus next input)
const otpInputRefs = ref<HTMLInputElement[]>([]);
const handleOtpInput = (index: number, event: Event) => {
  const target = event.target as HTMLInputElement;
  const value = target.value;
  verificationCode.value[index] = value;

  if (value && index < verificationCode.value.length - 1) {
    otpInputRefs.value[index + 1]?.focus();
  }
};
const handleOtpKeydown = (index: number, event: KeyboardEvent) => {
    if (event.key === 'Backspace' && !verificationCode.value[index] && index > 0) {
        otpInputRefs.value[index - 1]?.focus();
    }
};

// Function to go back to the email entry step
const goBackToEnterEmail = () => {
    currentStep.value = 'enterEmail';
    verificationCode.value = ['', '', '', '', '']; // Clear code
    // email.value = submittedEmail.value; // Optionally repopulate email
}
</script>