<template>
  <DeactivateAccount
    v-if="showDeactivateAccountModal"
    :email="email"
    :deactivate-account="deactivateAccount"
    :delete-account="deleteAccount"
    @close="toggleDeactivationModal"
  />
  <div class="space-y-8">
    <div>
      <div class="flex gap-2">
        <img src="/assets/images/passwordb.png" alt="" class="h-7 w-7" />
        <h2 class="text-2xl mb-6">Password Settings</h2>
      </div>

      <div class="mb-6 grid grid-cols-12 gap-6">
        <div class="col-span-12 md:col-span-5">
          <p class="text-sm">Password</p>
          <p class="text-sm text-gray-500 mb-4">View and edit your Password</p>
        </div>
        <div class="col-span-12 md:col-span-7">
          <!-- Single read-only masked field per design -->
          <label class="block font-medium mb-1 flex">
            Password <span class="text-red-500">*</span>
            <img src="/assets/images/ionic.png" alt="" class="h-5 w-5" />
          </label>
          <div class="relative">
            <input
              :type="showPasswordPlain ? 'text' : 'password'"
              :value="fakeMasked"
              readonly
              class="w-full border-gray rounded-[6px] p-2 pr-10"
              placeholder="********"
            />
            <button
              type="button"
              @click="showPasswordPlain = !showPasswordPlain"
              class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700"
              aria-label="Toggle masked password display"
            >
              <img src="/assets/images/eye.png" alt="" class="h-3 w-3" />
            </button>
          </div>

          <!-- Open modal to actually change password -->
          <button
            type="button"
            @click="openDialog"
            class="mt-3 bg-white border-gray rounded-[6px] px-4 py-2 text-sm hover:bg-gray-100 text-gray-500"
          >
            Change password
          </button>
        </div>
      </div>
      <div class="mt-4"></div>
    </div>

    <hr class="border-gray-200" />

    <div class="flex items-center justify-between">
      <div>
        <h3 class="font-medium">2-step verification</h3>
        <p class="text-sm text-gray-500">
          Make your account extra secure along with your password
        </p>
      </div>
      <label class="inline-flex items-center cursor-pointer">
        <input type="checkbox" value="" class="sr-only peer" checked />
        <div
          class="relative w-11 h-6 bg-gray-200 rounded-full peer-focus:ring-[#4C25A7] dark:peer-focus:ring-[#4C25A7] dark:bg-gray-400 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-[#4C25A7] dark:peer-checked:bg-[#4C25A7]"
        ></div>
      </label>
    </div>
    <hr class="border-gray-200" />
    <!-- Deactivate account (non-sandbox) -->
     <div class="flex items-center justify-between" v-if="!isSandboxValue">
      <div>
        <h3 class="font-medium">Deactivate my account</h3>
        <p class="text-sm text-gray-500">This will shut down your account.</p>
      </div>
      <button
        class="border px-4 py-2 text-sm border-gray rounded-[6px] hover:bg-gray-100"
        @click="deactivateAccountShowModal"
      >
        Deactivate
      </button>
    </div>
    <hr class="border-gray-200" />

    <!-- Only for Sandbox environment -->
    <div class="flex items-center justify-between" v-if="isSandboxValue">
      <div>
        <h3 class="font-medium">Delete account</h3>
        <p class="text-sm text-gray-500">
          This will delete your account. your account will be permanently
          deleted.
        </p>
      </div>
      <button
        @click="deleteSandboxAccount"
        class="text-red-600 border-gray rounded-[6px] px-4 py-2 text-sm rounded hover:bg-white"
      >
        Delete
      </button>
    </div>

    <div>
      <h3 class="mb-2">Connected Device</h3>
      <p class="text-md text-[#A1A1A1] mb-4">
        We'll alert you via your email address if there is any unusual activity
        on your account.
      </p>

      <div class="space-y-4">
        <div class="flex items-start justify-between rounded-lg p-4 bg-white">
          <div class="flex gap-2">
            <div class="bg-[#F5F7FA] rounded-[8px] p-3">
              <img src="/assets/images/computer.png" alt="" class="" />
            </div>
            <div class="">
              <h4 class="font-medium">
                Pc Windows
                <span
                  class="text-xs bg-[#EFEBFF] text-[#4C25A7] ml-2 px-2 py-1 rounded-full"
                  >? Active now</span
                >
              </h4>
              <p class="text-sm text-gray-500">
                Melbourne, Australia \u0007 22 Jan at 12:40am
              </p>
            </div>
          </div>
          <button class="text-gray-400 hover:text-black">?</button>
        </div>

        <hr class="border-gray-200" />

        <div class="flex items-start justify-between rounded-lg p-4 bg-white">
          <div class="flex gap-2">
            <div class="bg-[#F5F7FA] rounded-[8px] p-3">
              <img src="/assets/images/tablet.png" alt="" class="" />
            </div>
            <div class="">
              <h4 class="font-medium">Macbook Pro 15-inch</h4>
              <p class="text-sm text-gray-500">
                Melbourne, Australia \u0007 22 Jan at 4:20pm
              </p>
            </div>
          </div>
          <button class="text-gray-400 hover:text-black">?</button>
        </div>
        <hr class="border-gray-200" />
      </div>
    </div>
  </div>

  <!-- Change Password Modal -->
  <div v-if="showDialog" class="fixed inset-0 z-50">
    <!-- Overlay -->
    <div class="absolute inset-0 bg-black/70" @click="closeDialog"></div>

    <!-- Panel -->
    <div class="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 w-[569px] bg-white rounded-[8px] shadow-xl isolate">
      <!-- Header -->
      <div class="flex items-center justify-between bg-[#F5F7FA] h-[61px] px-6 rounded-t-[8px]">
        <h3 class="text-[18px] leading-[27px] font-medium tracking-[-0.015em] text-[#0E121B]">Change password</h3>
        <button @click="closeDialog" aria-label="Close" class="text-[#0E121B] text-lg">×</button>
      </div>

      <!-- Body -->
      <div class="px-6 pt-[24px] pb-6">
        <form @submit.prevent="onModalSubmit" class="flex flex-col gap-6">
          <!-- Old Password -->
          <div>
            <label class="block font-medium mb-1 text-[14px] leading-[20px] tracking-[-0.006em] text-[#0E121B]">
              Old Password <span class="text-[#FC5050]">*</span>
            </label>
            <div class="relative flex items-center w-full h-[50px] border border-[#E1E4EA] rounded-[10px] bg-white px-3 shadow-[0px_1px_2px_rgba(10,13,20,0.03)]">
              <img src="/images/padlock.png" alt="lock" class="w-5 h-5" />
              <input
                :type="showCurrent ? 'text' : 'password'"
                v-model="currentPassword"
                autocomplete="current-password"
                class="ml-2 flex-1 h-full focus:outline-none"
                placeholder="• • • • • • • • • •"
                required
              />
              <button type="button" @click="showCurrent = !showCurrent" class="ml-2 text-gray-400">
                <img src="/images/eye-line.png" alt="toggle" class="w-5 h-5" />
              </button>
            </div>
            <p v-if="errors.current" class="text-red-500 text-xs mt-1">{{ errors.current }}</p>
          </div>

          <!-- New Password -->
          <div>
            <label class="block font-medium mb-1 text-[14px] leading-[20px] tracking-[-0.006em] text-[#0E121B]">
              New Password <span class="text-[#FC5050]">*</span>
            </label>
            <div class="relative flex items-center w-full h-[50px] border border-[#E1E4EA] rounded-[10px] bg-white px-3 shadow-[0px_1px_2px_rgba(10,13,20,0.03)]">
              <img src="/images/padlock.png" alt="lock" class="w-5 h-5" />
              <input
                :type="showNew ? 'text' : 'password'"
                v-model="newPassword"
                autocomplete="new-password"
                class="ml-2 flex-1 h-full focus:outline-none"
                placeholder="• • • • • • • • • •"
                minlength="8"
                required
              />
              <button type="button" @click="showNew = !showNew" class="ml-2 text-gray-400">
                <img src="/images/eye-line.png" alt="toggle" class="w-5 h-5" />
              </button>
            </div>
            <p v-if="errors.new" class="text-red-500 text-xs mt-1">{{ errors.new }}</p>
          </div>

          <!-- Confirm New Password -->
          <div>
            <label class="block font-medium mb-1 text-[14px] leading-[20px] tracking-[-0.006em] text-[#0E121B]">
              Confirm New Password <span class="text-[#FC5050]">*</span>
            </label>
            <div class="relative flex items-center w-full h-[50px] border border-[#E1E4EA] rounded-[10px] bg-white px-3 shadow-[0px_1px_2px_rgba(10,13,20,0.03)]">
              <img src="/images/padlock.png" alt="lock" class="w-5 h-5" />
              <input
                :type="showConfirm ? 'text' : 'password'"
                v-model="confirmPassword"
                autocomplete="new-password"
                class="ml-2 flex-1 h-full focus:outline-none"
                placeholder="• • • • • • • • • •"
                required
              />
              <button type="button" @click="showConfirm = !showConfirm" class="ml-2 text-gray-400">
                <img src="/images/eye-line.png" alt="toggle" class="w-5 h-5" />
              </button>
            </div>
            <p v-if="errors.confirm" class="text-red-500 text-xs mt-1">{{ errors.confirm }}</p>
          </div>

          <!-- Footer button -->
          <div class="w-full flex items-center justify-center mt-2">
            <button type="submit" :disabled="submitting" class="w-[445px] h-[48px] rounded-[10px] text-white disabled:opacity-50" style="background: linear-gradient(180deg, rgba(255, 255, 255, 0.24) 0%, rgba(255, 255, 255, 0) 100%), #424B9E;">
              {{ submitting ? 'Updating…' : 'Change Password' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Success Modal -->
  <div v-if="showSuccess" class="fixed inset-0 z-50">
    <div class="absolute inset-0 bg-black/60" @click="showSuccess = false"></div>
    <div class="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 w-[520px] bg-white rounded-[12px] shadow-xl isolate">
      <!-- Success Header with weak-50 background -->
      <div class="flex items-center justify-between bg-[#F5F7FA] h-[61px] px-6 rounded-t-[12px]">
        <h3 class="m-0 text-[18px] leading-[27px] font-medium tracking-[-0.015em] text-[#0E121B]">Successful Password Reset!</h3>
        <button @click="showSuccess = false" aria-label="Close" class="text-[#0E121B] text-lg">×</button>
      </div>
      <!-- Body -->
      <div class="p-6 text-center">
        <div class="mx-auto mb-4 h-12 w-12 flex items-center justify-center">
          <img src="/images/greencheck.png" alt="success" class="h-12 w-12" />
        </div>
        <h3 class="text-xl font-semibold text-[#0E121B]">Successful Password Reset!</h3>
        <p class="text-sm text-gray-600 mt-1">You can now use your new password to login to your account</p>
        <button class="mt-6 w-full rounded-[10px] text-white h-[48px]" style="background: linear-gradient(180deg, rgba(255, 255, 255, 0.24) 0%, rgba(255, 255, 255, 0) 100%), #424B9E;" @click="logoutToLogin">Back to login</button>
      </div>
    </div>
  </div>

  
  
  
</template>

<script setup>
import { ref, onMounted } from "vue";
import DeactivateAccount from "../settings/modals/deactivateAccount.vue";
import { useToast } from "vue-toastification";

const toast = useToast();

const twoFA = ref(true);
// sandbox flag (string as before)
const isSandboxValue = ref("");
const { $api, $firebaseAuth } = useNuxtApp();
const router = useRouter();
const currentPassword = ref("")
const newPassword = ref("")
// Inline display: read-only masked password per design
const showPasswordPlain = ref(false)
const fakeMasked = "••••••••••••••••"
// Modal state
const showDialog = ref(false)
const showSuccess = ref(false)
const showCurrent = ref(false)
const showNew = ref(false)
const showConfirm = ref(false)
const confirmPassword = ref("")
// Cooldown for reauth to avoid rate limiting
const lastReauthAt = ref(0)
const submitting = ref(false)
const errors = ref({ current: "", new: "", confirm: "" })
onMounted(() => {
  try {
    const rawUserStatus = localStorage.getItem("user_status");
    const userStatus = rawUserStatus ? JSON.parse(rawUserStatus) : null;
    isSandboxValue.value = userStatus?.isSandbox || ""
  } catch { isSandboxValue.value = "" }
});

// QA helpers: allow opening dialog/success via query params
const route = useRoute()
onMounted(() => {
  const q = (route.query || {})
  if (q.cpDialog === '1' || q.cpDialog === 'true') {
    showDialog.value = true
  }
  if (q.cpSuccess === '1' || q.cpSuccess === 'true') {
    showSuccess.value = true
  }
})

// inline toggle handled directly via showPasswordPlain

const openDialog = () => {
  errors.value = { current: "", new: "", confirm: "" }
  confirmPassword.value = ""
  showDialog.value = true
}
const closeDialog = () => {
  showDialog.value = false
}

// Deactivation modal helpers (as in development)
const showDeactivateAccountModal = ref(false)
const email = ref("")
const toggleDeactivationModal = () => {
  showDeactivateAccountModal.value = !showDeactivateAccountModal.value
}
const deactivateAccountShowModal = () => {
  email.value = ""
  toggleDeactivationModal()
}
const deleteAccountShowModal = () => {
  const rawAuthUser = localStorage.getItem("auth_user")
  const authUser = rawAuthUser ? JSON.parse(rawAuthUser) : ""
  email.value = authUser?.email || ""
  toggleDeactivationModal()
}

const validateModal = () => {
  errors.value = { current: "", new: "", confirm: "" }
  let ok = true
  if (!currentPassword.value) { errors.value.current = "Current password is required"; ok = false }
  if (!newPassword.value) { errors.value.new = "New password is required"; ok = false }
  else if (newPassword.value.length < 8) { errors.value.new = "New password must be at least 8 characters"; ok = false }
  if (!confirmPassword.value) { errors.value.confirm = "Please confirm your new password"; ok = false }
  else if (confirmPassword.value !== newPassword.value) { errors.value.confirm = "Passwords do not match"; ok = false }
  return ok
}

const onModalSubmit = async () => {
  if (!validateModal()) { toast.error("Please fix the errors and try again."); return }
  submitting.value = true
  try {
    await ensureFreshAuth()
    const token = useCookie("auth_token").value
    const headers = { "Content-Type": "application/json", ...(token ? { Authorization: `Bearer ${token}` } : {}) }
    const doRequest = async () => await $api("/auth/update-password", {
      method: "POST",
      body: { currentPassword: currentPassword.value, newPassword: newPassword.value },
      headers,
      credentials: "include"
    })
    let res = await doRequest()
    if (res && !res.error) {
      toast.success(res?.message || "Password updated successfully!", { type: "success" })
      showDialog.value = false
      showSuccess.value = true
    } else {
      const code = res?.error?.code || res?.error || res?.code
      switch (code) {
        case 'wrong-password':
          toast.error('Current password is incorrect.')
          break
        case 'invalid-token':
        case 'requires-recent-login':
          // try one refresh + retry before redirect
          try {
            await ensureFreshAuth()
            res = await doRequest()
            if (res && !res.error) {
              toast.success(res?.message || 'Password updated successfully!', { type: 'success' })
              showDialog.value = false
              showSuccess.value = true
              break
            }
          } catch {}
          toast.error('Session expired. Please sign in again.')
          await router.push('/auth/login')
          break
        case 'invalid-password':
          toast.error('New password does not meet requirements.')
          break
        case 'too-many-requests':
        case 'too_many_attempts_try_later':
          toast.error('Too many attempts. Please wait a few minutes and try again.')
          break
        default:
          toast.error(res?.message || 'Failed to update password')
      }
    }
  } catch (err) {
    const status = err?.status || err?.response?.status || err?.data?.statusCode
    if (status === 401 || status === 403) {
      // try refresh + retry once
      try {
        await ensureFreshAuth()
        const token = useCookie('auth_token').value
        const headers = { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) }
        const res = await $api('/auth/update-password', {
          method: 'POST',
          body: { currentPassword: currentPassword.value, newPassword: newPassword.value },
          headers,
          credentials: 'include'
        })
        if (res && !res.error) {
          toast.success(res?.message || 'Password updated successfully!', { type: 'success' })
          showDialog.value = false
          showSuccess.value = true
          submitting.value = false
          return
        }
      } catch {}
      toast.error('Session expired. Please sign in again.')
      await router.push('/auth/login')
      return
    }
    const code = err?.data?.error?.code || err?.data?.error || err?.code
    switch (code) {
      case 'wrong-password':
        toast.error('Current password is incorrect.')
        break
      case 'invalid-token':
      case 'requires-recent-login':
        toast.error('Session expired. Please sign in again.')
        await router.push('/auth/login')
        break
      case 'invalid-password':
        toast.error('New password does not meet requirements.')
        break
      case 'too-many-requests':
      case 'too_many_attempts_try_later':
        toast.error('Too many attempts. Please wait a few minutes and try again.')
        break
      default:
        const msg = err?.data?.message || err?.message || 'Something went wrong'
        toast.error(msg)
    }
  } finally {
    submitting.value = false
  }
}

// (removed duplicate sandbox delete; use deleteSandboxAccount below)
// Deactivate current (non-sandbox) account (as in development)
const deactivateAccount = async () => {
  toggleDeactivationModal()
  try {
    const rawAuthUser = localStorage.getItem("auth_user")
    const authUser = rawAuthUser ? JSON.parse(rawAuthUser) : ""
    const userId = authUser?.uid
    const res = await $api(`/api/users/${userId}/deactivate`, { method: "PATCH" })
    if (res?.success) {
      localStorage.clear()
      router.push("/auth/login?message='Your account is deactivated. Login anytime to reactivate.'&buttonText='Login'")
    } else {
      toast.error("Something went wrong. Please try again. ")
    }
  } catch (error) {
    toast.error("Something went wrong. Please try again. ")
  }
}

// Delete account (non-sandbox), as in development
const deleteAccount = async () => {
  try {
    const rawAuthUser = localStorage.getItem("auth_user")
    const authUser = rawAuthUser ? JSON.parse(rawAuthUser) : ""
    const userId = authUser?.uid
    const res = await $api(`/api/users/${userId}`, { method: "DELETE" })
    if (res?.success) {
      localStorage.clear()
      router.push("/auth/register?message='Your account has been permanently deleted.'&buttonText='Exit'")
    } else {
      toast.error("Something went wrong. Please try again. ")
    }
  } catch (error) {
    toast.error("Something went wrong. Please try again. ")
  }
}

// Sandbox delete, as in development
const deleteSandboxAccount = async () => {
  try {
    const res = await $api("/api/sandbox/cleanup/tenant", { method: "POST" })
    if (res) {
      localStorage.clear()
      router.push("/auth/login")
      toast.success("You account is deleted successfully.")
    } else {
      toast.error("Something went wrong. Please try again. ")
    }
  } catch (error) {
    toast.error("Something went wrong. Please try again. ")
  }
}
// Update API call
const updatePassword = async () => {
  if (!currentPassword.value || !newPassword.value) {
    toast.error("Please fill in both fields.");
    return;
  }

  try {
    await ensureFreshAuth()
    const token = useCookie("auth_token").value
    const headers = { "Content-Type": "application/json", ...(token ? { Authorization: `Bearer ${token}` } : {}) }
    const doRequest = async () => await $api("/auth/update-password", {
      method: "POST",
      body: {
        currentPassword: currentPassword.value,
        newPassword: newPassword.value
      },
      headers,
      credentials: "include"
    })
    let res = await doRequest()
    if (res && !res.error) {
      toast.success(res?.message || "Password updated successfully!", { type: "success" })
      currentPassword.value = ""
      newPassword.value = ""
      showDialog.value = false
      showSuccess.value = true
    } else {
      const code = res?.error?.code || res?.error || res?.code
      switch (code) {
        case 'wrong-password':
          toast.error('Current password is incorrect.')
          break
        case 'invalid-token':
        case 'requires-recent-login':
          // try one refresh + retry before redirect
          try {
            await ensureFreshAuth()
            res = await doRequest()
            if (res && !res.error) {
              toast.success(res?.message || 'Password updated successfully!', { type: 'success' })
              currentPassword.value = ''
              newPassword.value = ''
              showDialog.value = false
              showSuccess.value = true
              break
            }
          } catch {}
          toast.error('Session expired. Please sign in again.')
          await router.push('/auth/login')
          break
        case 'invalid-password':
          toast.error('New password does not meet requirements.')
          break
        case 'too-many-requests':
        case 'too_many_attempts_try_later':
          toast.error('Too many attempts. Please wait a few minutes and try again.')
          break
        default:
          toast.error(res?.message || 'Failed to update password')
      }
    }
  } catch (error) {
    console.error("Update password error:", error)
    const status = error?.status || error?.response?.status || error?.data?.statusCode
    if (status === 401 || status === 403) {
      // try refresh + retry once
      try {
        await ensureFreshAuth()
        const token = useCookie('auth_token').value
        const headers = { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) }
        const res = await $api('/auth/update-password', {
          method: 'POST',
          body: { currentPassword: currentPassword.value, newPassword: newPassword.value },
          headers,
          credentials: 'include'
        })
        if (res && !res.error) {
          toast.success(res?.message || 'Password updated successfully!', { type: 'success' })
          currentPassword.value = ''
          newPassword.value = ''
          showDialog.value = false
          showSuccess.value = true
          return
        }
      } catch {}
      toast.error('Session expired. Please sign in again.')
      await router.push('/auth/login')
    } else {
      const code = error?.data?.error?.code || error?.data?.error || error?.code
      switch (code) {
        case 'wrong-password':
          toast.error('Current password is incorrect.')
          break
        case 'invalid-token':
        case 'requires-recent-login':
          toast.error('Session expired. Please sign in again.')
          await router.push('/auth/login')
          break
        case 'invalid-password':
          toast.error('New password does not meet requirements.')
          break
        case 'too-many-requests':
        case 'too_many_attempts_try_later':
          toast.error('Too many attempts. Please wait a few minutes and try again.')
          break
        default:
          toast.error(error?.message || 'Something went wrong')
      }
    }
  }
}

// Success modal action: log out and go to login
const logoutToLogin = async () => {
  try {
    const token = useCookie("auth_token").value
    if ($firebaseAuth) {
      try { await import('firebase/auth').then(m => m.signOut($firebaseAuth)) } catch {}
    }
    if (token) { try { await $api('/auth/logout', { method: 'POST' }) } catch {} }
  } finally {
    useCookie('auth_token').value = null
    localStorage.removeItem('auth_token')
    localStorage.removeItem('refresh_token')
    localStorage.removeItem('auth_user')
    localStorage.removeItem('sandbox')
    localStorage.removeItem('selectedProject')
    localStorage.removeItem('user_status')
    router.push('/auth/login')
  }
}

// Helper: refresh Firebase auth and optionally reauthenticate with current password
const ensureFreshAuth = async () => {
  try {
    const cu = $firebaseAuth?.currentUser
    if (!cu) return
    try { await cu.reload() } catch {}
    if (currentPassword.value) {
      // reauth cooldown: 5 minutes
      const now = Date.now()
      if (now - lastReauthAt.value < 5 * 60 * 1000) return
      try {
        const m = await import('firebase/auth')
        if (m?.EmailAuthProvider && m?.reauthenticateWithCredential) {
          await m.reauthenticateWithCredential(
            cu,
            m.EmailAuthProvider.credential(cu.email || '', currentPassword.value)
          )
        }
        lastReauthAt.value = now
      } catch (e) {
        if (e?.code === 'auth/wrong-password') {
          toast.error('Current password is incorrect.')
          throw e
        }
        if (e?.code === 'auth/too-many-requests') {
          toast.error('Too many attempts. Please wait a few minutes and try again.')
          throw e
        }
      }
    }
  } catch {}
}

</script>

