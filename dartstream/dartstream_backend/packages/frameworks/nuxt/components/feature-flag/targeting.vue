<template>
  <div class="border rounded-[16px] p-6">
    <div class="flex gap-3">
      <div class="bg-[#F3F4F6] rounded-full p-2 h-12 w-12 flex justify-center items-center">
        <img src="/assets/images/envir.png" alt="" class="h-6 w-6" />
      </div>
      <div>
        <h1 class="font-satoshi font-medium text-xl font-bold">Targeting Rules</h1>
        <div class="text-sm text-[#7D7F82]">Add conditions</div>
      </div>
    </div>

    <img src="/assets/images/divider2.png" alt="" class="w-full mt-4" />

    <div v-if="!flagKey" class="text-sm text-gray-500 mt-6">
      Select a flag to configure targeting rules.
    </div>

    <template v-else>
      <div
        v-if="isAttributesUnavailable"
        class="mt-6 border border-amber-200 bg-amber-50 text-amber-900 rounded-[10px] p-4 text-sm"
      >
        Targeting attributes are temporarily unavailable. Please retry after the backend issue is resolved.
      </div>
      <form class="mt-6 space-y-4" @submit.prevent="handleSubmit">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block font-medium">
              Attribute
              <span class="text-[#0062FF]">*</span>
            </label>
            <input
              v-model="form.attribute"
              list="attribute-options"
              class="w-full border-gray rounded-[8px] px-3 py-2 text-gray-700"
              placeholder="e.g. user.email"
              :disabled="isSavingRule || isAttributesUnavailable"
            />
            <datalist id="attribute-options">
              <option
                v-for="option in attributeOptions"
                :key="option.key"
                :value="option.key"
              >
                {{ option.description || option.key }}
              </option>
            </datalist>
            <p v-if="attributeMeta?.description" class="text-xs text-gray-500 mt-1">
              {{ attributeMeta.description }}
            </p>
            <p
              v-if="attributeMeta?.allowedValues?.length"
              class="text-xs text-gray-500 mt-1"
            >
              Allowed: {{ attributeMeta.allowedValues?.join(", ") }}
            </p>
          </div>

          <div>
            <label class="block font-medium">
              Operator
              <span class="text-[#0062FF]">*</span>
            </label>
            <select
              v-model="form.operator"
              class="w-full border-gray rounded-[8px] px-3 py-2 text-gray-700"
              :disabled="isSavingRule || isAttributesUnavailable"
            >
              <option v-for="option in operatorOptions" :key="option.value" :value="option.value">
                {{ option.label }}
              </option>
            </select>
          </div>
        </div>

        <div>
          <label class="block font-medium">
            Value
            <span class="text-[#0062FF]">*</span>
          </label>
            <textarea
              v-if="usesListInput"
              v-model="form.matchValue"
              class="w-full border-gray rounded-[8px] px-3 py-2 text-gray-700"
              placeholder="Separate values with commas"
              rows="2"
              :disabled="isSavingRule || isAttributesUnavailable"
            />
            <input
              v-else
              v-model="form.matchValue"
              class="w-full border-gray rounded-[8px] px-3 py-2 text-gray-700"
              :placeholder="valuePlaceholder"
              :disabled="isSavingRule || isAttributesUnavailable"
            />
          <p class="text-xs text-gray-500 mt-1">
            {{ valueHelpText }}
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block font-medium">Label</label>
            <input
              v-model="form.name"
              class="w-full border-gray rounded-[8px] px-3 py-2 text-gray-700"
              placeholder="Optional friendly label"
              :disabled="isSavingRule || isAttributesUnavailable"
            />
          </div>
          <div>
            <label class="block font-medium">Description</label>
            <input
              v-model="form.description"
              class="w-full border-gray rounded-[8px] px-3 py-2 text-gray-700"
              placeholder="Optional note"
              :disabled="isSavingRule || isAttributesUnavailable"
            />
          </div>
        </div>

        <div v-if="formError" class="text-sm text-red-600">
          {{ formError }}
        </div>

        <div class="flex flex-wrap gap-3">
          <button
            type="submit"
            class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] disabled:opacity-60"
            :disabled="!isFormValid || isSavingRule || isAttributesUnavailable"
          >
            {{ editingRuleId ? "Update Rule" : "Add Rule" }}
          </button>
          <button
            v-if="editingRuleId"
            type="button"
            class="bg-[#F5F7FA] text-gray-700 px-4 py-2 rounded-[8px]"
            @click="resetForm"
          >
            Cancel edit
          </button>
        </div>
      </form>

      <div class="mt-8">
        <div v-if="isLoadingRules" class="text-sm text-gray-500">Loading rules…</div>
        <div v-else-if="!rules.length" class="text-sm text-gray-500">
          No targeting rules yet. Add your first condition above.
        </div>
        <div v-else class="space-y-3">
          <div
            v-for="rule in rules"
            :key="rule.id"
            class="border border-gray-200 rounded-[10px] p-4 flex flex-col gap-2"
          >
            <div class="flex justify-between items-start gap-3">
              <div>
                <p class="text-sm text-[#0E121B] font-medium">
                  {{ rule.attribute }}
                  <span class="text-[#7D7F82] font-normal ml-1">
                    {{ operatorLabel(rule.operator) }}
                  </span>
                  <span class="font-semibold ml-1">{{ formatRuleValue(rule) }}</span>
                </p>
                <p v-if="rule.description" class="text-xs text-gray-500 mt-1">
                  {{ rule.description }}
                </p>
              </div>
              <div class="flex gap-2">
                <button
                  type="button"
                  class="px-3 py-1 border border-gray rounded text-xs text-gray-700 hover:bg-gray-50"
                  @click="startEdit(rule)"
                >
                  Edit
                </button>
                <button
                  type="button"
                  class="px-3 py-1 border border-red-200 text-red-600 rounded text-xs hover:bg-red-50"
                  @click="deleteRule(rule)"
                >
                  Delete
                </button>
              </div>
            </div>
            <p class="text-xs text-gray-400">
              Rule ID: {{ rule.id }}
            </p>
          </div>
        </div>
      </div>
    </template>
  </div>
  <transition name="fade">
    <div
      v-if="attributeErrorMessage"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-4"
    >
      <div class="bg-white rounded-[12px] shadow-xl max-w-md w-full p-6">
        <div class="text-lg font-semibold text-gray-800">Unable to reach attributes service</div>
        <p class="text-sm text-gray-600 mt-2">
          {{ attributeErrorMessage }}
        </p>
        <p class="text-xs text-gray-500 mt-2">
          We could not connect to the backend attributes API, so newly created attributes may not be
          available. Please retry later or contact support if the problem persists.
        </p>
        <div class="mt-4 flex justify-end">
          <button
            type="button"
            class="px-4 py-2 bg-[#42489E] text-white rounded-[8px]"
            @click="attributeErrorMessage = ''"
          >
            Got it
          </button>
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup lang="ts">
import { computed, reactive, ref, watch } from "vue";
import { useToast } from "vue-toastification";
import type {
  CustomAttributeDefinition,
  RuleOperator,
  TargetingRule,
  TargetingRulePayload,
} from "~/types/flags";

const props = defineProps<{
  flagKey?: string | null;
}>();

const { $api } = useNuxtApp();
const toast = useToast();
const { selectedProjectId } = useSelectedProject();

const rules = ref<TargetingRule[]>([]);
const attributes = ref<Record<string, CustomAttributeDefinition>>({});
const attributeErrorMessage = ref("");
const isLoadingRules = ref(false);
const isSavingRule = ref(false);
const editingRuleId = ref<string | null>(null);
const formError = ref("");
const telemetryPrefix = "[TargetingRulesUI]";

const form = reactive({
  attribute: "",
  operator: "equals" as RuleOperator,
  matchValue: "",
  name: "",
  description: "",
});

const operatorOptions: { value: RuleOperator; label: string }[] = [
  { value: "equals", label: "equals" },
  { value: "notEquals", label: "does not equal" },
  { value: "contains", label: "contains" },
  { value: "doesNotContain", label: "does not contain" },
  { value: "greaterThan", label: "greater than" },
  { value: "lessThan", label: "less than" },
  { value: "startsWith", label: "starts with" },
  { value: "endsWith", label: "ends with" },
  { value: "matches", label: "matches (regex)" },
  { value: "inList", label: "is in list" },
  { value: "notInList", label: "not in list" },
];

const listOperators: RuleOperator[] = ["inList", "notInList"];
const numericOperators: RuleOperator[] = ["greaterThan", "lessThan"];

const attributeOptions = computed(() =>
  Object.entries(attributes.value).map(([key, meta]) => ({ key, ...meta })),
);
const attributeMeta = computed(() => {
  if (!form.attribute) return null;
  return attributes.value[form.attribute] || null;
});
const isAttributesUnavailable = computed(() => Boolean(attributeErrorMessage.value));
const usesListInput = computed(() => listOperators.includes(form.operator));
const valuePlaceholder = computed(() =>
  numericOperators.includes(form.operator) ? "Enter a number" : "e.g. value",
);
const valueHelpText = computed(() => {
  if (usesListInput.value) return "Separate values with commas.";
  if (numericOperators.includes(form.operator)) return "Numeric comparison based on the provided value.";
  return "Supports strings, numbers or booleans depending on the attribute.";
});
const isFormValid = computed(
  () => Boolean(form.attribute.trim()) && Boolean(form.matchValue.trim()),
);

const operatorLabel = (operator: RuleOperator) => {
  const match = operatorOptions.find((option) => option.value === operator);
  return match?.label ?? operator;
};

const formatRuleValue = (rule: TargetingRule) => {
  if (Array.isArray(rule.value)) return rule.value.join(", ");
  if (typeof rule.value === "object") return JSON.stringify(rule.value);
  return String(rule.value ?? "");
};

const resetForm = () => {
  form.attribute = "";
  form.operator = "equals";
  form.matchValue = "";
  form.name = "";
  form.description = "";
  editingRuleId.value = null;
  formError.value = "";
};

const parseValueForOperator = (operator: RuleOperator, raw: string): TargetingRulePayload["value"] => {
  const trimmed = raw.trim();
  if (!trimmed.length) {
    throw new Error("Value is required.");
  }
  if (listOperators.includes(operator)) {
    return trimmed
      .split(",")
      .map((entry) => entry.trim())
      .filter(Boolean);
  }
  if (numericOperators.includes(operator)) {
    const parsed = Number(trimmed);
    if (Number.isNaN(parsed)) {
      throw new Error("Value must be a number for this operator.");
    }
    return parsed;
  }
  if (trimmed.toLowerCase() === "true") return true;
  if (trimmed.toLowerCase() === "false") return false;
  return trimmed;
};

const fetchRules = async (flagKey: string) => {
  isLoadingRules.value = true;
  try {
    const response = await $api(`/api/flags/${flagKey}/rules`, { method: "GET" });
    rules.value = response?.rules ?? [];
  } catch (error) {
    console.error(`${telemetryPrefix} load error`, error);
    toast.error("Unable to load targeting rules.");
    rules.value = [];
  } finally {
    isLoadingRules.value = false;
  }
};

const loadAttributes = async () => {
  attributeErrorMessage.value = "";
  const projectId = selectedProjectId.value;
  if (!projectId) {
    attributes.value = {};
    return;
  }
  try {
    const response = await $api(`/api/flags/projects/${projectId}/attributes`, { method: "GET" });
    attributes.value = response?.attributes ?? response ?? {};
  } catch (error) {
    console.error(`${telemetryPrefix} attribute error`, error);
    attributeErrorMessage.value =
      error?.data?.message || "Unable to load targeting attributes from the server right now.";
    attributes.value = {};
    form.attribute = "";
  }
};

const handleSubmit = async () => {
  if (!props.flagKey) return;
  if (!isFormValid.value) {
    formError.value = "Please fill all required fields.";
    return;
  }

  let parsedValue: TargetingRulePayload["value"];
  try {
    parsedValue = parseValueForOperator(form.operator, form.matchValue);
  } catch (error: any) {
    formError.value = error.message ?? "Invalid value.";
    return;
  }

  formError.value = "";
  const payload: TargetingRulePayload = {
    attribute: form.attribute.trim(),
    operator: form.operator,
    value: parsedValue,
    ...(form.name.trim() ? { name: form.name.trim() } : {}),
    ...(form.description.trim() ? { description: form.description.trim() } : {}),
  };

  const isEditing = Boolean(editingRuleId.value);
  const endpoint = isEditing
    ? `/api/flags/${props.flagKey}/rules/${editingRuleId.value}`
    : `/api/flags/${props.flagKey}/rules`;
  const method = isEditing ? "PATCH" : "POST";

  isSavingRule.value = true;
  try {
    await $api(endpoint, { method, body: payload });
    console.info(telemetryPrefix, {
      action: method,
      flagKey: props.flagKey,
      payload,
      status: "success",
    });
    toast.success(isEditing ? "Rule updated" : "Rule added");
    resetForm();
    await fetchRules(props.flagKey);
  } catch (error: any) {
    console.error(telemetryPrefix, {
      action: method,
      flagKey: props.flagKey,
      payload,
      status: "error",
      error,
    });
    formError.value = error?.data?.message || error?.message || "Unable to save rule.";
    toast.error(formError.value);
  } finally {
    isSavingRule.value = false;
  }
};

const startEdit = (rule: TargetingRule) => {
  editingRuleId.value = rule.id;
  form.attribute = rule.attribute;
  form.operator = rule.operator;
  form.matchValue = Array.isArray(rule.value)
    ? rule.value.join(", ")
    : rule.value != null
      ? String(rule.value)
      : "";
  form.name = rule.name || "";
  form.description = rule.description || "";
  if (process.client) { window.scrollTo({ top: 0, behavior: "smooth" }); }
};

const deleteRule = async (rule: TargetingRule) => {
  if (!props.flagKey) return;

  try {
    await $api(`/api/flags/${props.flagKey}/rules/${rule.id}`, { method: "DELETE" });
    console.info(telemetryPrefix, {
      action: "DELETE",
      flagKey: props.flagKey,
      ruleId: rule.id,
      status: "success",
    });
    toast.success("Rule deleted");
    if (editingRuleId.value === rule.id) {
      resetForm();
    }
    await fetchRules(props.flagKey);
  } catch (error: any) {
    console.error(telemetryPrefix, {
      action: "DELETE",
      flagKey: props.flagKey,
      ruleId: rule.id,
      status: "error",
      error,
    });
    toast.error(error?.data?.message || "Unable to delete rule.");
  }
};

watch(
  () => props.flagKey,
  (newKey) => {
    resetForm();
    if (newKey) {
      fetchRules(newKey);
    } else {
      rules.value = [];
    }
  },
  { immediate: true },
);

watch(
  () => selectedProjectId.value,
  () => {
    loadAttributes();
  },
  { immediate: true },
);
</script>
