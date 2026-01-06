<script setup lang="ts">
import { ref } from "vue";
import KeyActions from "~/components/settings/modals/keyActions.vue";

import { h } from "vue";
import type { ColumnDef, Row } from "@tanstack/vue-table";
import Maintable from "~/components/tables/maintable.vue";
const activeTab = ref("details");
const isOn = ref(true);

import UpgradeModal from "~/components/upgradeModal/upgrade.vue";

const showModal = ref(false);

function handleUpgrade() {
  console.log("Upgrade clicked!");
  showModal.value = false;
}
const clients = ref([
  {
    id: "1",
    variant: "A (Control)",
    users: "5000",
    conversions: "400",
    rate: "8.0%",
    status: "Active",
  },
  {
    id: "2",
    variant: "B (Control)",
    users: "4900",
    conversions: "490",
    rate: "10.0%",
    status: "Winner",
  },
  {
    id: "3",
    variant: "A (Control)",
    users: "5000",
    conversions: "400",
    rate: "8.0%",
    status: "Active",
  },
]);
const columns: ColumnDef<any, any>[] = [
  {
    accessorKey: "variant",
    header: "Variant",
    enableSorting: false,
  },
  {
    accessorKey: "users",
    header: "Users",
    enableSorting: false,
    cell: ({ row }: { row: Row<any> }) =>
      h(
        "div",
        {
          class:
            "flex items-center justify-between border rounded-[8px] gap-3 bg=[#F5F7FA] relative p-2",
        },
        [h("div", { class: "text-xs text-gray-500" }, row.original.users || "")]
      ),
  },
  {
    accessorKey: "conversions",
    header: "Conversions",
    enableSorting: true,
  },

  {
    accessorKey: "rate",
    header: "Conversion Rate",
    enableSorting: true,
  },
  {
    accessorKey: "status",
    header: "Status",
    enableSorting: true,
    cell: ({ row }: { row: Row<any> }) =>
      h(
        "div",
        {
          class: "flex items-center justify-between gap-3 relative",
        },
        [
          h(
            "div",
            { class: "text-xs text-gray-500" },
            row.original.status || ""
          ),
          h(KeyActions), // Dropdown component used here
        ]
      ),
  },
];
function toggle() {
  isOn.value = !isOn.value;
}
definePageMeta({
  layout: "dashboard",
});
</script>
<template>
  <div class="min-h-screen p-6">
    <div class="w-full">
      <div class="flex justify-between">
        <div class="flex gap-2 w-full">
          <img src="/assets/images/envir.png" alt="" class="w-7 h-7" />
          <h1 class="text-xl font-bold mt-1">Pricing Banner A/B Test</h1>
        </div>

        <div class="w-[90%] flex justify-end">
          <button
            class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2 dashboard-create-button"
          >
            Edit configuration
          </button>
        </div>
      </div>

      <div class="p-6 mt-5 bg-white rounded-[8px] w-full">
        <div class="flex justify-between">
          <div class="flex gap-2 w-full">
            <h1 class="text-2xl font-bold mt-1">Pricing Banner A/B Test</h1>
          </div>

          <div class="w-[90%] flex gap-2 justify-end">
            <div class="mt-2">Status :</div>
            <button
              class="bg-[#54A300] text-white px-4 py-2 rounded-[8px] flex items-center gap-2 dashboard-create-button"
            >
              Running
            </button>
          </div>
        </div>
        <div>
          <div>
            <div class="">
              <div class="flex justify-between mt-4 border-b pb-5">
                <div class="w-75">
                  <p class="semibold">Linked Flag</p>
                  <p class="text-gray-400 text-sm">
                    Lorem Ipsum is simply dummy text of the printing and
                    typesetting industry. 
                  </p>
                </div>
                <div class="w-50">
                  <button
                    class="mt-2 flex gap-2 bg-[#F5F7FA] text-sm px-4 py-2 rounded-[4px] border hover:bg-gray-100 whitespace-nowrap"
                  >
                    <img src="/assets/images/flag.png" alt="" class="" />
                    <div class="text-[#525866]">header_color_test</div>
                  </button>
                </div>
              </div>

              <div class="flex justify-between mt-4 border-b pb-5">
                <div class="w-75">
                  <p class="semibold">Start Date</p>
                  <p class="text-gray-400 text-sm">
                    Lorem Ipsum is simply dummy text of the printing and
                    typesetting industry. 
                  </p>
                </div>
                <div class="w-50">
                  <button
                    class="mt-2 flex gap-2 text-[#525866] bg-[#F5F7FA] text-sm px-4 py-2 rounded-[4px] border hover:bg-gray-100 whitespace-nowrap"
                  >
                    <div class="">July 1, 2025</div>
                  </button>
                </div>
              </div>

              <div class="flex justify-between mt-4 border-b pb-5">
                <div class="w-75">
                  <p class="semibold">Duration</p>
                  <p class="text-gray-400 text-sm">
                    Lorem Ipsum is simply dummy text of the printing and
                    typesetting industry. 
                  </p>
                </div>
                <div class="w-50">
                  <button
                    class="mt-2 flex gap-2 bg-[#F5F7FA] text-[#525866] text-sm px-4 py-2 rounded-[4px] border hover:bg-gray-100 whitespace-nowrap"
                  >
                    <div class="">14 days</div>
                  </button>
                </div>
              </div>
              <div class="mt-5">
                <Maintable
                  :data="clients"
                  :columns="columns"
                  titles="Live Results & Metrics Section"
                  subtitle=""
                  button="Add new user"
                  @create-click=""
                  header="1"
                />
              </div>
              <div class="flex justify-between mt-4 border-b pb-5">
                <div class="w-75">
                  <p class="semibold">Data</p>
                  <p class="text-gray-400 text-sm">
                    Lorem Ipsum is simply dummy text of the printing and
                    typesetting industry. 
                  </p>
                </div>
                <div class="w-50">
                  <button
                    class="mt-2 flex gap-2 bg-white text-sm text-[#525866] px-4 py-2 rounded-[4px] border hover:bg-gray-100 whitespace-nowrap"
                  >
                    <div class="">Export data (CSV)</div>
                  </button>
                </div>
              </div>
              <div class="flex justify-between mt-4">
                <div class="w-75">
                  <p class="semibold">Controles</p>
                  <p class="text-gray-400 text-sm">
                    Lorem Ipsum is simply dummy text of the printing and
                    typesetting industry. 
                  </p>
                </div>
                <div class="w-50">
                  <button
                    class="mt-2 inline-flex items-center gap-2 bg-white border-gray rounded-[4px] text-red-600 text-sm px-4 py-2 rounded hover:bg-gray-100 whitespace-nowrap"
                  >
                    Pause / Resume
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
