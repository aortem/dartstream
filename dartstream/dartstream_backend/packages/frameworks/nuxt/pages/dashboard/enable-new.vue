<script setup lang="ts">
import { computed, ref, watch } from "vue";
import { useToast } from "vue-toastification";
import KeyDetail from "~/components/feature-flag/keydetail.vue";
import UsageBarChart from "~/components/feature-flag/barchart.vue";
import Setting from "~/components/feature-flag/setting.vue";
import Targeting from "~/components/feature-flag/targeting.vue";
import Percentage from "~/components/feature-flag/percentage.vue";
import type { FlagDetail } from "~/types/flags";

definePageMeta({
  layout: "dashboard",
});

const { $api } = useNuxtApp();
const route = useRoute();
const router = useRouter();
const toast = useToast();
const { selectedProjectId } = useSelectedProject();

const activeTab = ref<"details" | "targeting" | "percentage">("details");
const isOn = ref(false);
const isToggling = ref(false);
const isLoadingFlag = ref(false);
const flagDetails = ref<FlagDetail | null>(null);
const flagError = ref<string | null>(null);

const flagKey = computed(() => {
  const queryValue = route.query.flagKey;
  if (typeof queryValue === "string" && queryValue.trim().length > 0) {
    return queryValue.trim();
  }
  return "";
});

const displayName = computed(() => {
  if (flagDetails.value?.name) return flagDetails.value.name;
  const raw = route.query.flagName;
  return typeof raw === "string" && raw.length > 0 ? raw : "Feature Flag";
});

const displayKey = computed(() => flagDetails.value?.key ?? flagKey.value ?? "-");
const environmentLabel = computed(() => flagDetails.value?.environment || "production");
const statusLabel = computed(() => (isOn.value ? "On" : "Off"));

const missingContextMessage = computed(() => {
  if (!flagKey.value) {
    return "Select a flag from the Feature Flags list.";
  }
  if (!selectedProjectId.value) {
    return "Select or create a project to view flag details.";
  }
  return null;
});

const loadFlagDetails = async () => {
  if (missingContextMessage.value) {
    flagDetails.value = null;
    flagError.value = missingContextMessage.value;
    return;
  }

  flagLoading.value = true;
  flagError.value = null;
  try {
    const response = await $api(
      `/api/flags/projects/${selectedProjectId.value}/flags/${flagKey.value}`,
      { method: "GET" },
    );
    const data = response?.data?.flag ?? response?.flag ?? response;
    flagDetails.value = data ?? null;
    isOn.value = (data?.status ?? "").toLowerCase() === "active";
  } catch (error: any) {
    flagDetails.value = null;
    const apiMessage =
      error?.data?.message || error?.data?.error || error?.message || "Failed to load flag details.";
    flagError.value = apiMessage;
    toast.error(apiMessage);
  } finally {
    flagLoading.value = false;
  }
};

const flagLoading = ref(false);

watch(
  () => [flagKey.value, selectedProjectId.value],
  () => {
    loadFlagDetails();
  },
  { immediate: true },
);

const toggleFlagStatus = async () => {
  if (!flagDetails.value || !selectedProjectId.value || !flagKey.value || isToggling.value) {
    return;
  }
  const nextState = isOn.value ? "disable" : "enable";
  isToggling.value = true;
  try {
    const response = await $api(
      `/api/flags/projects/${selectedProjectId.value}/flags/${flagKey.value}/${nextState}`,
      { method: "POST" },
    );
    const updatedFlag = response?.data?.flag ?? response?.flag ?? response;
    flagDetails.value = updatedFlag ?? null;
    isOn.value = (updatedFlag?.status ?? "").toLowerCase() === "active";
    toast.success(isOn.value ? "Flag enabled" : "Flag disabled");
  } catch (error: any) {
    toast.error(error?.data?.message || `Unable to ${nextState} this flag.`);
  } finally {
    isToggling.value = false;
  }
};

const goToFlagsList = () => {
  router.push("/dashboard/feature-flags");
};
</script>

<template>
  <div class="container mx-auto p-4">
    <div
      v-if="missingContextMessage"
      class="bg-white border border-dashed border-gray-200 rounded-xl p-6 text-center text-gray-600"
    >
      <p class="text-lg font-medium mb-2">No flag selected</p>
      <p class="text-sm">
        {{ missingContextMessage }}
      </p>
    </div>
    <div v-else class="flex flex-wrap -mx-2">
      <div class="w-full md:w-9/12 px-2">
        <div class="flex gap-3">
          <img src="/assets/images/enable.png" alt="" class="w-auto" />
          <div>
            <h1 class="text-2xl font-bold">
              {{ displayName }}
            </h1>
            <p class="text-sm text-gray-500">{{ environmentLabel }} environment</p>
          </div>
        </div>
        <div class="text-sm text-gray-500 mb-2 flex gap-2 mt-3 items-center">
          <div class="flex gap-2 items-center text-[#5a5c60] cursor-pointer" @click="goToFlagsList">
            <img src="/assets/images/mail.png" alt="" class="w-auto" />
            <span>Flag List</span>
          </div>
          /
          <div class="flex gap-2">
            <img src="/assets/images/mail.png" alt="" class="w-auto" /><span>
              {{ displayKey || "-" }}
            </span>
          </div>
        </div>
        <div class="p-6 bg-white rounded shadow-md w-full">
          <div
            v-if="flagLoading"
            class="mb-4 rounded-lg bg-blue-50 text-blue-900 px-3 py-2 text-sm"
          >
            Loading flag details...
          </div>
          <div
            v-else-if="flagError"
            class="mb-4 rounded-lg bg-red-50 text-red-700 px-3 py-2 text-sm"
          >
            {{ flagError }}
          </div>
          <div v-else>
            <div class="flex justify-between items-center mb-4">
              <div>
                <h1 class="text-xl text-gray-800">{{ displayName }}</h1>
                <p class="text-xs text-gray-500 capitalize">Status: {{ statusLabel }}</p>
              </div>
              <div class="flex items-center gap-2">
                <div
                  class="relative inline-flex items-center h-5 w-10 rounded-full cursor-pointer transition-colors duration-300"
                  :class="isOn ? 'bg-green-500' : 'bg-gray-300'"
                  :aria-disabled="isToggling"
                  @click="toggleFlagStatus"
                >
                  <span
                    class="inline-block w-5 h-5 transform bg-white rounded-full shadow transition-transform duration-300"
                    :class="isOn ? 'translate-x-5' : 'translate-x-0'"
                  ></span>
                </div>
                <div class="text-gray-400">{{ statusLabel }}</div>
                <button
                  class="px-3 py-1 border border-gray rounded-[6px] text-sm hover:bg-gray-50 flex gap-3 disabled:opacity-50"
                  :disabled="isToggling"
                  type="button"
                >
                  Roll Back<img src="/assets/images/back.png" alt="" class="w-auto" />
                </button>
              </div>
            </div>

            <div class="rounded-[8px] w-full">
              <div class="flex bg-[#F5F7FA] p-1 rounded-[8px] overflow-hidden mb-4">
                <button
                  class="w-1/3 py-2 text-center text-sm rounded-[8px] font-medium transition-all"
                  :class="activeTab === 'details' ? 'bg-white text-gray-900 shadow' : 'text-gray-500'"
                  @click="activeTab = 'details'"
                >
                  Details
                </button>
                <button
                  class="w-1/3 py-2 text-center text-sm rounded-[8px] font-medium transition-all"
                  :class="activeTab === 'targeting' ? 'bg-white text-gray-900 shadow' : 'text-gray-500'"
                  @click="activeTab = 'targeting'"
                >
                  Targeting Rules
                </button>
                <button
                  class="w-1/3 py-2 text-center text-sm rounded-[8px] font-medium transition-all"
                  :class="activeTab === 'percentage' ? 'bg-white text-gray-900 shadow' : 'text-gray-500'"
                  @click="activeTab = 'percentage'"
                >
                  Percentage Rollouts
                </button>
              </div>
            </div>

            <div v-if="isLoadingFlag" class="text-sm text-gray-500 py-6">
              Loading flag details...
            </div>
            <div v-else>
              <div v-if="activeTab === 'details'">
                <UsageBarChart />
                <div class="flex justify-between mt-4 border-b pb-5">
                  <div class="w-75">
                    <p class="semibold">Kill</p>
                    <p class="text-gray-400 text-sm">
                      Turning off the flag immediately disables it across all environments.
                    </p>
                  </div>
                  <div class="w-50">
                    <button
                      class="mt-2 inline-flex items-center gap-2 bg-red-100 text-red-600 text-sm px-4 py-2 rounded-[8px] hover:bg-red-200 whitespace-nowrap"
                      type="button"
                    >
                      Kill Flag
                    </button>
                  </div>
                </div>
                <div class="flex justify-between mt-4 border-b pb-5">
                  <div class="w-75">
                    <p class="semibold">Clone The Flag</p>
                    <p class="text-gray-400 text-sm">
                      Clone the targeting configuration and apply it to a different project or environment.
                    </p>
                  </div>
                  <div class="w-50">
                    <button
                      class="mt-2 inline-flex items-center gap-2 bg-white border-gray rounded-[8px] text-[#525866] text-sm px-4 py-2 rounded hover:bg-gray-100 whitespace-nowrap"
                      type="button"
                    >
                      Clone this flag
                    </button>
                  </div>
                </div>
                <div class="flex justify-between mt-4">
                  <div class="w-75">
                    <p class="semibold">Archive flag</p>
                    <p class="text-gray-400 text-sm">
                      Archive completed experiments to keep your workspace tidy.
                    </p>
                  </div>
                  <div class="w-50">
                    <button
                      class="mt-2 inline-flex items-center gap-2 bg-white border-gray rounded-[8px] text-red-600 text-sm px-4 py-2 rounded hover:bg-gray-100 whitespace-nowrap"
                      type="button"
                    >
                      Archive
                    </button>
                  </div>
                </div>
              </div>
              <div v-else-if="activeTab === 'targeting'">
                <Targeting :flag-key="flagKey" />
              </div>
              <div v-else>
                <Percentage :project-id="selectedProjectId" :flag-key="flagKey" :flag-name="displayName" />
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="w-full md:w-3/12 px-2 mt-4 md:mt-0">
        <KeyDetail :flag="flagDetails" />
      </div>
    </div>
  </div>
</template>
