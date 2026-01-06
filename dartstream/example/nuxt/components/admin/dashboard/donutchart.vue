<script setup lang="ts">
import { Chart as ChartJS, ArcElement, Tooltip, Legend, Title } from "chart.js";
import { Doughnut } from "vue-chartjs";


ChartJS.register(ArcElement, Tooltip, Legend, Title);

const chartData = {
  labels: ["Active Flags", "Inactive Flags", "Flags with Rollout"],
  datasets: [
    {
      data: [80.02, 24.53, 16.47],
      backgroundColor: ["#693EE0", "#47C2FF", "#E1E4EA"], 
      borderWidth: 0,
      cutout: "80%",
      borderRadius: 8,
    },
  ],
};

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  rotation: -90, 
  circumference: 180,
  plugins: {
    legend: {
      display: false,
    },
    tooltip: {
      enabled: false,
    },
  },
};
</script>

<template>
  <div class="bg-white p-3 rounded-[8px] w-full">
    <div class="flex justify-between">
      <h2 class="text-lg  mb-2">Flag Overview</h2>
      <img src="/assets/images/blackdots.png" alt="" class="w-auto h-5" />
    </div>

    <div class="relative h-[140px] mt-5">
      <Doughnut :data="chartData" :options="chartOptions" />

     
      <div
        class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-[35%] text-center"
      >
        <p class="text-xs text-gray-500">Total Flags</p>
        <p class="text-xl  text-gray-800">4,127</p>
      </div>
    </div>

    
    <div class="space-y-1 text-sm mt-8">
      <div class="flex items-center gap-2">
        <div class="w-4 h-4 bg-[#693EE0] rounded-[4px]"></div>
        <span class="flex-1">Active Flags</span>
        <span class="font-medium">80,02%</span>
      </div>
      <div class="flex items-center gap-2">
        <div class="w-4 h-4 bg-[#47C2FF] rounded-[4px]"></div>
        <span class="flex-1">Inactive Flags</span>
        <span class="font-medium">24,53%</span>
      </div>
      <div class="flex items-center gap-2">
        <div class="w-4 h-4 bg-[#E1E4EA] rounded-[4px]"></div>
        <span class="flex-1">Flags with Rollout</span>
        <span class="font-medium">16.47%</span>
      </div>
    </div>

    <button
      class="mt-8 mb-2 w-full border bg-[#F5F7FA] border-gray-300 text-sm text-gray-600 py-1.5 rounded-lg flex items-center justify-center gap-2 hover:bg-gray-100"
    >
      <img src="/assets/images/exchange.png" alt="" class="w-auto" />
      Refresh Data
    </button>
  </div>
</template>
