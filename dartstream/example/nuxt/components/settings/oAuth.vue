<script setup lang="ts">
import CreateOAuth from "./modals/createOAuth.vue";
import type { ColumnDef, Row } from "@tanstack/vue-table";
import { ref, h } from "vue";
import Maintable from "../tables/maintable.vue";
import { useToast } from "vue-toastification";

const isModalOpen = ref(false);
const toast = useToast();
const { $api } = useNuxtApp();
const tokens = ref([]);
const clients = ref([]);

definePageMeta({
  layout: "dashboard",
});

onMounted(() => {
  getClients();
});

const openModal = () => {
  isModalOpen.value = true;
};

const getClients = async () => {
  try {
    const res = await $api("/api/oauth/clients", {
      method: "GET",
    });


    if (res) {
    
      clients.value = res?.clients;
      // toast.success("You account is deleted successfully.");
    } else {
      toast.error("Something went wrong. Please try again. ");
    }
  } catch (error) {
    toast.error("Something went wrong. Please try again. ");
  }
};

// const clients = ref([
//   {
//     id: "1",
//     name: "CI Pipeline",
//     created_date: "2025-12-01",
//     scope: "Read+Write",
//   }
// ]);
const columns: ColumnDef<any, any>[] = [
  {
    accessorKey: "name",
    header: "Client Name",
    enableSorting: true,
  },
  {
    accessorKey: "createdAt",
    header: "Created Date",
    enableSorting: true,
    cell: ({ row }) => {
      const date = row.original.createdAt
        ? new Date(row.original.createdAt).toISOString().split("T")[0] // "YYYY-MM-DD"
        : "";
      return h("div", { class: "text-xs text-gray-500" }, date);
    },
  },
  {
    accessorKey: "scopes",
    header: "Scope",
    enableSorting: false,
    cell: ({ row }) =>
      h(
        "div",
        { class: "flex flex-wrap gap-1" },
        row.original.scopes.map((scope: string) =>
          h(
            "span",
            {
              class:
                "px-2 py-1 rounded bg-gray-100 text-gray-700 text-xs font-medium",
            },
            scope
          )
        )
      ),
  },
  {
    accessorKey: "status",
    header: "Status",
    enableSorting: false,
    cell: ({ row }) => {
      const isActive = row.original.isActive;

      const classes = isActive
        ? "bg-[#E0FAEC] text-[#1FC16B]"
        : "bg-gray-200 text-red-400/75";

      const text = isActive ? "Active" : "Inactive";

      return h(
        "div",
        {
          class: `flex items-center justify-center ${classes} w-[60px] h-[22px] rounded-full text-xs font-medium`,
        },
        text
      );
    },
  },
  {
    accessorKey: "lastUsed",
    header: "Last Used",
    enableSorting: true,
    cell: ({ row }: { row: Row<any> }) =>
      h("div", { class: "flex items-center justify-between gap-3 relative" }, [
        h(
          "div",
          { class: "text-xs text-gray-500" },
          row.original.lastUsed
            ? new Date(row.original.lastUsed).toISOString().split("T")[0]
            : "N/A"
        ),
        h(
          defineComponent({
            setup() {
              const isActive = ref(row.original.isActive);
              const { $api } = useNuxtApp();
              const toast = useToast();

              const toggleStatus = async () => {
                try {
                  // Optimistic UI update
                  isActive.value = !isActive.value;

                  const clientId = row.original.clientId;
               
                  const res = await $api(
                    `/api/oauth/clients/${clientId}/toggle`,
                    {
                      method: "PATCH",
                      body: { isActive: isActive.value },
                    }
                  );


                  // Refresh client content to get Status (active or inactive)
                  getClients();

                  if (res?.message) {
                    toast.success(
                      `Client ${
                        isActive.value ? "activated" : "deactivated"
                      } successfully`
                    );
                  } else {
                    toast.error("API call failed");
                  }
                } catch (error) {
                  // Rollback UI if API fails
                  isActive.value = !isActive.value;
                  toast.error("Something went wrong while updating status");
                }
              };

              return () =>
                h(
                  "label",
                  { class: "inline-flex items-center cursor-pointer" },
                  [
                    h("input", {
                      type: "checkbox",
                      class: "sr-only peer",
                      checked: isActive.value,
                      onChange: toggleStatus,
                    }),
                    h("div", {
                      class:
                        "relative w-7 h-4 bg-gray-200 rounded-full peer-focus:ring-[#1FC16B] dark:peer-focus:ring-[#1FC16B] dark:bg-gray-400 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:start-[2px] after:bg-white after:border-white after:border after:rounded-full after:h-3 after:w-3 after:transition-all dark:border-gray-600 peer-checked:bg-[#1FC16B] dark:peer-checked:bg-[#1FC16B]",
                    }),
                  ]
                );
            },
          })
        ),
      ]),
  },
];
</script>

<template>
  <div class="relative mt-4">
    <div class="">
      <div class="flex items-center justify-between mb-6">
        <div>
          <div class="flex gap-3">
            <img src="/assets/images/envir.png" alt="" class="w-8 h-8" />
            <h1 class="text-2xl mt-1">OAuth2</h1>
          </div>
        </div>
      </div>
      <div class="flex justify-between items-center mb-4" v-if="!clients">
        <div>
          <label class="block font-medium text-lg">OAuth2 Clients</label>
        </div>
        <div class="flex gap-2 justify-end">
          <div class="relative">
            <input
              type="text"
              placeholder="Search Clients..."
              class="pl-10 pr-3 py-2 w-full border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            />
            <span class="absolute left-3 top-2.5 text-gray-400">
              <img
                src="/assets/images/search.png"
                alt="Search"
                class="w-4 h-4"
              />
            </span>
            <span
              class="absolute right-2 top-2.5 text-xs text-gray-500 bg-gray-100 px-1.5 py-0.5 rounded"
            >
              ⌘1
            </span>
          </div>
          <div class="">
            <button
              @click="openModal()"
              class="bg-[#42489E] text-white px-4 py-2 rounded-[8px] flex items-center gap-2 dashboard-create-button"
            >
              <img src="/assets/images/add.png" alt="" class="w-auto" />
              Create OAuth2 Client
            </button>
          </div>
        </div>
      </div>

      <div
        class="flex items-center justify-center flex-col"
        style="height: calc(100vh - 150px)"
        v-if="!clients"
      >
        <div>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="118"
            height="118"
            viewBox="0 0 118 118"
            fill="none"
          >
            <rect width="118" height="118" rx="59" fill="#F2F5F8" />
            <path
              d="M33.8988 26.7272C33.8201 27.0298 33.6826 27.3003 33.4755 27.5593C33.1665 27.9452 32.6867 28.3014 32.0522 28.559C31.4199 28.8167 30.6411 28.9708 29.79 28.9702C29.1748 28.9703 28.5225 28.8908 27.8602 28.7199C26.4538 28.3595 25.2873 27.6517 24.5296 26.8499C23.9342 26.2225 22.943 26.1966 22.3156 26.792C21.6883 27.3875 21.6624 28.3787 22.2578 29.006C23.4696 30.2794 25.1357 31.25 27.0783 31.7529C27.9936 31.9888 28.9061 32.1023 29.79 32.1023C31.4194 32.1004 32.9569 31.7218 34.2374 30.9621C34.8763 30.5816 35.4503 30.1019 35.917 29.5213C36.3834 28.9421 36.7391 28.2591 36.9318 27.5091C37.1477 26.6716 36.6438 25.8176 35.8062 25.6017C34.9687 25.3858 34.1147 25.8897 33.8988 26.7272Z"
              fill="#99A0AE"
            />
            <path
              d="M30.1702 41.1891C30.0915 41.4917 29.954 41.7622 29.7469 42.0212C29.4379 42.4071 28.9581 42.7633 28.3236 43.0209C27.6913 43.2786 26.9125 43.4326 26.0614 43.4321C25.4462 43.4322 24.7939 43.3526 24.1316 43.1818C22.7253 42.8214 21.5588 42.1136 20.8011 41.3118C20.2057 40.6844 19.2145 40.6585 18.5871 41.254C17.9598 41.8494 17.9339 42.8406 18.5293 43.468C19.7411 44.7413 21.4072 45.7119 23.3497 46.2148C24.2651 46.4508 25.1776 46.5642 26.0614 46.5643C27.6909 46.5624 29.2284 46.1837 30.5089 45.424C31.1478 45.0435 31.7218 44.5638 32.1884 43.9833C32.6549 43.404 33.0106 42.721 33.2033 41.9711C33.4192 41.1336 32.9153 40.2796 32.0777 40.0636C31.2402 39.8477 30.3861 40.3516 30.1702 41.1891Z"
              fill="#99A0AE"
            />
            <path
              d="M26.2142 56.5338C26.1355 56.8364 25.998 57.1069 25.7909 57.3659C25.4819 57.7519 25.0021 58.1081 24.3676 58.3656C23.7353 58.6233 22.9565 58.7774 22.1054 58.7768C21.4902 58.7769 20.8379 58.6974 20.1756 58.5266C18.7692 58.1661 17.6028 57.4583 16.8451 56.6565C16.2496 56.0292 15.2584 56.0033 14.6311 56.5987C14.0037 57.1941 13.9778 58.1853 14.5732 58.8127C15.785 60.086 17.4511 61.0566 19.3937 61.5596C20.309 61.7955 21.2215 61.9089 22.1054 61.909C23.7348 61.9071 25.2723 61.5284 26.5528 60.7688C27.1917 60.3882 27.7657 59.9085 28.2324 59.328C28.6989 58.7487 29.0546 58.0658 29.2472 57.3158C29.4631 56.4783 28.9592 55.6243 28.1217 55.4084C27.2841 55.1924 26.4302 55.6963 26.2142 56.5338Z"
              fill="#99A0AE"
            />
            <path
              d="M95.7768 36.3351L43.3792 22.7061C39.9833 21.8228 36.5143 23.8597 35.631 27.2556L22.002 79.6533C21.1187 83.0492 23.1556 86.5182 26.5515 87.4015L78.9492 101.03C82.3451 101.914 85.8141 99.8769 86.6974 96.4809L100.326 44.0833C101.21 40.6874 99.1728 37.2184 95.7768 36.3351Z"
              fill="#E1E4EA"
              stroke="#99A0AE"
              stroke-miterlimit="10"
              stroke-linejoin="round"
            />
            <path
              d="M94.8758 36.9543L82.3777 85.006C80.7649 90.1572 75.662 93.59 70.1076 92.9198C69.7451 92.8761 69.3869 92.8158 69.0364 92.7397L68.1619 92.5142C68.1386 92.5082 68.1152 92.5022 68.0927 92.4928C62.9079 90.8999 59.4477 85.7793 60.1164 80.2031C60.8713 73.9338 66.5662 69.4613 72.8363 70.2128L24.3443 63.8408L24.341 63.84C24.068 63.7803 23.7883 63.7331 23.5052 63.6993C21.7553 63.4867 20.065 63.8304 18.6123 64.5914L30.1788 20.1258C31.0614 16.7299 34.5306 14.6913 37.9257 15.5772L90.3238 29.2065C93.7198 30.0892 95.7584 33.5583 94.8758 36.9543Z"
              fill="white"
              stroke="#99A0AE"
              stroke-miterlimit="10"
              stroke-linejoin="round"
            />
            <path
              d="M68.0926 92.4933L21.7522 80.4398C21.6678 80.4359 21.5843 80.4286 21.4983 80.4171C16.8785 79.8633 13.5887 75.6693 14.1417 71.0529C14.4854 68.1871 16.2315 65.8324 18.6122 64.5917C20.0649 63.8308 21.7552 63.487 23.5051 63.6996C23.7882 63.7335 24.068 63.7807 24.3409 63.8403L24.3443 63.8412L72.8363 70.2131C66.566 69.4616 60.8712 73.9342 60.1163 80.2035C59.4477 85.7796 62.9078 90.9003 68.0926 92.4933Z"
              fill="#CACFD8"
              stroke="#99A0AE"
              stroke-miterlimit="10"
              stroke-linejoin="round"
            />
            <path
              d="M68.1621 92.5146L69.0366 92.7401C68.7394 92.6777 68.449 92.6029 68.1621 92.5146Z"
              stroke="#99A0AE"
              stroke-miterlimit="10"
              stroke-linejoin="round"
            />
            <path
              d="M82.3774 85.0059L82.669 83.8887C82.5885 84.2701 82.493 84.6406 82.3774 85.0059Z"
              stroke="#99A0AE"
              stroke-miterlimit="10"
              stroke-linejoin="round"
            />
            <path
              d="M24.5297 26.8496C24.1662 26.467 23.8966 26.0661 23.7233 25.6813C23.5495 25.2953 23.4707 24.9296 23.4705 24.5879C23.4706 24.4073 23.4923 24.2318 23.5376 24.0558C23.6163 23.7532 23.7538 23.4827 23.9609 23.2237C24.2699 22.8378 24.7497 22.4816 25.3842 22.224C26.0165 21.9663 26.7953 21.8123 27.6464 21.8128C28.2616 21.8127 28.9139 21.8923 29.5762 22.0631C30.9521 22.4159 32.0987 23.1007 32.857 23.8815C33.2371 24.2709 33.5197 24.6812 33.7012 25.0754C33.8833 25.4708 33.9657 25.8455 33.9659 26.1948C33.9658 26.3755 33.9441 26.5509 33.8988 26.727C33.6829 27.5645 34.1868 28.4185 35.0244 28.6344C35.862 28.8503 36.7159 28.3464 36.9318 27.5088C37.0439 27.0742 37.0982 26.632 37.0981 26.1948C37.0982 25.345 36.8947 24.5197 36.5453 23.7632C36.0192 22.6267 35.1739 21.6346 34.1178 20.8275C33.06 20.0211 31.7839 19.3981 30.3582 19.0301C29.4429 18.7942 28.5303 18.6807 27.6465 18.6807C26.0171 18.6826 24.4796 19.0612 23.199 19.8209C22.5602 20.2014 21.9861 20.6811 21.5195 21.2617C21.053 21.8409 20.6973 22.5239 20.5047 23.2738C20.3925 23.7085 20.3383 24.1507 20.3384 24.5879C20.3383 25.4188 20.5329 26.2266 20.8682 26.9692C21.2041 27.7129 21.679 28.3955 22.2578 29.0057C22.8533 29.6331 23.8445 29.659 24.4718 29.0635C25.0992 28.4681 25.1251 27.4769 24.5297 26.8496Z"
              fill="#99A0AE"
            />
            <path
              d="M20.8012 41.3114C20.4378 40.9289 20.1681 40.528 19.9948 40.1431C19.821 39.7572 19.7422 39.3915 19.742 39.0498C19.7421 38.8692 19.7638 38.6937 19.8091 38.5177C19.8878 38.2151 20.0253 37.9445 20.2325 37.6856C20.5414 37.2996 21.0212 36.9434 21.6557 36.6859C22.288 36.4282 23.0669 36.2741 23.918 36.2747C24.5331 36.2746 25.1855 36.3541 25.8477 36.525C27.2237 36.8778 28.3702 37.5626 29.1286 38.3434C29.5086 38.7328 29.7912 39.1431 29.9727 39.5373C30.1548 39.9327 30.2373 40.3073 30.2374 40.6567C30.2373 40.8373 30.2156 41.0128 30.1703 41.1888C29.9544 42.0264 30.4583 42.8804 31.2959 43.0963C32.1334 43.3122 32.9874 42.8083 33.2033 41.9707C33.3155 41.5361 33.3697 41.0939 33.3696 40.6567C33.3697 39.8069 33.1662 38.9816 32.8168 38.2251C32.2907 37.0886 31.4454 36.0965 30.3892 35.2894C29.3315 34.483 28.0554 33.86 26.6297 33.492C25.7144 33.2561 24.8018 33.1426 23.918 33.1426C22.2885 33.1445 20.751 33.5231 19.4705 34.2828C18.8316 34.6634 18.2576 35.143 17.791 35.7236C17.3245 36.3029 16.9688 36.9858 16.7761 37.7357C16.664 38.1704 16.6098 38.6126 16.6099 39.0498C16.6097 39.8807 16.8044 40.6885 17.1397 41.4311C17.4756 42.1748 17.9505 42.8574 18.5293 43.4676C19.1247 44.095 20.116 44.1209 20.7433 43.5254C21.3707 42.93 21.3966 41.9388 20.8012 41.3114Z"
              fill="#99A0AE"
            />
            <path
              d="M16.8456 56.6562C16.4821 56.2736 16.2125 55.8727 16.0392 55.4879C15.8654 55.1019 15.7866 54.7362 15.7864 54.3946C15.7865 54.2139 15.8082 54.0385 15.8535 53.8624C15.9322 53.5599 16.0697 53.2893 16.2769 53.0303C16.5858 52.6444 17.0656 52.2882 17.7001 52.0307C18.3324 51.7729 19.1113 51.6189 19.9623 51.6195C20.5775 51.6194 21.2298 51.6989 21.8921 51.8697C23.2681 52.2225 24.4146 52.9073 25.1729 53.6881C25.553 54.0775 25.8356 54.4878 26.0171 54.882C26.1992 55.2774 26.2817 55.6521 26.2818 56.0014C26.2817 56.1821 26.26 56.3575 26.2147 56.5336C25.9988 57.3711 26.5027 58.2251 27.3403 58.441C28.1778 58.6569 29.0318 58.153 29.2477 57.3154C29.3599 56.8808 29.4141 56.4386 29.414 56.0014C29.4141 55.1516 29.2106 54.3263 28.8612 53.5699C28.3351 52.4334 27.4899 51.4412 26.4337 50.6341C25.3759 49.8278 24.0999 49.2048 22.6741 48.8367C21.7588 48.6008 20.8463 48.4874 19.9624 48.4873C18.333 48.4892 16.7955 48.8679 15.515 49.6275C14.8761 50.0081 14.3021 50.4878 13.8354 51.0683C13.3689 51.6476 13.0132 52.3305 12.8206 53.0805C12.7084 53.5151 12.6542 53.9573 12.6543 54.3945C12.6542 55.2255 12.8488 56.0333 13.1842 56.7758C13.52 57.5195 13.995 58.2022 14.5738 58.8123C15.1692 59.4397 16.1604 59.4656 16.7878 58.8702C17.4151 58.2747 17.441 57.2836 16.8456 56.6562Z"
              fill="#99A0AE"
            />
            <path
              d="M46.1184 27.3896L49.9621 33.9035L43.2539 37.8619"
              fill="white"
            />
            <path
              d="M45.0727 28.006L48.2994 33.4743L42.6368 36.8157C42.0593 37.1564 41.8675 37.9008 42.2082 38.4782C42.5489 39.0556 43.2933 39.2475 43.8707 38.9068L50.5789 34.9484C51.1563 34.6077 51.3482 33.8633 51.0075 33.2859L47.1638 26.772C46.8231 26.1946 46.0787 26.0027 45.5013 26.3434C44.9238 26.6842 44.7319 27.4286 45.0727 28.006Z"
              fill="#99A0AE"
            />
            <path
              d="M78.343 35.6973L71.8291 39.5409L75.7875 46.2491"
              fill="white"
            />
            <path
              d="M77.7262 34.651L71.2123 38.4947C70.9369 38.6572 70.7335 38.9276 70.6537 39.2372C70.5739 39.5467 70.6212 39.8819 70.7837 40.1572L74.742 46.8654C75.0828 47.4428 75.8271 47.6347 76.4045 47.2939C76.9819 46.9532 77.1738 46.2089 76.8331 45.6315L73.4917 39.9689L78.9601 36.7421C79.5375 36.4014 79.7294 35.6571 79.3887 35.0796C79.0479 34.5022 78.3036 34.3103 77.7262 34.651Z"
              fill="#99A0AE"
            />
            <path
              d="M47.9645 52.1965L64.7337 56.5196C65.383 56.687 66.0449 56.2964 66.2123 55.6471C66.3797 54.9979 65.9891 54.3359 65.3398 54.1685L48.5706 49.8454C47.9213 49.678 47.2593 50.0686 47.092 50.7179C46.9246 51.3671 47.3152 52.0291 47.9645 52.1965Z"
              fill="#99A0AE"
            />
            <path
              d="M103.25 18.8475C103.25 18.8475 97.5139 18.867 97.5139 24.5836C97.5139 18.867 91.7778 18.8475 91.7778 18.8475C91.7778 18.8475 97.5139 18.8279 97.5139 13.1113C97.5139 18.8279 103.25 18.8475 103.25 18.8475Z"
              stroke="#99A0AE"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
            <path
              d="M16.389 95.0554C16.389 95.0554 11.4723 95.0721 11.4723 99.972C11.4723 95.0721 6.55566 95.0554 6.55566 95.0554C6.55566 95.0554 11.4723 95.0386 11.4723 90.1387C11.4723 95.0386 16.389 95.0554 16.389 95.0554Z"
              stroke="#99A0AE"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
            <path
              d="M77.8093 86.9628L77.1786 87.3936C73.6422 89.8167 68.8168 88.9102 66.3972 85.3773C63.9741 81.8444 64.8737 77.0189 68.4101 74.5959L69.0408 74.165L77.8093 86.9628Z"
              fill="#E1E4EA"
              stroke="#99A0AE"
              stroke-miterlimit="10"
              stroke-linejoin="round"
            />
            <path
              d="M109.905 56.9691L108.726 65.1206C108.657 65.5894 108.395 66.0099 108.003 66.2787L79.8047 85.5943L77.8091 86.9626L69.0405 74.1649L71.0362 72.7965L99.234 53.481C99.6269 53.2122 100.113 53.1191 100.575 53.2259L108.602 55.0699C109.464 55.2664 110.033 56.0936 109.905 56.9691Z"
              fill="white"
              stroke="#99A0AE"
              stroke-miterlimit="10"
              stroke-linejoin="round"
            />
          </svg>
        </div>
        <h1
          class="text-center text-[20px] font-[500] leading-[-0.12px] w-[434px] mt-[8px]"
        >
          No client have been added
        </h1>

        <p
          class="text-center text-[#525866] text-[14px] font-[400] leading-[-0.084px] w-[434px] mt-[18px]"
        >
          We will automatically adds you client here when you fill up the form
        </p>
      </div>
      <div class="mt-5" v-else>
        <Maintable
          :data="clients"
          :columns="columns"
          titles="OAuth2 Clients"
          subtitle=""
          button="Create OAuth2 Client"
          @create-click="openModal"
          header="2"
        />
      </div>
    </div>
    <CreateOAuth
      :isOpen="isModalOpen"
      @close="isModalOpen = false"
      @refreshClients="getClients"
    />
  </div>
</template>
