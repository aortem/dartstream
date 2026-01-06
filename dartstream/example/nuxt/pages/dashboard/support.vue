<script setup lang="ts">
definePageMeta({
  layout: "dashboard",
});
</script>

<template>
  <div class="relative mt-4">
    <div class="flex items-center justify-between mb-6">
      <div class="text-[28px] leading-[40px] font-[500]">Support / Docs</div>
    </div>

    <div
      class="bg-white rounded shadow flex items-center justify-center flex-col"
      style="height: calc(100vh - 150px)"
    >
      <div>
        <svg
          width="58"
          height="57"
          viewBox="0 0 58 57"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <rect x="1" y="0.5" width="56" height="56" rx="28" fill="white" />
          <rect x="1" y="0.5" width="56" height="56" rx="28" stroke="#E9E9E9" />
          <path
            opacity="0.4"
            d="M30.5572 18.25C32.7479 18.25 34.4686 18.25 35.812 18.4306C37.1886 18.6157 38.2809 19.0027 39.1391 19.8609C39.9973 20.7191 40.3843 21.8114 40.5694 23.188C40.75 24.5314 40.75 26.2521 40.75 28.4428V28.5572C40.75 30.7479 40.75 32.4686 40.5694 33.812C40.3843 35.1886 39.9973 36.2809 39.1391 37.1391C38.2809 37.9973 37.1886 38.3843 35.812 38.5694C34.4686 38.75 32.7479 38.75 30.5572 38.75H30.4428C28.2521 38.75 26.5314 38.75 25.188 38.5694C23.8114 38.3843 22.7191 37.9973 21.8609 37.1391C21.0027 36.2809 20.6157 35.1886 20.4306 33.812C20.25 32.4686 20.25 30.7479 20.25 28.5572V28.4428C20.25 26.2521 20.25 24.5314 20.4306 23.188C20.6157 21.8114 21.0027 20.7191 21.8609 19.8609C22.7191 19.0027 23.8114 18.6157 25.188 18.4306C26.5314 18.25 28.2521 18.25 30.4428 18.25H30.5572Z"
            fill="#525866"
          />
          <path
            fill-rule="evenodd"
            clip-rule="evenodd"
            d="M30.5 25C29.9477 25 29.5 25.4477 29.5 26C29.5 26.5523 29.0523 27 28.5 27C27.9477 27 27.5 26.5523 27.5 26C27.5 24.3432 28.8431 23 30.5 23C32.1569 23 33.5 24.3432 33.5 26C33.5 26.5957 33.3253 27.1537 33.0241 27.6219C32.8433 27.9028 32.6337 28.1684 32.4471 28.4004C32.4122 28.4437 32.3781 28.4859 32.3449 28.527C32.1904 28.7182 32.0532 28.8881 31.926 29.0629C31.6099 29.4973 31.5 29.777 31.5 30C31.5 30.5523 31.0523 31 30.5 31C29.9477 31 29.5 30.5523 29.5 30C29.5 29.1184 29.9328 28.403 30.3088 27.8862C30.4687 27.6665 30.6441 27.4494 30.7993 27.2576C30.83 27.2195 30.86 27.1825 30.8889 27.1466C31.0739 26.9167 31.2241 26.7232 31.3422 26.5397C31.442 26.3845 31.5 26.2006 31.5 26C31.5 25.4477 31.0523 25 30.5 25Z"
            fill="#525866"
          />
          <path
            fill-rule="evenodd"
            clip-rule="evenodd"
            d="M29.5 33C29.5 32.4477 29.9457 32 30.4955 32H30.5045C31.0543 32 31.5 32.4477 31.5 33C31.5 33.5523 31.0543 34 30.5045 34H30.4955C29.9457 34 29.5 33.5523 29.5 33Z"
            fill="#525866"
          />
        </svg>
      </div>
      <h1
        class="text-center text-[20px] font-[500] leading-[-0.12px] w-[252px] mt-[12px]"
      >
        Need Help? Explore Our Documentation
      </h1>

      <p
        class="text-center text-[#525866] text-[14px] font-[400] leading-[-0.084px] w-[296px] mt-[12px]"
      >
        Find guides & tips to help you get the most out of Intellitoggle.
      </p>
      <a href="https://docs.intellitoggle.com/" target="_blank">
        <button
          class="text-[#fff] rounded-[8px] bg-[#42489E] shadow-[0_1px_2px_0_rgba(10,13,20,0.03)] w-[178px] h-[40px] p-[8px] flex justify-center items-center gap-[4px] bg-[#42489E] mt-[12px]"
        >
          Go to Documentation
        </button>
      </a>
    </div>
  </div>
</template>
