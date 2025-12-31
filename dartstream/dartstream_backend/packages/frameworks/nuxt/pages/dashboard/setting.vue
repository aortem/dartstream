<template>
  <div class="flex min-h-screen rounded-lg bg-white m-4">
    <aside class="w-1/4 bg-white border-r p-2">
      <div class="text-xl">Setting</div>
      <p class="text-sm text-gray-500">
        View and edit your personal informations , teams, plans and more .
      </p>
      <div class="flex items-center gap-2 w-full mt-3">
        <div class="relative gap-2 w-full">
          <input v-model="searchQuery" type="text" placeholder="Search..."
            class="pl-6 pr-3 py-2 border border-gray w-full border-radius8 focus:outline-none mr-3" />
          <span class="absolute left-1 top-2.5 text-gray-400"><img src="/assets/images/search.png" alt=""
              class="w-auto" />
          </span>
          <span class="absolute right-2 top-2.5 mr-2 text-xs text-gray-500 bg-gray-100 px-1.5 py-0.5 rounded">
            ⌘1
          </span>
        </div>
      </div>
      <nav class="p-4">
        <ul class="space-y-2">
          <li  v-for="tab in tabs" :key="tab.key" @click="activeTab = tab.key" :data-cy="`${tab.key}-button`" :class="[
            'cursor-pointer px-4 py-2 rounded-[20px] hover:bg-gray-100 ',
            activeTab === tab.key ? 'bg-[#F5F7FA] font-medium' : '',
          ]">
            <div class="flex items-center gap-2">
              <div class="">
                <img :src="tab.image" alt="" class="w-auto" />
              </div>
              <span>{{ tab.label }}</span>
            </div>
          </li>
        </ul>
      </nav>
    </aside>

    <main class="flex-1 p-8 w-3/4">
      <div v-if="activeTab === 'general'">
        <General />
      </div>

      <div v-else-if="activeTab === 'password'">
        <Password />
      </div>

      <div v-else-if="activeTab === 'subscription'">
        <Subscription />
      </div>

      <div v-else-if="activeTab === 'notifications'">
        <Notification />
      </div>
      <div v-else-if="activeTab === 'restrictions'">
        <IpRestrictions />
      </div>
      <div v-else-if="activeTab === 'exports'">
        <Exports />
      </div>

      <div v-else-if="activeTab === 'oauth'">
        <OAuth />
      </div>
      <!-- <div v-else-if="activeTab === 'SDKs'">
        <Sdks />
      </div> -->
      <div v-else-if="activeTab === 'api_access'">
        <ApiAccess />
      </div>
      <div v-else-if="activeTab === 'user_roles'">
        <Users />
      </div>
      <div v-else-if="activeTab === 'Environments'">
        <Envirnoment />
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref } from "vue";
import general from "~/assets/images/genral.png";
import password from "~/assets/images/password.png";
import subscription from "~/assets/images/subscription.png";
import notifications from "~/assets/images/notify.png";
import General from "~/components/settings/general.vue";
import Password from "~/components/settings/password.vue";
import Subscription from "~/components/settings/subscription.vue";
import Notification from "~/components/settings/notification.vue";
import envir from "~/assets/images/envir.png";
import timer from "~/assets/images/timer.png";
import users from "~/assets/images/users.png";
import IpRestrictions from "~/components/settings/ipRestrictions.vue";
import Exports from "~/components/settings/exports.vue";
import ApiAccess from "~/components/settings/apiAccess.vue";
// import Sdks from "~/components/settings/sdks.vue";
import Users from "~/components/settings/users.vue";
import Envirnoment from "~/components/settings/envirnoment.vue";
import OAuth from "~/components/settings/oAuth.vue";
import { useRoute } from "vue-router";
const activeTab = ref("general");
const route = useRoute()
const tabs = [
  { key: "general", label: "General", image: general },
  { key: "password", label: "Password", image: password },
  { key: "subscription", label: "Subscription", image: subscription },
  { key: "notifications", label: "Notifications", image: notifications },
  { key: "restrictions", label: "IP Restrictions", image: envir },
  { key: "exports", label: "Export & Backups", image: timer },
  { key: "oauth", label: "Applications", image: envir },
  // { key: "SDKs", label: "SDKs", image: envir },
  { key: "api_access", label: "API Access", image: envir },
  { key: "Environments", label: "Environments", image: envir },
  { key: "user_roles", label: "Users & Roles", image: users },
];


onMounted(() => {
  // Check if there's a tab query parameter
  if (route.query.tab) {
    activeTab.value = route.query.tab
  }
})


definePageMeta({
  layout: "dashboard",
});
</script>

<style scoped>
/* Optional: custom scrollbar */
aside::-webkit-scrollbar {
  width: 6px;
}

aside::-webkit-scrollbar-thumb {
  background-color: #ccc;
  border-radius: 3px;
}
</style>
