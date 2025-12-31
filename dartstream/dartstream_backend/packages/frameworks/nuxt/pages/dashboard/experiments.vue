<script setup lang="ts">
import { ref, onMounted} from "vue"
const isModalOpen = ref(false);
definePageMeta({
  layout: "dashboard",
});

import { h } from "vue";
import type { ColumnDef, Row } from "@tanstack/vue-table";
import CreateExperiment from "~/components/experiments/createExperiment.vue";
import MainTable from "~/components/tables/maintable.vue";
import { useToast } from "vue-toastification";
const toast = useToast()
const clients = ref([
  {
    id: "1",
    name: "Header Color Test",
    flag: "header_color_test",
    status: "🟢 Running",

    variant: "Red, Blue, Green",
    matric: "Click-through rate",
  },
  {
    id: "2",
    name: "Signup Flow A/B",
    flag: "new_signup_flow",
    status: "🟡 Paused",

    variant: "Old Flow, New Flow",
    matric: "Signup conversion",
  },
  {
    id: "3",
    name: "Checkout Optimization",
    flag: "checkout_step",
    status: "✅ Complete",

    variant: "One-page, Multi-step",
    matric: "Purchase completion",
  },
  {
    id: "4",
    name: "Pricing CTA Test",
    flag: "pricing_cta",
    status: "🗃️ Archived",

    variant: "Try Now, Learn More",
    matric: "Button click rate",
  },
  {
    id: "5",
    name: "Navigation Redesign Since Aug, 2021",
    flag: "sidebar_layout",
    status: "🟢 Running",

    variant: "Compact, Expanded",
    matric: "Engagement time",
  },
  {
    id: "6",
    name: "Email Timing Experiment",
    flag: "email_send_delay",
    status: "✅ Complete",

    variant: "Immediate, 1hr Delay, 3hr Delay",
    matric: "Email open rate",
  },
]);
const columns: ColumnDef<any, any>[] = [
  {
    accessorKey: "name",
    header: "Name",
    enableSorting: true,
  },
  {
    accessorKey: "flag",
    header: "Flag",
    enableSorting: false,
    cell: ({ row }: { row: Row<any> }) =>
      h(
        "div",
        {
          class:
            "flex items-center gap-3 bg-[#F5F7FA] border p-1 rounded w-full",
        },
        [
          h("img", {
            src: "/images/flag.png",
            alt: "flag",
            class: "w-5 h-5 ",
          }),
          h("div", { class: "text-xs text-gray-500" }, row.original.flag || ""),
        ]
      ),
  },
  {
    accessorKey: "status",
    header: "Status",
    enableSorting: true,
  },
  {
    accessorKey: "variant",
    header: "Variant",
    enableSorting: true,
  },
  {
    accessorKey: "matric",
    header: "Metric",
    enableSorting: true,
    cell: ({ row }: { row: Row<any> }) =>
      h(
        "div",
        {
          class: "flex justify-between gap-3 ",
        },
        [
          h("div", { class: "" }, row.original.matric || ""),
          h("img", {
            src: "/images/blackdots.png",
            alt: "flag",
            class: "w-5 h-5 ",
          }),
        ]
      ),
  },
];

const handleCreateFlag = () => {
    toast.warning("Sandbox & Standard user cannot create a experiment.");
    return;
 
  // isModalOpen.value = true;
};
</script>

<template>
  <div class="relative mt-4">
    <div class="min-h-screen p-6">
      <div class="flex items-center justify-between mb-6">
        <div>
          <div class="flex gap-3">
            <img src="/assets/images/enable.png" alt="" class="h-8 w-auto" />
            <h1 class="font-satoshi font-medium text-2xl font-bold">
              Experiments / A/B Testing Dashboard
            </h1>
          </div>
          <p class="text-sm text-gray-500">
            Feature module for running, managing, and analyzing controlled
            experiments.
          </p>
        </div>
        <div class="">
          <button
            @click="handleCreateFlag"
            class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2 dashboard-create-button"
          >
            <img src="/assets/images/add.png" alt="" class="w-auto" />
            Create Experiment
          </button>
        </div>
      </div>

      <CreateExperiment :isOpen="isModalOpen" @close="isModalOpen = false" />
      <div class="relative mt-4">
        <div class="mt-4 bg-white p-4 rounded-[8px] shadow">
          <div class="">
            <MainTable
              :data="clients"
              :columns="columns"
              titles="Table of Experiments"
              subtitle=""
              header="3"
              button=""
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
