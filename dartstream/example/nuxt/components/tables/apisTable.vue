<script setup lang="ts">
import {
  getCoreRowModel,
  getPaginationRowModel,
  getSortedRowModel,
  useVueTable,
  type ColumnDef,
} from "@tanstack/vue-table";
import { reactive, computed, ref } from "vue";
import { FlexRender } from "@tanstack/vue-table";

// Props
const props = defineProps<{
  data: any[];
  columns: ColumnDef<any, any>[];
  titles?: string;
  subtitle?: string;
  button?: string;
  header: string;
  onCreateClick?: () => void;
}>();

// Search
const searchTerm = ref("");

const filteredData = computed(() =>
  props.data.filter((row) =>
    Object.values(row).some((val) =>
      String(val).toLowerCase().includes(searchTerm.value.toLowerCase())
    )
  )
);

// Table state
const state = reactive({
  pageIndex: 0,
  pageSize: 5,
  sorting: [] as any[],
});

// Vue Table instance
const table = useVueTable({
  data: filteredData,
  columns: props.columns,
  state,
  onSortingChange: (updater) => {
    state.sorting =
      typeof updater === "function" ? updater(state.sorting) : updater;
  },
  getCoreRowModel: getCoreRowModel(),
  getPaginationRowModel: getPaginationRowModel(),
  getSortedRowModel: getSortedRowModel(),
});

// Pagination
const currentPage = computed(() => state.pageIndex + 1);
const totalPages = computed(() => table.getPageCount());

const itemsPerPage = computed({
  get: () => state.pageSize,
  set: (val) => {
    state.pageSize = Number(val);
    state.pageIndex = 0;
  },
});

function changePage(page: number) {
  if (page < 1 || page > totalPages.value) return;
  state.pageIndex = page - 1;
}

const visiblePages = computed(() => {
  const pages: (number | string)[] = [];
  const total = totalPages.value;
  const current = currentPage.value;

  if (total <= 5) {
    for (let i = 1; i <= total; i++) pages.push(i);
  } else {
    if (current <= 3) {
      pages.push(1, 2, 3, "...", total);
    } else if (current >= total - 2) {
      pages.push(1, "...", total - 2, total - 1, total);
    } else {
      pages.push(1, "...", current, "...", total);
    }
  }
  return pages;
});
</script>

<template>
  <div
    v-if="props.header === 'true'"
    class="w-full flex justify-between items-center mb-4"
  >
    <div class="flex gap-2">
      <img src="/assets/images/linechart.png" alt="" class="w-6 h-6" />
      <label class="block font-medium text-lg">{{
        props.titles || "Table"
      }}</label>
    </div>
    <div class="flex gap-2 justify-end">
      <select
        class="text-sm text-gray-500 border border-gray rounded-[8px] px-2 py-1"
      >
        <option>Last Year</option>
      </select>
    </div>
  </div>
  <div v-else class="w-full flex justify-between items-center mb-4">
    <div>
      <label class="block font-semibold text-lg">{{
        props.titles || "Table"
      }}</label>
      <p class="text-sm text-gray-500">{{ props.subtitle }}</p>
    </div>
    <div class="flex gap-2 justify-end">
      <div class="relative">
        <input
          type="text"
          v-model="searchTerm"
          placeholder="Search..."
          class="pl-10 pr-3 py-2 w-full border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        />
        <span class="absolute left-3 top-2.5 text-gray-400">
          <img src="/assets/images/search.png" alt="Search" class="w-4 h-4" />
        </span>
        <span
          class="absolute right-2 top-2.5 text-xs text-gray-500 bg-gray-100 px-1.5 py-0.5 rounded"
        >
          ⌘1
        </span>
      </div>
      <div class="">
        <button
          @click="props.onCreateClick"
          class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2 dashboard-create-button"
        >
          <img src="/assets/images/add.png" alt="" class="w-auto" />
          {{ props.button }}
        </button>
      </div>
    </div>
  </div>
  <div class="overflow-x-auto">
    <table class="min-w-full text-sm text-left text-gray-700">
      <thead class="bg-gray-100 text-xs font-semibold uppercase">
        <tr>
          <th
            v-for="header in table.getHeaderGroups()[0].headers"
            :key="header.id"
            class="px-6 py-3 border-b cursor-pointer select-none"
            @click="(e) => header.column.getToggleSortingHandler()?.(e)"
          >
            <div class="flex items-center space-x-1">
              <component
                :is="FlexRender"
                v-bind="{
                  render: header.column.columnDef.header,
                  props: header.getContext(),
                }"
              />
              <!-- <span>{{ header.column.columnDef.header }}</span> -->
              <div class="flex flex-col items-center ml-1">
                <svg
                  class="w-3 h-3 text-gray-400"
                  :class="{
                    'text-blue-600': header.column.getIsSorted() === 'asc',
                  }"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path d="M5 12l5-5 5 5H5z" />
                </svg>
                <svg
                  class="w-3 h-3 -mt-1 text-gray-400"
                  :class="{
                    'text-blue-600': header.column.getIsSorted() === 'desc',
                  }"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path d="M5 8l5 5 5-5H5z" />
                </svg>
              </div>
            </div>
          </th>
        </tr>
      </thead>

      <tbody>
        <tr
          v-for="row in table.getRowModel().rows"
          :key="row.id"
          class="border-b hover:bg-gray-50"
        >
          <td
            v-for="cell in row.getVisibleCells()"
            :key="cell.id"
            class="px-6 py-4 font-medium"
          >
            <component
              :is="FlexRender"
              v-bind="{
                render: cell.column.columnDef.cell,
                props: cell.getContext(),
              }"
            />
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
