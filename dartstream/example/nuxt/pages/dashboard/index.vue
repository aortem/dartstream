<script setup lang="ts">
import CreateFlag from "~/components/feature-flag/createflag.vue";
import { useUser } from "@/composables/useUser";
import Main from "~/components/dashboard/main.vue";
import { useToast } from "vue-toastification";


const { user, fetchSession } = useUser();
const toast = useToast();
const { $api } = useNuxtApp();
const isModalOpen = ref(false);
const { selectedProjectId, setSelectedProject } = useSelectedProject();
const isSandbox = ref(false);
const totalFlags = ref("");
const flagsList = ref([]);
const selectedFlag = ref<Flag | null>(null);
const modalMode = ref("create");

definePageMeta({
  layout: "dashboard",
});

interface UserStatus {
  isSandbox: boolean;
  subscriptionStatus?: string;
}
const userStatus = ref<UserStatus | null>(null);

onMounted(async () => {
  await fetchSession(); // 🔑 wait for cookie session

  if (!user.value) return; // 🚨 stop if not logged in

  const rawUserStatus = localStorage.getItem("user_status");
  userStatus.value = rawUserStatus ? JSON.parse(rawUserStatus) : null;

  if (selectedProjectId.value) {
    getFlags(selectedProjectId.value);
  }else{
    isSandbox.value = userStatus?.isSandbox;
  
    if (userStatus?.isSandbox) {
      getDemoData();
    }
  }
});


watch(selectedProjectId, (newId) => {
  if (newId) {
    getFlags(newId);
  }
});

const getFlags = async (projectId) => {
  if (!user.value) return; // 🚨 prevent null uid calls

  try {
    const res = await $api(
      `/api/flags/projects/${projectId}/flags`,
      { method: "GET" }
    );

    totalFlags.value = res.flags.length;
    flagsList.value = res.flags;
  } catch (error) {
    console.error("Error fetching flags:", error);
  }
};


const getDemoData = async () => {
  try {
    const demoData = await $api("/api/sandbox/demo-data", { method: "GET" });
    if (demoData && demoData.flags) {
      flagsList.value = demoData.flags; // ✅ Set the reactive value
      totalFlags.value = demoData.activeFlags;
    } else {
      toast.error("Flags not found!");
    }
  } catch (e) {
    toast.error("Failed to fetch demo data.");
  }
};

const openFlag = () => {
  
  if (userStatus.value?.isSandbox) {
    isModalOpen.value = false;
    toast.warning("Sandbox user cannot create a flag.");
  }
  if (
    !userStatus.value?.isSandbox &&
    userStatus.value?.subscriptionStatus === "active"
  ) {
    if (selectedProjectId.value) {
selectedFlag.value = null
      isModalOpen.value = true;
    } else {
      toast.error("Please create your project first!");
      return;
    }
  }
};

// ✅ Handle success
const handleSubmitted = (message: string) => {
  toast.success(message || "Flag created successfully 🎉");
  isModalOpen.value = false; // close modal
};

// ✅ Handle error
const handleError = (message: string) => {
  toast.error(message || "Failed to create flag ❌");
};

const onOpenFlag = ({ modalMode: mode, selectedFlag: flag }: { modalMode: "create" | "edit"; selectedFlag?: Flag }) => {
  modalMode.value = mode;
  selectedFlag.value = flag ?? null;
  openFlag();
};
</script>

<template>
  <div class="relative mt-4">
    <div class="min-h-screen p-6">
      <div class="flex items-center justify-between mb-6">
        <div>
          <h1 class="text-2xl">Dashboard</h1>
          <p class="text-sm text-gray-500">Overview of your flags and more</p>
        </div>
        <div class="">
          <button
            @click="openFlag"
            class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2 dashboard-create-flag"
          >
            <img data-cy="button-create-flag" src="/assets/images/add.png" alt="" class="w-auto" />
            Create Flag
          </button>
        </div>
      </div>
      <!-- Main Component -->
      <Main :totalFlags="totalFlags" :flagsList="flagsList"  @openFlag="onOpenFlag"  @refreshFlags="() => getFlags(selectedProjectId.value)" />
      <!-- Create Flag -->
      <CreateFlag
        :isOpen="isModalOpen"
        @close="isModalOpen = false"
        @submitted="handleSubmitted"
        @error="handleError"
        :flag="selectedFlag"
        :mode="modalMode"
         @refreshFlags="getFlags"
      />
    </div>
  </div>
</template>
