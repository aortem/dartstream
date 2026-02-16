<template>
  <div class="w-full">
    <div class="p-6">
      <!-- Tab Content -->

      <div>
        <div class="">
          <div>
            <div class="flex gap-3">
              <h1 class="text-2xl">Flag Usage Analytics</h1>
            </div>

            <p class="text-sm text-gray-500">
              Track how often and where each feature flag is evaluated.
            </p>
          </div>
          <div class="mt-5">
            <UsageBarCharts />
          </div>
          <div class="border rounded-[8px] p-4 mt-5">
            <div class="flex justify-between items-center border-b pb-4">
              <div class="flex gap-3">
                <img src="/assets/images/flag.png" alt="" class="w-6" />
                <p class="text-gray-700 flex items-center gap-2 font-medium">
                  Top 3 flags by usage
                </p>
              </div>
              <select
                class="text-sm text-gray-500 border border-gray rounded-[8px] px-2 py-1"
              >
                <option>Last Year</option>
              </select>
            </div>
            <div class="border rounded-[8px] p-4 mt-4 bg-[#F8F8F8]">
              <div class="flex justify-between items-center">
                <div class="">
                  <p class="text-gray-700 flex items-center gap-2 font-medium">
                    enable-new-ui
                  </p>
                  <p class="text-sm text-gray-500">
                    Gates the new onboarding experience.
                  </p>
                </div>
                <div
                  class="text-sm text-gray-500 border border-gray rounded-[8px] bg-white px-4 py-1 cursor-pointer"
                >
                  Check flag
                </div>
              </div>
            </div>
            <div class="border rounded-[8px] p-4 mt-4 bg-[#F8F8F8]">
              <div class="flex justify-between items-center">
                <div class="">
                  <p class="text-gray-700 flex items-center gap-2 font-medium">
                    enable-new-ui
                  </p>
                  <p class="text-sm text-gray-500">
                    Gates the new onboarding experience.
                  </p>
                </div>
                <div
                  class="text-sm text-gray-500 border border-gray rounded-[8px] bg-white px-4 py-1 cursor-pointer"
                >
                  Check flag
                </div>
              </div>
            </div>
            <div class="border rounded-[8px] p-4 mt-4 bg-[#F8F8F8]">
              <div class="flex justify-between items-center">
                <div class="">
                  <p class="text-gray-700 flex items-center gap-2 font-medium">
                    enable-new-ui
                  </p>
                  <p class="text-sm text-gray-500">
                    Gates the new onboarding experience.
                  </p>
                </div>
                <div
                  class="text-sm text-gray-500 border border-gray rounded-[8px] bg-white px-4 py-1 cursor-pointer"
                >
                  Check flag
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup lang="ts">
import UsageBarCharts from "~/components/analytics/barcharts.vue";
</script>
