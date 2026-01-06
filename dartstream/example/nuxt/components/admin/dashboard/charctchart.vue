<script setup lang="ts">
import {
  Chart as ChartJS,
  LineElement,
  PointElement,
  CategoryScale,
  LinearScale,
  Tooltip,
  Filler
} from 'chart.js'
import { Line } from 'vue-chartjs'
import { ref, onMounted } from 'vue'

ChartJS.register(LineElement, PointElement, CategoryScale, LinearScale, Tooltip, Filler)

const chartData = ref<any>(null)
const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { display: false },
    tooltip: { enabled: true }
  },
  scales: {
    y: {
      min: 10000,
      max: 50000,
      ticks: {
        stepSize: 10000,
        callback: (value: number) => `$${value / 1000}k`,
        color: '#6B7280'
      },
      grid: { color: '#E5E7EB' }
    },
    x: {
      ticks: {
        color: '#6B7280',
        padding: 10
      },
      grid: {
        display: false
      }
    }
  }
}


onMounted(() => {
  const canvas = document.createElement('canvas')
  const ctx = canvas.getContext('2d')!

  const gradient = ctx.createLinearGradient(0, 0, 0, 300)
  gradient.addColorStop(0, '#E2D8FF')
  gradient.addColorStop(1, '#ffffff')

  chartData.value = {
    labels: ['Oct 16', 'Oct 17', 'Oct 18', 'Oct 19', 'Oct 20'],
    datasets: [
      {
        label: 'Feature Flags',
        data: [12000, 28000, 34000, 27000, 45000],
        fill: true,
        backgroundColor: gradient,
        borderColor: '#8B5CF6',
        tension: 0.4,
        pointRadius: 0
      }
    ]
  }
})
</script>


<template>
  <div class="bg-white p-4 rounded-[8px]  w-full ">
  
    <div class="flex justify-between items-start mb-4">
      <div>
        <h2 class="text-lg  ">Total Flags</h2>
        <div class="flex items-center gap-2 mt-1">
          <p class="text-2xl font-bold text-gray-900">4,127</p>
          <span class="text-[#1DBF73] text-xs bg-[#E8FFF4] border border-[#8FE7BE] p-1 rounded-[8px]">▲ 12%</span>
          <p class="text-sm text-gray-400 mt-1">vs last Week</p>
        </div>
      </div>
      <div class="flex items-center gap-2 text-sm border border-[#E1E4EA]  rounded-[8px]">
        <select class=" text-sm border-r border-[#E1E4EA] p-2 rounded-l-[8px]">
          <option>Last 7 days</option>
        </select>
        <div class="flex gap-2">
            <img src="/assets/images/calender.png" alt="" class="w-auto h-5 mt-2" />
        <input
          type="text"
          value="Oct 16 - Oct 22 2025"
          class="text-sm p-2 rounded-r-[8px] "
          readonly
        /></div>
      </div>
    </div>

   
    <div class="h-[280px]">
         <Line v-if="chartData" :data="chartData" :options="chartOptions" />
    </div>
  </div>
</template>

<style scoped>
canvas {
  font-smooth: always;
  -webkit-font-smoothing: antialiased;
}
</style>
