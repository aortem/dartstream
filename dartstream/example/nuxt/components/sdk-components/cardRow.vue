<template>
  <div class="flex justify-between items-center">
    <span class="text-sm text-gray-500">{{ label }}</span>
    <div class="flex items-center space-x-2">
      <span class="text-sm font-medium text-gray-800">{{ value }}</span>
      <button
        v-if="copy"
        class="text-blue-600 text-xs hover:underline"
        @click="handleCopy"
      >
        Copy Key
      </button>
    </div>
  </div>
  <CardRow label="API Key" value="env_xxxxx" :copy="true" />
</template>

<script setup>
defineProps({
  label: {
    type: String,
    required: true,
  },
  value: {
    type: String,
    required: true,
  },
  copy: {
    type: Boolean,
    default: false,
  },
});

const handleCopy = () => {
  navigator.clipboard
    .writeText(props.value)
    .then(() => {
    })
    .catch((err) => {
      console.error("Failed to copy:", err);
    });
};
</script>
