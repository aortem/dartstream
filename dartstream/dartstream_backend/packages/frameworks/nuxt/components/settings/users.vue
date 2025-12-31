<template>
  <div class="">
    <div class="flex gap-2">
      <img src="/assets/images/users.png" alt="" class="h-7 w-7" />
      <h2 class="text-2xl mb-6">Users & Roles</h2>
    </div>
    <div class="mt-5">
      <Maintable
        :data="clients"
        :columns="columns"
        titles="Users List"
        subtitle="View all your clients information."
        button="Add new user"
        @create-click="handleCreate"
        header="2"
      />
    </div>
    <AddNewUser :isOpen="isModalOpen" @close="isModalOpen = false" />
  </div>
</template>
<script setup lang="ts">
const isModalOpen = ref(false);
import { h } from "vue";
import type { ColumnDef, Row } from "@tanstack/vue-table";
import AddNewUser from "./modals/addNewUser.vue";
import KeyActions from "~/components/settings/modals/keyActions.vue";
import Maintable from "../tables/maintable.vue";
const selectedUsers = ref<string[]>([]);
const clients = ref([
  {
    id: "1",
    name: "James Brown",
    team: "QA",
    role: "Admin",
    date: "Date Added",
    email: "james@alignui.com",
  },
  {
    id: "2",
    name: "James Brown",
    team: "QA",
    role: "Admin",
    date: "Date Added",
    email: "james@alignui.com",
  },
  {
    id: "3",
    name: "James Brown",
    team: "QA",
    role: "Admin",
    date: "Date Added",
    email: "james@alignui.com",
  },
]);
const columns: ColumnDef<any, any>[] = [
  {
    accessorKey: "name",
    header: () =>
      h("div", { class: "flex items-center gap-2" }, [
        h("input", {
          type: "checkbox",
          class: "form-checkbox h-4 w-4",
          checked: selectedUsers.value.length === clients.value.length,
          onChange: (e: Event) => {
            const isChecked = (e.target as HTMLInputElement).checked;
            if (isChecked) {
              selectedUsers.value = clients.value.map((user) => user.id);
            } else {
              selectedUsers.value = [];
            }
          },
        }),
        h("span", {}, "Name"),
      ]),
    cell: ({ row }: { row: Row<any> }) =>
      h("div", { class: "flex items-center justify-between gap-2" }, [
        h("input", {
          type: "checkbox",
          class: "form-checkbox h-4 w-4",
          checked: selectedUsers.value.includes(row.original.id),
          onChange: (e: Event) => {
            const isChecked = (e.target as HTMLInputElement).checked;
            const id = row.original.id;
            if (isChecked) {
              if (!selectedUsers.value.includes(id)) {
                selectedUsers.value.push(id);
              }
            } else {
              selectedUsers.value = selectedUsers.value.filter(
                (uid) => uid !== id
              );
            }
          },
        }),
        h("div", { class: "flex flex-col" }, [
          h("span", { class: "font-medium text-sm" }, row.original.name),
          h("span", { class: "text-xs text-gray-500" }, row.original.email),
        ]),
      ]),
  },
  {
    accessorKey: "team",
    header: "Team",
    enableSorting: false,
    cell: ({ row }: { row: Row<any> }) =>
      h(
        "div",
        {
          class:
            "flex items-center justify-between border rounded-[8px] gap-3 relative p-2",
        },
        [h("div", { class: "text-xs text-gray-500" }, row.original.team || "")]
      ),
  },
  {
    accessorKey: "role",
    header: "Role",
    enableSorting: true,
    cell: ({ row }: { row: Row<any> }) =>
      h(
        "div",
        {
          class:
            "flex items-center justify-between border rounded-[8px] gap-3 relative p-2",
        },
        [h("div", { class: "text-xs text-gray-500" }, row.original.role || "")]
      ),
  },

  {
    accessorKey: "date",
    header: "Date Added",
    enableSorting: true,
    cell: ({ row }: { row: Row<any> }) =>
      h(
        "div",
        {
          class: "flex items-center justify-between gap-3 relative",
        },
        [
          h("div", { class: "text-xs text-gray-500" }, row.original.date || ""),
          h(KeyActions), // Dropdown component used here
        ]
      ),
  },
];

const handleCreate = () => {
  isModalOpen.value = true;
};
</script>
