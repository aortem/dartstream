<template>
  <div class="min-h-screen bg-[#F8F8F8] relative">
    <!-- Fixed Header -->
    <div class="fixed top-0 left-0 w-full z-20">
      <Header />
    </div>

    <!-- Sidebar (Fixed) -->
    <div
      v-if="showSidebar"
      class="fixed top-[64px] left-0 w-64 h-[calc(100vh-64px)] bg-white z-10 border-r"
    >
      <Sidebar />
    </div>

    <!-- Main Content (with left padding) -->
    <main
      class="pt-[64px] pl-[256px] h-[calc(100vh-4px)] overflow-y-auto"
    >
      <div class="p-2 bg-[#F8F8F8]">
        <slot />
      </div>
    </main>
  </div>
</template>

<script setup>
import Header from "~/components/adminlayout/header.vue";
import Sidebar from "~/components/adminlayout/sidebar.vue";

const showSidebar = true;
</script>
