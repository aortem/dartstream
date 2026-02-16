<script setup lang="ts">
const closePrompt = () => {
    // Handle navigation or modal opening for upgrade
    console.log('Upgrade clicked');
};
const router = useRouter();

const upgradeNow = () => {
    // Handle reset action
    router.push('/dashboard/setting?tab=subscription');
    console.log('Reset now clicked');
};
</script>

<template>
    <div class="w-full">

        <!-- Content Area -->
        <div class="bg-white rounded-b-lg px-28 py-28">
            <!-- Red Banner -->
            <div data-cy="upgrade-prompt" class="bg-[#FC5050] text-white px-6 py-3 rounded-[10px] flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <div class="w-5 h-5 rounded-full bg-white flex items-center justify-center flex-shrink-0">
                        <span class="text-[#FC5050] text-sm font-bold">!</span>
                    </div>
                    <div class="flex items-center gap-2 flex-wrap">
                        <span class="font-medium">Upgrade your membership</span>
                        <span class="text-red-100">•</span>
                        <span class="text-red-100">To see your Analytics</span>
                        <button @click="upgradeNow" class="underline hover:no-underline font-medium">
                            Upgrade Now
                        </button>
                    </div>
                </div>
                <button @click="closePrompt" class="text-white hover:text-red-100 transition-colors" aria-label="Close">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>

            <div class="flex justify-between align-middle mt-6 mb-6">
                <div class="flex gap-[15px]">
                    <div class="bg-[#F5F7FA] rounded-full h-10 w-10"></div>
                    <div>
                        <div class="bg-[#F5F7FA] rounded-sm p-2 h-3 w-[109px] mb-2"></div>
                        <div class="bg-[#F5F7FA] rounded-sm p-2 h-3 w-[52px]"></div>
                    </div>
                </div>
                <div>
                    <div class="bg-[#F5F7FA] rounded-full p-2 w-[100px] h-8"></div>
                </div>
            </div>

            <div class="max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Card 1 -->
                <div class="bg-[#F5F7FA] rounded-lg p-6 h-48"></div>

                <!-- Card 2 -->
                <div class="bg-[#F5F7FA] rounded-lg p-6 h-48"></div>

                <!-- Card 3 -->
                <div class="bg-[#F5F7FA] rounded-lg p-6 h-48"></div>
            </div>

            <!-- Additional rows -->
            <div class="max-w-4xl mx-auto mt-6 space-y-4">
                <div class="bg-[#F5F7FA] rounded-lg h-12"></div>
                <div class="bg-[#F5F7FA] rounded-lg h-12"></div>
                <div class="bg-[#F5F7FA] rounded-lg h-12"></div>
                <div class="bg-[#F5F7FA] rounded-lg h-12"></div>
                <!-- <div class="bg-[#F5F7FA] rounded-lg h-32"></div> -->
            </div>
        </div>
    </div>
</template>