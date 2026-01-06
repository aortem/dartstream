<template>
  <div class="border rounded-[16px] p-6 bg-white">
    <div class="flex gap-3">
      <div
        class="bg-[#F3F4F6] rounded-full p-2 h-12 w-12 flex justify-center items-center"
      >
        <img src="/assets/images/envir.png" alt="" class="h-6 w-6" />
      </div>
      <div>
        <h1 class="font-satoshi font-medium text-xl font-bold">
          Percentage rollouts
        </h1>
        <div class="text-sm text-[#7D7F82]">
          Gradually release {{ flagName || "this flag" }} to a subset of users
        </div>
      </div>
    </div>
    <img src="/assets/images/divider2.png" alt="" class="w-full mt-4" />

    <div
      v-if="!hasContext"
      class="mt-6 bg-gray-50 border border-dashed border-gray-200 rounded-lg p-4 text-sm text-gray-600"
    >
      Select a project and feature flag to configure staged rollouts.
    </div>

    <div v-else>
      <p class="text-sm text-gray-500 mt-5">
        <span v-if="hasRollout">
          Rolling out to
          <strong>{{ currentRollout?.percentage }}%</strong>
          of users bucketed by
          <strong>{{ currentRollout?.bucketBy }}</strong>
          {{ currentRollout?.seed ? 'with seed "' + currentRollout?.seed + '"' : '' }}
        </span>
        <span v-else>No staged rollout configured yet.</span>
      </p>

      <div
        v-if="loading"
        class="mt-5 rounded-lg bg-blue-50 text-blue-900 text-sm px-3 py-2"
      >
        Loading rollout configuration...
      </div>

      <form v-else class="mt-5 space-y-5" @submit.prevent="saveRollout">
        <div>
          <label class="block font-medium text-gray-800">
            Traffic percentage <span class="text-[#0062FF]">*</span>
          </label>
          <div class="flex flex-col sm:flex-row sm:items-center gap-3 mt-2">
            <input
              type="range"
              min="0"
              max="100"
              v-model.number="form.percentage"
              class="w-full"
              :disabled="saving || deleting"
            />
            <input
              type="number"
              min="0"
              max="100"
              v-model.number="form.percentage"
              class="w-full sm:w-28 border border-gray-200 rounded-[8px] px-3 py-2"
              :disabled="saving || deleting"
            />
            <span class="text-sm text-gray-500">%</span>
          </div>
          <p v-if="percentageError" class="text-xs text-red-600 mt-1">
            {{ percentageError }}
          </p>
        </div>

        <div>
          <label class="block font-medium text-gray-800">
            Bucket users by <span class="text-[#0062FF]">*</span>
          </label>
          <input
            v-model.trim="form.bucketBy"
            class="w-full border border-gray-200 rounded-[8px] px-3 py-2 mt-2"
            placeholder="userId"
            :disabled="saving || deleting"
          />
          <p class="text-xs text-gray-500 mt-1">
            Attribute used to consistently hash users. Defaults to <code>userId</code>.
          </p>
        </div>

        <div>
          <label class="block font-medium text-gray-800">
            Hash seed <span class="text-gray-400 text-xs">(optional)</span>
          </label>
          <input
            v-model.trim="form.seed"
            class="w-full border border-gray-200 rounded-[8px] px-3 py-2 mt-2"
            placeholder="default-seed"
            :disabled="saving || deleting"
          />
          <p class="text-xs text-gray-500 mt-1">
            Provide a seed to keep rollout cohorts stable across deployments.
          </p>
        </div>

        <div class="flex flex-col gap-3 sm:flex-row">
          <button
            type="submit"
            class="border bg-[#42489E] text-white rounded-[8px] w-full p-3 flex justify-center gap-2 text-sm"
            :disabled="!canSubmit || saving"
          >
            <span v-if="saving">Saving...</span>
            <span v-else>Save rollout</span>
          </button>
          <button
            type="button"
            class="border border-gray-300 text-gray-700 rounded-[8px] w-full p-3 flex justify-center gap-2 text-sm"
            :class="{ 'opacity-60 cursor-not-allowed': !hasRollout || deleting }"
            :disabled="!hasRollout || deleting"
            @click="removeRollout"
          >
            <span v-if="deleting">Removing...</span>
            <span v-else>Disable rollout</span>
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref, watch } from "vue";
import { useToast } from "vue-toastification";

interface RolloutForm {
  percentage: number | null;
  bucketBy: string;
  seed: string;
}

interface RolloutConfig {
  percentage: number;
  bucketBy: string;
  seed?: string | null;
}

const props = defineProps<{
  projectId?: string | null;
  flagKey?: string | null;
  flagName?: string;
}>();

const { $api } = useNuxtApp();
const toast = useToast();

const form = reactive<RolloutForm>({
  percentage: null,
  bucketBy: "userId",
  seed: "",
});

const loading = ref(false);
const saving = ref(false);
const deleting = ref(false);
const currentRollout = ref<RolloutConfig | null>(null);

const hasContext = computed(() => Boolean(props.projectId && props.flagKey));
const hasRollout = computed(() => currentRollout.value !== null);

const percentageError = computed(() => {
  if (form.percentage === null) return "Enter a percentage between 0 and 100.";
  if (form.percentage < 0 || form.percentage > 100)
    return "Percentage must be between 0 and 100.";
  return "";
});

const canSubmit = computed(
  () => hasContext.value && !percentageError.value && form.percentage !== null
);

const applyRolloutToForm = (rollout: RolloutConfig | null) => {
  form.percentage = rollout?.percentage ?? null;
  form.bucketBy = rollout?.bucketBy ?? "userId";
  form.seed = rollout?.seed ?? "";
};

const resetForm = () => applyRolloutToForm(currentRollout.value);

const parseRolloutFromPayload = (payload: any): RolloutConfig | null => {
  if (!payload) return null;
  if (payload.rollout) return payload.rollout as RolloutConfig;
  if (payload.data?.rollout) return payload.data.rollout as RolloutConfig;
  if (payload.data?.flag?.rollout)
    return payload.data.flag.rollout as RolloutConfig;
  if (payload.flag?.rollout) return payload.flag.rollout as RolloutConfig;
  return null;
};

const rolloutUrl = computed(() => {
  if (!props.projectId || !props.flagKey) return null;
  return `/api/flags/projects/${props.projectId}/flags/${props.flagKey}/rollout`;
});

const loadRollout = async () => {
  if (!hasContext.value || !rolloutUrl.value) return;
  loading.value = true;
  try {
    const response = await $api(rolloutUrl.value, { method: "GET" });
    const rollout = parseRolloutFromPayload(response);
    currentRollout.value = rollout;
    applyRolloutToForm(rollout);
  } catch (error: any) {
    currentRollout.value = null;
    applyRolloutToForm(null);
    const message =
      error?.data?.message || error?.message || "Unable to load rollout.";
    toast.error(message);
  } finally {
    loading.value = false;
  }
};

const saveRollout = async () => {
  if (!canSubmit.value || !rolloutUrl.value || form.percentage === null) {
    toast.error("Enter a valid percentage before saving.");
    return;
  }

  saving.value = true;
  try {
    const payload = {
      percentage: Math.round(form.percentage),
      bucketBy: form.bucketBy?.trim() || "userId",
      seed: form.seed?.trim() || undefined,
    };
    const response = await $api(rolloutUrl.value, {
      method: "POST",
      body: payload,
    });
    const rollout = parseRolloutFromPayload(response);
    currentRollout.value = rollout;
    applyRolloutToForm(rollout);
    toast.success("Staged rollout saved.");
  } catch (error: any) {
    const message =
      error?.data?.message || error?.message || "Failed to save rollout.";
    toast.error(message);
  } finally {
    saving.value = false;
  }
};

const removeRollout = async () => {
  if (!hasRollout.value || !rolloutUrl.value) return;
  deleting.value = true;
  try {
    await $api(rolloutUrl.value, { method: "DELETE" });
    currentRollout.value = null;
    applyRolloutToForm(null);
    toast.success("Staged rollout disabled.");
  } catch (error: any) {
    const message =
      error?.data?.message || error?.message || "Failed to remove rollout.";
    toast.error(message);
  } finally {
    deleting.value = false;
  }
};

watch(
  () => [props.projectId, props.flagKey],
  () => {
    currentRollout.value = null;
    resetForm();
    if (hasContext.value) {
      loadRollout();
    }
  },
  { immediate: true }
);
</script>
