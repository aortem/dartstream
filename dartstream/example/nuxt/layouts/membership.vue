<template>
  <div class="min-h-screen w-full bg-[#F8F8F8] relative">
    <!-- Fixed Header -->
    <div class="fixed top-0 left-0 w-full z-20">
      <Header />
    </div>

    <div class="flex">
      <!-- Scrollable Main Content -->
      <main class="mt-16 flex-1 h-[calc(100vh-64px)] overflow-y-auto p-6 ">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import Header from "~/components/layout/header.vue";
</script>
