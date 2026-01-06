<template>
  <div class="">
    <div class="flex gap-2">
      <img src="/assets/images/envir.png" alt="" class="h-7 w-7" />
      <h2 class="text-2xl mb-6">Api Access</h2>
    </div>
    <div class="mt-5">
      <Maintable
        :data="clients"
        :columns="columns"
        titles="API Keys Table"
        subtitle=""
        button="Create Api Key"
        @create-click="handleCreate"
        header="2"
      />
    </div>
    <CreateApi :isOpen="isModalOpen" @close="isModalOpen = false" />
  </div>
</template>
<script setup lang="ts">
const isModalOpen = ref(false);
import { h } from "vue";
import type { ColumnDef, Row } from "@tanstack/vue-table";
import CreateApi from "./modals/createApi.vue";
import Maintable from "../tables/maintable.vue";
const clients = ref([
  {
    id: "1",
    name: "CI Pipeline",
    scope: "Read+Write",
    environment: "Production",
    status: "✅ Active",
    expires: "2025-12-01",
  },
  {
    id: "2",
    name: "CI Pipeline",
    scope: "Read+Write",
    environment: "Staging",
    status: "🟡 Expiring",
    expires: "2025-12-01",
  },
  {
    id: "3",
    name: "CI Pipeline",
    scope: "Read+Write",
    environment: "Staging",
    status: "🟡 Expiring",
    expires: "2025-12-01",
  },
]);
const columns: ColumnDef<any, any>[] = [
  {
    accessorKey: "name",
    header: "Key Name",
    enableSorting: true,
  },
  {
    accessorKey: "scope",
    header: "Scope",
    enableSorting: false,
  },
  {
    accessorKey: "environment",
    header: "Environment",
    enableSorting: true,
  },
  {
    accessorKey: "status",
    header: "Status",
    enableSorting: true,
  },
  {
    accessorKey: "expires",
    header: "Expires",
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
            row.original.expires || ""
          ),
          h(
            defineComponent({
              setup() {
                const open = ref(false);
                const toggleDropdown = () => (open.value = !open.value);
                const handle = (action: string) => {
                  console.log("Action:", action);
                  open.value = false;
                };

                return () =>
                  h("div", { class: "relative" }, [
                    h("img", {
                      src: "/images/blackdots.png",
                      alt: "More options",
                      class: "w-5 h-5 cursor-pointer",
                      onClick: toggleDropdown,
                    }),
                    open.value &&
                      h(
                        "div",
                        {
                          class:
                            "absolute right-0 z-10 mt-2 w-40 bg-white border rounded shadow-lg",
                        },
                        [
                          h(
                            "ul",
                            { class: "text-sm text-gray-700" },
                            [
                              ["♻️", "Rotate Key", "rotate"],
                              ["🗑", "Revoke Key", "revoke"],
                              [
                                "🔒",
                                "Regenerate Key",
                                "regenerate",
                                "text-red-500",
                              ],
                            ].map(([emoji, label, action, extraClass = ""]) =>
                              h(
                                "li",
                                {
                                  onClick: () => handle(action as string),
                                  class: `px-4 py-2 hover:bg-gray-100 cursor-pointer ${extraClass}`,
                                },
                                [
                                  h(
                                    "div",
                                    { class: "flex justify-start gap-2" },
                                    [h("div", {}, emoji), h("span", {}, label)]
                                  ),
                                ]
                              )
                            )
                          ),
                        ]
                      ),
                  ]);
              },
            })
          ),
        ]
      ),
  },
];

const handleCreate = () => {
  isModalOpen.value = true;
};
const open = ref(false);

const toggleDropdown = () => {
  open.value = !open.value;
};

const handle = (action: string) => {
  console.log("Action:", action);
  open.value = false;
};
</script>
