<script setup lang="ts">
const isModalOpen = ref(false);
definePageMeta({
  layout: "dashboard",
});

import { h } from "vue";
import type { ColumnDef, Row } from "@tanstack/vue-table";

import MainTable from "~/components/tables/maintable.vue";
import UpgradePrompt from "~/components/analytics/UpgradePrompt.vue";
const clients = ref([
  {
    id: "1",
    timestamp: "Apr 29, 2025 15:04",
    action: "Flag toggled ON",
    performed: "James Brown",

    target: "new-dashboard",
    detail: "May 6, 2024",
  },
  {
    id: "2",
    timestamp: "Apr 29, 2025 15:04",
    action: "Flag toggled ON",
    performed: "James Brown",

    target: "new-dashboard",
    detail: "May 6, 2024",
  },
  {
    id: "3",
    timestamp: "Apr 29, 2025 15:04",
    action: "Flag toggled ON",
    performed: "James Brown",

    target: "new-dashboard",
    detail: "May 6, 2024",
  },
  {
    id: "4",
    timestamp: "Apr 29, 2025 15:04",
    action: "Flag toggled ON",
    performed: "James Brown",

    target: "new-dashboard",
    detail: "May 6, 2024",
  },
  {
    id: "5",
    timestamp: "Apr 29, 2025 15:04",
    action: "Flag toggled ON",
    performed: "James Brown",

    target: "new-dashboard",
    detail: "May 6, 2024",
  },
]);
const columns: ColumnDef<any, any>[] = [
  {
    accessorKey: "timestamp",
    header: "Timestamp",
    enableSorting: true,
  },
  {
    accessorKey: "action",
    header: "Action",
    enableSorting: false,
  },
  {
    accessorKey: "performed",
    header: "Performed By",
    enableSorting: true,
  },
  {
    accessorKey: "target",
    header: "Target",
    enableSorting: true,
    cell: ({ row }: { row: Row<any> }) =>
      h(
        "div",
        {
          class: "flex items-center gap-2", // optional gap between flag and box
        },
        [
          h("div", { class: " font-medium " }, "flag:"),

          h(
            "div",
            {
              class: "flex items-center gap-3 bg-[#F5F7FA] border p-1 rounded ",
            },
            [
              h("img", {
                src: "/images/flag.png",
                alt: "action",
                class: "w-5 h-5",
              }),
              h(
                "div",
                { class: "text-xs text-gray-500" },
                row.original.target || ""
              ),
            ]
          ),
        ]
      ),
  },
  {
    accessorKey: "detail",
    header: "Details",
    enableSorting: true,
  },
];

const subscriptionPlan = ref('');

onMounted(() => {
  // Get subscription plan from localStorage
  const storedData = localStorage.getItem('user_status'); // Replace with your actual key
  if (storedData) {
    const parsedData = JSON.parse(storedData);
    subscriptionPlan.value = parsedData.subscriptionPlan || '';
  }
});

const canViewAuditLogs = computed(() => {
  return subscriptionPlan.value !== 'standard';
});
</script>

<template>
  <div class="relative mt-4">
    <div class="min-h-screen p-6">
      <div class="flex items-center justify-between mb-6">
        <div>
          <div class="flex gap-3">
            <img src="/assets/images/timer.png" alt="" class="h-8 w-auto" />
            <h1 class="font-satoshi font-medium text-2xl font-bold">
              Audit logs
            </h1>
          </div>
          <p class="text-sm text-gray-500">
            Track all changes made to actions, environments, and team settings.
          </p>
        </div>
      </div>

      <div class="relative mt-4">
        <div class="mt-4 bg-white p-4 rounded-[8px] shadow">
          <div class="" v-if="canViewAuditLogs">
            <MainTable :data="clients" :columns="columns" titles="Audit table"
              subtitle="View all your clients information." header="3" button="" />
          </div>
          <UpgradePrompt v-else />
        </div>
      </div>
    </div>
  </div>
</template>
