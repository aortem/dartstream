<template>
  <div class="bg-white rounded-lg border p-6 w-full">
    <div class="flex justify-between items-center mb-4">
      <div class="flex gap-2">
        <img src="/assets/images/linechart.png" alt="" class="w-6" />
        <h2 class="text-gray-700 flex items-center gap-2">Usage</h2>
      </div>
      <select
        class="text-sm text-gray-500 border border-gray rounded-[8px] px-2 py-1"
      >
        <option>Last Year</option>
      </select>
    </div>

    <div class="h-72 relative">
      <Bar :data="chartData" :options="chartOptions" />
    </div>
  </div>
</template>

<script setup>
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
} from "chart.js";
import { Bar } from "vue-chartjs";

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale
);

// Main blue data
const actualData = [
  4000, 3900, 4100, 3600, 5000, 11000, 9500, 15500, 7500, 5200, 6900, 6300,
];
const maxVal = 20000;
const fillerData = actualData.map((val) => maxVal - val);

const chartData = {
  labels: [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ],
  datasets: [
    {
      label: "Actual",
      data: actualData,
      backgroundColor: "#3F3F92",
      barThickness: 60,
      borderRadius: 4,
      stack: "stack1",
    },
    {
      label: "Filler",
      data: fillerData,
      backgroundColor: "#E5E7EB",
      barThickness: 60,
      borderRadius: 0,
      stack: "stack1",
    },
  ],
};

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  scales: {
    y: {
      stacked: true,
      ticks: {
        display: true,
        color: "#A0AEC0",
        stepSize: 5000, // yeh 0, 5k, 10k, 15k, 20k banayega
        callback: function (value) {
          return value >= 1000 ? value / 1000 + "k" : value;
        },
      },
      max: 20000, // yeh zaroori hai agar aap fixed values chahte ho
      min: 0,
      grid: {
        display: false,
        drawBorder: false,
      },
    },
    x: {
      stacked: true,
      ticks: {
        color: "#A0AEC0",
      },
      grid: {
        display: false,
        drawBorder: false,
      },
    },
  },
  plugins: {
    legend: {
      display: false,
    },
    tooltip: {
      mode: "index",
      intersect: false,
    },
  },
};
</script>
