<template>
  <div class="min-h-screen bg-[#F8F8F8] relative">
    <!-- Fixed Header -->
    <div class="fixed top-0 left-0 w-full z-20">
      <Header />
    </div>

    <!-- Sidebar -->
    <div v-if="showSidebar"
      class="fixed top-[65px] left-0 w-68 h-[calc(100vh-65px)] bg-white z-10 border-r overflow-hidden">
      <Sidebar />
    </div>

    <!-- Main Content -->
    <main class="top-[65px] relative pl-[256px] h-[calc(100vh-65px)] custom-scrollbar overflow-y-auto">
      <div class="p-2 bg-[#F8F8F8]">
        <slot />
      </div>
    </main>

    <!-- Tour Modal -->
     <Tour />
  </div>
</template>

<script setup>
import Header from "~/components/layout/header.vue";
import Sidebar from "~/components/layout/sidebar.vue";
import Tour from "~/components/dashboard/tour.vue";

const showSidebar = true;

</script>
