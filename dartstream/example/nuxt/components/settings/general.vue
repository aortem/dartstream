<template>
  <div class="">
    <div class="flex gap-2">
      <img src="/assets/images/genralb.png" alt="" class="h-7 w-7" />
      <h2 class="text-2xl mb-6">General Settings</h2>
    </div>
    <div class="mb-6 grid grid-cols-12 gap-6">
      <div class="col-span-12 md:col-span-5">
        <p class="text-sm">Avatar</p>
        <p class="text-sm text-gray-500 mb-2">Update full name</p>
      </div>
      <div class="col-span-12 md:col-span-7">
        <div class="flex items-center space-x-4">
          <!-- Avatar Preview -->
          <div v-if="previewImage" class="relative">
            <img
              :src="previewImage"
              alt="Avatar preview"
              class="w-20 h-20 rounded-full object-cover border border-gray-300 shadow-sm cursor-pointer"
              @click="triggerFileInput"
            />
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="16"
              height="16"
              fill="currentColor"
              class="bi bi-pen absolute bottom-2 -right-1 text-[#42489E]"
              viewBox="0 0 16 16"
            >
              <path
                d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001zm-.644.766a.5.5 0 0 0-.707 0L1.95 11.756l-.764 3.057 3.057-.764L14.44 3.854a.5.5 0 0 0 0-.708l-1.585-1.585z"
              />
            </svg>
          </div>

          <!-- Hidden File Input -->
          <input
            ref="fileInput"
            type="file"
            accept="image/png, image/jpeg"
            class="hidden"
            @change="handleFileUpload"
          />

          <!-- Upload Avatar GCS Button -->
          <button
            v-if="imageFile"
            class="px-4 py-2 bg-white border border-[#42489E] rounded-[8px] text-sm hover:bg-gray-50"
            @click="uploadAvatarToGCS"
          >
            Upload Avatar
          </button>

          <!-- Upload Button -->
          <button
            v-else
            type="button"
            class="px-4 py-2 bg-white border border-[#E1E4EA] rounded-[8px] text-sm hover:bg-gray-50"
            @click="triggerFileInput"
          >
            Upload Image
          </button>

          <!-- Remove Image Button -->
          <button
            type="button"
            class="px-3 py-2 bg-white border border-[#E1E4EA] rounded-[8px] hover:bg-gray-50"
            title="Remove image"
            @click="removeImage"
          >
            <img src="/assets/images/del.png" alt="Delete" class="w-4 h-4" />
          </button>

          <!-- <button
    type="button"
    @click="uploadImage"
    class="px-4 py-2 bg-white border border-[#E1E4EA] rounded-[8px] text-sm hover:bg-gray-50"
  >
    Save
  </button> -->
        </div>

        <p
          class="text-sm text-gray-400 mt-1 items-center flex text-center ml-8"
        >
          We only support JPG, JPEG, or .PNG file. 1MB max.
        </p>
      </div>
    </div>
    <hr class="my-6" />

    <form @submit.prevent="submitForm">
      <div class="mb-6 grid grid-cols-12 gap-6">
        <div class="col-span-12 md:col-span-5">
          <p class="text-sm">Personal Information</p>
          <p class="text-sm text-gray-500 mb-4">
            Edit your personal information
          </p>
        </div>
        <div class="col-span-12 md:col-span-7">
          <div>
            <label class="mb-1 text-sm font-medium flex"
              >Full name <span class="text-red-500">*</span>
              <img src="/assets/images/ionic.png" alt="" class="h-5 w-5" />
            </label>
            <input
              v-model="form.displayName"
              type="text"
              class="w-full border border-[#E1E4EA] rounded-[8px] p-2"
              placeholder="Sophia Williams"
              required
            />
          </div>
          <div>
            <label class="block mb-1 text-sm font-medium flex mt-3"
              >Email <span class="text-red-500">*</span>
              <img src="/assets/images/ionic.png" alt="" class="h-5 w-5" />
            </label>
            <input
              v-model="form.email"
              type="email"
              class="w-full border border-[#E1E4EA] rounded-[8px] p-2"
              placeholder="sophia@aisocui.com"
              required
            />
            <button type="button" class="mt-3 text-gray-500">
              + Add another
            </button>
          </div>
        </div>
      </div>

      <hr class="my-6" />

      <div class="mb-6 grid grid-cols-12 gap-6">
        <div class="col-span-12 md:col-span-5">
          <p class="text-sm mb-1">Phone number</p>
          <p class="text-sm text-gray-500 mb-2">Update your phone number</p>
        </div>
        <div class="col-span-12 md:col-span-7">
          <label class="mb-1 text-sm font-medium flex"
            >Phone number <span class="text-red-500">*</span>
            <img src="/assets/images/ionic.png" alt="" class="h-5 w-5" />
          </label>
          <input
            v-model="form.phone"
            type="tel"
            class="w-full border border-[#E1E4EA] rounded-[8px] p-2"
            placeholder="+33 120 204 482"
          />
        </div>
      </div>

      <hr class="my-6" />

      <div class="mb-6 grid grid-cols-12 gap-6">
        <div class="col-span-12 md:col-span-5">
          <p class="text-sm mb-1">Language</p>
          <p class="text-sm text-gray-500 mb-4">Language</p>
        </div>
        <div class="col-span-12 md:col-span-7">
          <label class="mb-1 text-sm font-medium flex"
            >Language <span class="text-red-500">*</span>
            <img src="/assets/images/ionic.png" alt="" class="h-5 w-5" />
          </label>
          <select
            v-model="form.language"
            class="w-full border border-[#E1E4EA] rounded-[8px] p-2"
            required
          >
            <option value="">--Select--</option>
            <option value="English">English</option>
            <option value="French">French</option>
          </select>
        </div>
      </div>

      <hr class="my-6" />

      <button
        type="submit"
        class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2"
      >
        Save
      </button>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useToast } from "vue-toastification";
import { useAvatar } from "~/composables/useAvatar";


const { $api } = useNuxtApp(); // Nuxt 3 runtime API

const toast = useToast();
const { refreshAvatar } = useAvatar();

// ✅ User type
interface AuthUser {
  email: string;
  uid: string;
  tenantName?: string;
  photoURL?: string;
}

// ✅ Reactive refs
const authUser = ref<AuthUser | null>(null);
const tenantId = ref();

// ✅ Load authUser from localStorage
onMounted(() => {
  getCurrentUser();
  const rawAuthUser = localStorage.getItem("auth_user"); // key should match what's saved
  authUser.value = rawAuthUser ? JSON.parse(rawAuthUser) : null;
  if (authUser.value?.email) {
    form.value.email = authUser.value.email;
  }

  const rawUserStatus = localStorage.getItem("user_status");
  tenantId.value = rawUserStatus ? JSON.parse(rawUserStatus).tenantId : null;
});

// ✅ Image upload logic
const fileInput = ref<HTMLInputElement | null>(null);
const previewImage = ref<string | null>(null);
const imageFile = ref<File | null>(null);

// ✅ Form state
const form = ref({
  displayName: "",
  email: "",
  phone: "",
  language: "",
});

// Upload Avatar Separate Function
const uploadAvatarToGCS = async () => {
  // If image file exists, upload it first
  if (imageFile.value) {
    const uid = authUser.value?.uid;

    await uploadAvatar(uid, imageFile.value);
  }
};

// ✅ Form submission handler
const submitForm = async () => {
  const { displayName, email, phone, language } = form.value;
  const uid = authUser.value?.uid;
  try {
    // If image file exists, upload it first
    if (imageFile.value) {
      const uid = authUser.value?.uid;

      await uploadAvatar(uid, imageFile.value);
    }

    // Then update user info
    const res = await $api(`/api/users/${uid}`, {
      method: "PATCH",
      body: {
        displayName,
        email,
        phone,
        language,
      },
    });
    if (res) {
      toast.success("Profile is updated successfully!");
      getCurrentUser();
    }
  } catch (error: any) {
    console.error("Update error:", error?.data || error?.message);
    toast.error(error?.data?.message || "Update failed. Please try again.");
  }
};
const getCurrentUser = async () => {
  await new Promise((resolve) => setTimeout(resolve, 10));
  const currentUser = await $api("/api/users/me", { method: "GET" });

  if (currentUser) {
    form.value.email = currentUser.email || "";
    form.value.displayName = currentUser.displayName || "";
    form.value.language = currentUser.language || "";
    form.value.phone = currentUser.phone || "";
  }
};

const triggerFileInput = () => {
  fileInput.value?.click();
};

const handleFileUpload = (e: Event) => {
  const target = e.target as HTMLInputElement;
  const file = target.files?.[0];
  if (!file) return;

  const isValid = file.type.startsWith("image/") && file.size <= 1024 * 1024;
  if (!isValid) {
    toast.error("Please select a valid image file (JPG/PNG, max 1MB).");
    return;
  }

  imageFile.value = file;

  const reader = new FileReader();
  reader.onload = (e) => {
    previewImage.value = e.target?.result as string;
  };
  reader.readAsDataURL(file);
};

const removeImage = () => {
  imageFile.value = null;
  previewImage.value = null;
  if (fileInput.value) {
    fileInput.value.value = "";
  }
};

/**
 * ✅ Function to upload the image file to the backend
 */

// Convert file to Base64
const fileToBase64 = (file: File): Promise<string> => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result as string);
    reader.onerror = reject;
    reader.readAsDataURL(file);
  });
};

// Build headers with tenantId
const buildHeaders = (extra?: Record<string, string>) => {
  const headers: Record<string, string> = { ...(extra || {}) };
  if (tenantId.value) headers["X-Tenant-ID"] = tenantId.value;
  return headers;
};

// UPLOAD avatar
const uploadAvatar = async (userId: string, file: File) => {
  try {
    const validTypes = ["image/jpeg", "image/png", "image/gif", "image/webp"];
    if (!validTypes.includes(file.type)) {
      toast.error("Invalid file type");
      return;
    }

    if (file.size > 5 * 1024 * 1024) {
      toast.error("File too large (max 5MB)");
      return;
    }

    // Convert to base64
    const base64 = await fileToBase64(file);

    // Get success and objectPath from Post request response
    const { success, objectPath } = await $api(`/api/users/${userId}/avatar`, {
      method: "POST",
      headers: buildHeaders({ "Content-Type": "application/json" }),
      body: {
        image: base64,
        contentType: file.type,
      },
    });

    if (!success) {
      toast.error("Avatar upload failed");
      return;
    }

    // Update new avatar URL
    authUser.value = {
      ...authUser.value,
      photoURL: objectPath,
    };

    localStorage.setItem("auth_user", JSON.stringify(authUser.value));

    // Clear image
    removeImage();

    // Refresh global avatar in composable (Header will auto-update)
    await refreshAvatar(userId, tenantId.value);

    toast.success("Avatar uploaded successfully!");
  } catch (error: any) {
    console.error("Avatar upload failed:", error);
    toast.error(error?.message || "Upload failed");
  }
};
</script>
