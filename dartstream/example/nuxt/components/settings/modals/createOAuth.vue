<template>
  <transition name="fade">
    <!-- Overlay -->
    <div v-if="props.isOpen" class="fixed inset-0 bg-black bg-opacity-40 z-50 flex justify-end"
      @click.self="handleClose">
      <!-- Panel -->
      <div
        class="bg-white w-full sm:w-[500px] my-auto sm:my-4 mr-3 rounded-2xl shadow-xl flex flex-col max-h-[calc(100vh-2rem)]"
        tabindex="0" @keydown.esc="handleClose">
        <!-- Header -->
        <div class="p-4 bg-[#F3F5F7] rounded-tl-2xl rounded-tr-2xl">
          <div class="flex items-center justify-between">
            <div class="flex items-center space-x-1">
              <!-- Show SVG only when showNewForm is true -->
              <svg
                v-if="showNewForm"
                width="30"
                height="30"
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg"
              >
                <!-- Green background circle -->
                <circle cx="12" cy="12" r="10" fill="#4CAF50" />
                <!-- White checkmark path -->
                <path fill="none" stroke="#FFFFFF" stroke-width="2" d="M6 12l4 4 8-8" />
              </svg>

              <h2 class="text-lg font-medium text-gray-900">
                {{ showNewForm ? "Client Credentials Created Successfully" : "Create OAuth2 Client" }}
              </h2>
            </div>

            <button @click="handleClose" class="text-black hover:text-gray-700 text-xl leading-none">
              ✕
            </button>
          </div>
        </div>


        <!-- Body (scrolls) -->
        <div class="flex-1 overflow-y-auto">
          <!-- Create OAuth2 Client -->
          <template v-if="!showNewForm">
            <form class="p-4 space-y-6" @submit.prevent>
              <div class="p-4 m-4 space-y-4 border border-gray rounded-[16px]">
                <div class="space-y-4">
                  <div class="flex gap-4">
                    <div class="w-full">
                      <label class="block font-medium">
                        Client Name:
                        <span class="text-[#0062FF] font-medium">*</span>
                      </label>
                      <input v-model="form.name" class="w-full border rounded-[8px] px-2 py-2 text-gray-900" type="text"
                        name="name" placeholder="Enter Name" required />
                    </div>
                  </div>
                  <!-- Project Name Dropdown -->
                  <div class="mt-3">
                    <label class="block font-medium">Project Name</label>
                    <select v-model="form.project"
                      class="w-full border rounded-[8px] px-2 py-2 text-gray-900 bg-[#F9FAFB]">
                      <option value="" disabled>Select Project</option>
                      <option v-for="project in projects" :key="project.name" :value="project.name">
                        {{ project.name }}
                      </option>
                    </select>
                  </div>


                  <!-- Environment Visibility -->
                  <div class="mt-3 relative">
                    <label class="block font-medium mb-1">Environment visibility</label>

                    <!-- Dropdown Trigger -->
                    <div class="w-full border rounded-[8px] px-3 py-2 bg-[#F9FAFB] cursor-pointer flex flex-wrap gap-2"
                      @click="showEnvDropdown = !showEnvDropdown">
                      <!-- Selected Tags -->
                      <template v-if="form.environment.length">
                        <span v-for="env in form.environment" :key="env"
                          class="bg-[#42489E] text-white text-sm px-2 py-1 rounded-md flex items-center gap-1">
                          {{ env }}
                          <button type="button" class="text-xs font-bold hover:text-gray-200"
                            @click.stop="form.environment = form.environment.filter(e => e !== env)">
                            ×
                          </button>
                        </span>
                      </template>

                      <!-- Placeholder -->
                      <span v-else class="text-gray-400 text-sm">Select environments</span>

                      <!-- Dropdown Arrow -->
                      <svg class="ml-auto w-4 h-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                        xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                      </svg>
                    </div>

                    <!-- Dropdown Menu -->
                    <div v-if="showEnvDropdown" class="absolute z-10 w-full mt-1 bg-white border rounded-md shadow-lg">
                      <div v-for="env in ['Production']" :key="env"
                        class="px-3 py-2 text-sm hover:bg-gray-100 flex items-center gap-2 cursor-pointer" @click.stop="
                          form.environment.includes(env)
                            ? (form.environment = form.environment.filter(e => e !== env))
                            : form.environment.push(env)
                          ">
                        <input type="checkbox" :checked="form.environment.includes(env)" />
                        <span>{{ env }}</span>
                      </div>
                    </div>
                  </div>


                  <div class="mt-3">
                    <label class="block font-medium">Scope</label>

                    <div class="flex flex-col gap-2">
                      <!-- stack vertically -->
                      <label v-for="opt in scopeOptions" :key="opt.value" class="flex items-center gap-2">
                        <input type="checkbox" v-model="form.scopes" :value="opt.value" class="form-checkbox h-4 w-4" />
                        <span class="text-[14px] font-[400] text-[#596276] leading-[20px]">
                          {{ opt.label }}
                        </span>
                      </label>
                    </div>
                  </div>

                  <div class="rounded space-y-2 text-sm text-gray-500">
                    <div class="w-full relative">
                      <div class="flex gap-2 mb-1">
                        <label class="block font-medium text-[#0E121B]">Date</label>
                        <img src="/assets/images/ionic.png" alt="" class="w-auto" />
                      </div>
                      <input class="w-full border rounded-[8px] px-3 py-3 text-[#0E121B]" type="date"
                        v-model="form.date" />
                    </div>
                  </div>
                </div>
              </div>
            </form>
          </template>

          <template v-if="showNewForm">

            <form class="p-4 space-y-6" @submit.prevent>
              <div class=" m-4 space-y-4">
                <div
  v-if="showSecretAlert"
  class="flex h-[100px] pt-[14px] pr-[14px] pb-4 pl-[14px] items-start gap-3 flex-shrink-0 rounded-[12px] border border-[#FFD4B4] bg-white shadow-[0_16px_32px_-12px_rgba(14,18,27,0.10)]">
  
  <svg width="40" height="40" viewBox="0 50 100 100" role="img" aria-labelledby="title desc" xmlns="http://www.w3.org/2000/svg">
    <title id="title">Danger Sign</title>
    <desc id="desc">A yellow triangle with a black exclamation mark in the center, indicating danger or warning.</desc>
    <polygon points="50,10 90,90 10,90" fill="#FF7B1A" stroke="#e68a00" stroke-width="2"/>
    <g fill="#000000">
      <rect x="47" y="35" width="6" height="35"/>
      <circle cx="50" cy="80" r="4"/>
    </g>
  </svg>

  <div class="h-[100px] items-start gap-[12px]">
    <div class="text-[#0E121B] text-[14px] font-medium leading-[20px] tracking-[-0.084px]">
      Save your client secret now
    </div>
    <p class="text-gray-600 font-plus text-sm">
      The client secret will not be shown again for security reasons. Make sure to save it in a secure location.
    </p>
  </div>

  <button @click="showSecretAlert = false" class="text-gray-500 hover:text-gray-700">
    ✕
  </button>
</div>

              </div>

              <div class="bg-[#F3F5F7] p-4 m-4 space-y-4 border border-gray rounded-[16px]">
                <div class="space-y-4">
                  <div class="flex gap-4">
                    <div class="w-full">
                      <label class="block font-medium"> Client ID </label>
                      <div class="flex justify-between">
                        <input v-model="form.clientId" class="bg-white w-full border rounded-[8px] px-2 py-2 text-gray-900"
                          type="text" name="name" disabled />
                        <button @click="copyKey(form.clientId)"
                          class="bg-[#42489E] text-white w-[84px] h-10 rounded-[10px] ml-[5px] flex items-center justify-center font-medium">
                          Copy
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="space-y-4">
                  <div class="flex gap-4">
                    <div class="w-full">
                      <label class="block font-medium">
                        Client Secret Code
                      </label>
                      <div class="flex justify-between">
                        <input v-model="form.clientSecret" class="bg-white w-full border rounded-[8px] px-2 py-2 text-gray-900"
                          type="text" name="name" disabled />
                        <button
                          @click="copyKey(form.clientSecret)"
                          class="bg-[#42489E] text-white w-[84px] h-10 rounded-[10px] ml-[5px] flex items-center justify-center font-medium"
                        >
                          Copy
                        </button>

                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <!-- Download .env Section -->
              <div
                class="bg-white border rounded-[12px] p-4 mt-4 text-gray-800 shadow-sm text-sm font-mono"
              >
                <p>INTELLITOGGLE_CLIENT_ID={{ form.clientId }}</p>
                <p>INTELLITOGGLE_CLIENT_SECRET={{ form.clientSecret }}</p>
                <p>INTELLITOGGLE_TENANT_ID={{ userStatus?.tenantId }}</p>

                <button
                  type="button"
                  @click="handleDownloadEnv"
                  class="bg-[#42489E] text-white font-medium w-full mt-4 h-10 rounded-[10px] flex items-center justify-center"
                >
                  Download .env File
                </button>
              </div>

            </form>
          </template>
        </div>

        <!-- Footer (sticky) -->
        <div class="border-t bg-white p-4">
          <div class="flex justify-between gap-2">
            <button v-if="!showNewForm" @click="handleClose" type="button"
              class="px-4 py-2 bg-[#F5F7FA] w-full rounded-[8px]">
              Cancel
            </button>

            <button v-if="!showNewForm" @click.prevent="createClient"
              class="px-4 py-2 bg-[#42489E] text-white w-full rounded-[8px]">
              Create Client
            </button>
            <!-- 
            <button
              v-else
              @click.prevent="revokeKey"
              class="px-4 py-2 bg-[#42489E] text-white w-full rounded-[8px]"
            >
              Revoke Key
            </button> -->
          </div>
        </div>
      </div>
      <!-- /Panel -->
    </div>
  </transition>
</template>

<script setup lang="ts">
import { ref, watch } from "vue";
import { useToast } from "vue-toastification";
const toast = useToast()
const { $api } = useNuxtApp();
const props = defineProps({
  isOpen: { type: Boolean, default: false },
});
const emit = defineEmits(["close", "submitted", "error", "refreshClients"]);
const showSecretAlert = ref(true);

type Scope = "flags:read" | "flags:write" | "flags:evaluate" | "projects:read" | "projects:write";
const showNewForm = ref(false);
const generatedKey = ref("env_abcd123456xyz");
const userStatusRaw = localStorage.getItem("user_status");
const userStatus = userStatusRaw ? JSON.parse(userStatusRaw) : null;
console.log(userStatus);
const form = ref({
  name: "",
  project: "",
  environment: [],
  date: "",
  clientId: "",
  clientSecret: "",
  scopes: [],
});
const showEnvDropdown = ref(false);

const projects = ref([]);

watch(
  () => props.isOpen,
  async (open) => {
    if (open) {
      try {
        const res = await $api("/api/projects/", { method: "GET" });

        // ✅ Match backend structure
        projects.value =
          res.data?.projects ||
          res.data?.data?.projects || // handle nested 'data'
          [];

      } catch (err) {
        console.error("Failed to load projects:", err);
      }
    }
  }
);




// const scopes = ref({ read: false, write: false, evaluate: false })
const scopeOptions: { value: Scope; label: string }[] = [
  { value: "flags:read", label: "Flags:Read" },
  { value: "flags:write", label: "Flags:Write" },
  { value: "flags:evaluate", label: "Flags:Evaluate" },
  { value: "projects:read", label: "Projects:Read" },
  { value: "projects:write", label: "Projects:Write" },
];

function handleClose() {
  showNewForm.value = false;
  emit("close");
}

// reset view when parent opens/closes
watch(
  () => props.isOpen,
  (open) => {
    if (open) {
      // 🔹 Reset form when modal is opened
      form.value = {
        name: "",
        project: "",
        environment: [],
        date: "",
        clientId: "",
        clientSecret: "",
        scopes: [],
      };

      showNewForm.value = false;
    } else {
      showNewForm.value = false;
    }
  }
);

async function createClient() {
  const ALLOWED = new Set(["flags:read", "flags:write", "flags:evaluate", "projects:read", "projects:write"]);
  const scopes = form.value.scopes.filter((s) => ALLOWED.has(s)); // (guards against any stray values)

  try {
    const payload = {
      name: form.value.name,
      project: form.value.project,
      environment: form.value.environment,
      date: form.value.date,
      scopes,
    };


    const res = await $api(`/api/oauth/clients`, {
      method: "POST",
      body: payload, // send all form fields directly
    });
    console.log(res, res);
    form.value = res;

    // generatedKey.value = res.data.apiKey
    showNewForm.value = true;
    emit("submitted", payload);
    emit("refreshClients")
  } catch (e) {
    emit("error", e);
  }
}

function copyKey(client) {
  navigator.clipboard?.writeText(client);
  toast.success('Copied to clipboard!')
}
function handleDownloadEnv() {
  const envValue = Array.isArray(form.value.environment)
    ? form.value.environment.join(',')
    : form.value.environment || '';

  const envContent = `INTELLITOGGLE_CLIENT_ID=${form.value.clientId}
  INTELLITOGGLE_CLIENT_SECRET=${form.value.clientSecret}
  INTELLITOGGLE_TENANT_ID=${userStatus?.tenantId || ''}`;

  const blob = new Blob([envContent], { type: 'text/plain;charset=utf-8' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = 'dartstream.env';
  link.click();
  URL.revokeObjectURL(link.href);
}

</script>
