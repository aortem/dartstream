<template>
  <aside class="w-64 h-full bg-white border-r flex flex-col dashboard-sidebar">
    <!-- Scrollable Content Area -->

    <div class="flex-1 px-4 py-6 relative overflow-y-auto">
      <button v-if="projectCount > 0" @click="toggleDropdown"
        class="flex items-center justify-between w-full mb-3 px-4 py-2 bg-white border border-[#F9F9F9] rounded-[14px] shadow-sm hover:bg-gray-50">
        <div class="flex items-center gap-2">
          <div class="flex items-center justify-center w-9 h-9 bg-[#F9F9F9] rounded-[9px] bold text-sm font-medium">
            {{ selectedProject?.initial || "P" }}
          </div>
          <span>{{ projects[0]?.name || "Unnamed Project" }}</span>
        </div>

        <svg :class="{ 'rotate-180': open }" class="w-4 h-4 transition-transform" fill="none" stroke="currentColor"
          stroke-width="2" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
        </svg>
      </button>
      <button v-else @click="createProject"
        class="bg-[#42489E] text-white px-4 w-full mt-3 py-2 rounded-[8px] flex items-center gap-2 mb-2">
        <img src="/assets/images/add.png" alt="" class="w-auto" />
        Create new project
      </button>

      <!-- Dropdown Menu -->
      <div v-if="open"
        class="absolute left-0 z-10 w-[95%] mt-1 ms-2 bg-white border border-[#F9F9F9] rounded-[14px] shadow-lg p-2">
        <!-- Projects List -->
        <div v-for="project in projects" :key="project.name" @click="selectProject(project)"
          class="flex items-center justify-between px-4 py-2 hover:bg-gray-100 cursor-pointer border-b border-gray-200">
          <div class="flex items-center gap-2">
            <div class="flex items-center justify-center w-9 h-9 bg-[#F9F9F9] rounded-[9px] bold text-sm font-medium">
              {{ project.initial || "P" }}
            </div>
            <span>{{ project.name }}</span>
          </div>
          <span class="text-[11px]">{{ project?.flags }} Flags</span>
        </div>

        <button v-if="showCreateButton" @click="createProject"
          class="bg-[#42489E] text-white px-4 w-full mt-3 py-2 rounded-[8px] flex items-center gap-2">
          <img src="/assets/images/add.png" alt="" class="w-auto" />
          Create new project
        </button>
      </div>

      <!-- Main Menu Section -->
      <div class="text-xs text-gray-400 uppercase mb-3">Main Menu</div>

      <nav class="space-y-2">
        <NuxtLink to="/dashboard" :class="[
          'flex items-center space-x-3 px-2 py-2 transition',
          $route.path === '/dashboard'
            ? 'bg-[#E5E5E5] rounded-[30px] text-black'
            : 'text-gray-700 hover:text-black hover:bg-gray-100 rounded-md',
        ]">
          <img src="/assets/images/dashboard.png" alt="" class="w-5 h-5" />
          <span>Dashboard</span>
        </NuxtLink>

        <NuxtLink to="/dashboard/feature-flags" :class="[
          'flex items-center space-x-3 px-2 py-2 transition dashboard-feature-flag',
          $route.path === '/dashboard/feature-flags'
            ? 'bg-[#E5E5E5] rounded-[30px] text-black'
            : 'text-gray-700 hover:text-black hover:bg-gray-100 rounded-md',
        ]">
          <img src="/assets/images/flag.png" alt="" class="w-5 h-5" />
          <span>Feature Flags</span>
        </NuxtLink>

        <NuxtLink to="/dashboard/experiments" :class="[
          'flex items-center space-x-3 px-2 py-2 transition dashboard-experiment',
          $route.path === '/dashboard/experiments'
            ? 'bg-[#E5E5E5] rounded-[30px] text-black'
            : 'text-gray-700 hover:text-black hover:bg-gray-100 rounded-md',
        ]">
          <img src="/assets/images/envir.png" alt="" class="w-5 h-5" />
          <span>Experiments</span>
        </NuxtLink>

        <NuxtLink to="/dashboard/_analytics" :class="[
          'flex items-center space-x-3 px-2 py-2 transition',
          $route.path === '/dashboard/analytics'
            ? 'bg-[#E5E5E5] rounded-[30px] text-black'
            : 'text-gray-700 hover:text-black hover:bg-gray-100 rounded-md',
        ]">
          <img src="/assets/images/analytics.png" alt="" class="w-5 h-5" />
          <span>Analytics</span>
        </NuxtLink>

        <NuxtLink to="/dashboard/_audit-logs" :class="[
          'flex items-center space-x-3 px-2 py-2 transition dashboard-audits',
          $route.path === '/dashboard/audit-logs'
            ? 'bg-[#E5E5E5] rounded-[30px] text-black'
            : 'text-gray-700 hover:text-black hover:bg-gray-100 rounded-md',
        ]">
          <img src="/assets/images/timer.png" alt="" class="w-5 h-5" />
          <span>Audit Logs</span>
        </NuxtLink>
      </nav>

      <!-- Divider -->
      <div class="my-4 border-t border-gray-200"></div>

      <!-- Preferences Section -->
      <div class="text-xs text-gray-500 uppercase mb-3">Preferences</div>

      <nav class="space-y-2">
        <NuxtLink to="/dashboard/setting" :class="[
          'flex items-center space-x-3 px-2 py-2 transition dashboard-settings',
          $route.path === '/dashboard/setting'
            ? 'bg-[#E5E5E5] rounded-[30px] text-black'
            : 'text-gray-700 hover:text-black hover:bg-gray-100 rounded-md',
        ]">
          <img src="/assets/images/setting.png" alt="" class="w-5 h-5" />
          <span>Settings</span>
        </NuxtLink>

        <NuxtLink to="/dashboard/support" :class="[
          'flex items-center space-x-3 px-2 py-2 transition',
          $route.path === '/dashboard/support'
            ? 'bg-[#E5E5E5] rounded-[30px] text-black'
            : 'text-gray-700 hover:text-black hover:bg-gray-100 rounded-md',
        ]">
          <img src="/assets/images/support.png" alt="" class="w-5 h-5" />
          <span>Support / Docs</span>
        </NuxtLink>
      </nav>
    </div>

    <div class="mt-auto px-4 py-2" v-if="version">
      <div class="flex items-center space-x-2 text-gray-500 hover:text-red-600 transition w-full">
        <span>version: <b>{{ version }}</b></span>
      </div>
    </div>
  </aside>
  <!-- Modal -->
  <div v-if="showModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl p-6 max-w-lg w-full relative">
      <!-- ❌ Close Icon (Top-Right) -->
      <button @click="closeModal" class="absolute top-4 right-4 text-gray-500 hover:text-gray-700 text-xl">
        &times;
      </button>

      <div class="flex justify-center mb-4">
        <img src="/assets/images/logo.png" alt="Logo" class="h-10" />
      </div>

      <!-- Heading -->
      <h2 class="text-xl text-center mb-2">
        🎉 Let’s Start By Creating Your first Project 🎉
      </h2>
      <form @submit.prevent="onSubmit">
        <div class="mt-3">
          <label class="block font-medium">
            Name <span class="text-[#E93544] font-medium">*</span>
          </label>
          <input v-model="form.name"
            class="w-full border rounded-[8px] px-3 py-2 text-gray-700 focus:outline-none focus:ring-0 focus:border-gray-300"
            placeholder="Enter name" />
        </div>

        <!-- <div class="mt-3">
          <label class="block font-medium">
            Environment Setup <span class="text-[#E93544] font-medium">*</span>
          </label>
          <select v-model="form.environmentSetup"
            class="w-full border rounded-[8px] px-3 py-2 text-gray-700 focus:outline-none focus:ring-0 focus:border-gray-300">
            <option value="">Select Environment</option>
            <option value="dev">Dev</option>
            <option value="prod">Prod</option>
          </select>
        </div> -->

        <div class="mt-3">
          <label class="block font-medium">
            Description <span class="text-red-500 font-medium">*</span>
          </label>
          <textarea v-model="form.description"
            class="w-full border rounded-[8px] px-3 py-2 focus:outline-none focus:ring-0 focus:border-gray-300"
            placeholder="Message..." maxlength="400"></textarea>
        </div>

        <div class="mt-3 w-full">
          <button type="submit"
            class="px-4 py-2 w-full rounded-[8px] transition duration-150 bg-[#42489E] text-white hover:bg-[#353A89]">
            Create
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useToast } from "vue-toastification";
const { $api } = useNuxtApp();
const toast = useToast();
import { ref } from "vue";

const { setSelectedProject } = useSelectedProject();

const open = ref(false);
const showModal = ref(false);
const showCreateButton = ref(false);
const projects = ref<{ name: string; initial: string; flags: number }[]>([]);
const projectCount = ref(0);
const selectedProject = ref(projects.value[0]);
const version = ref("");

const form = ref({
  name: "",
  description: "",
  environmentSetup: "",
});

interface UserStatus {
  isSandbox: boolean;
  subscriptionStatus?: boolean;
  // add other fields as needed
}
const userStatus = ref<UserStatus | null>(null);

onMounted(() => {
  const rawUserStatus = localStorage.getItem("user_status");
  userStatus.value = rawUserStatus ? JSON.parse(rawUserStatus) : null;
  console.log("userStatus.value?.isSandbox", userStatus.value?.isSandbox);

  if (userStatus.value?.isSandbox) {
    getDemoData();
  }
  console.log("Standard  user", !userStatus.value?.isSandbox, userStatus.value?.subscriptionStatus);
  if (!userStatus.value?.isSandbox && userStatus.value?.subscriptionStatus) {
    getProjects();
  }
  getVersion();
});

const onSubmit = async () => {
  const { name, description, environmentSetup } = form.value;

  try {
    const res = await $api("/api/projects/", {
      method: "POST",
      body: {
        description,
        name,
      },
    });
    if (res) {
      open.value = false;
      form.value = {
        name: "",
        description: "",
        environmentSetup: "",
      };
      toast.success("Project is created!");
      showModal.value = false;
      getProjects();


      // localStorage.setItem("selectedProjectId", res.id);

      setSelectedProject(res.id);
    }
  } catch (error: any) {
    console.error("Error:", error.data || error.message);
    toast.error(
      error.data?.message || "Project creation failed. Please try again."
    );
  }
};

const createProject = () => {
  if (!userStatus) {
    toast.error("User Status not Found!");
    return;
  }
  if (userStatus.value?.isSandbox) {
    toast.warning("Sandbox user cannot create a flag.");
    return;
  }

  showModal.value = true;
};
const closeModal = () => {
  showModal.value = false;
};
function toggleDropdown() {
  open.value = !open.value;
}

const selectProject = (project: any) => {
  // localStorage.setItem("selectedProjectId", project.id);
  setSelectedProject(project.id)
  selectedProject.value = project;
  open.value = false;
  setSelectedProject(project.id)
};

const getProjects = async () => {
  try {
    const res = await $api("/api/projects/", {
      method: "GET",
    });

    if (res.success) {
      console.log(1);

      projectCount.value = res.data.total_projects || 0;
      projects.value = res.data.projects || [];

      if (projects.value.length > 0) {
        console.log(2);

        const firstProjectId = projects.value[0]?.id;
        console.log(3, firstProjectId);

        // localStorage.setItem("selectedProjectId", firstProjectId) 
        setSelectedProject(firstProjectId)
        selectedProject.value = projects.value[0]
      }
    }
  } catch (error) {
    console.error("Error fetching projects:", error);
  }
}

const getVersion = async () => {
  try {
    const res = await $api("/version", {
      method: "GET",
    });

    if (res) {
      console.log(res);
      version.value = res.version;
    }
  } catch (error) {
    console.error("Error fetching version:", error);
  }
};

const getDemoData = async () => {
  try {
    const demoData = await $api("/api/sandbox/demo-data", { method: "GET" });
    console.log("demoData", demoData);

    if (demoData && demoData.project) {
      console.log(demoData.project);

      projects.value = [{ name: demoData.project?.name, initial: "P", flags: demoData.project?.subscription?.maxFlags }];
      projectCount.value = 1;
      setSelectedProject(demoData?.project?.id)
    } else {
      toast.error("Flags not found!");
    }
  } catch (e) {
    toast.error("Failed to fetch demo data.");
  }
};
</script>
