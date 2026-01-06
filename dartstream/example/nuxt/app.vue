<template>
  <div>
    <GlobalLoader />
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useHead } from 'nuxt/app'
import { useGtm } from '@gtm-support/vue-gtm'
import GlobalLoader from '~/components/GlobalLoader.vue'
import { ensureUuid, getReferral } from '~/utils/useReferral';

useHead({
  script: [
    {
      src: 'https://cdn.promotekit.com/promotekit.js',
      async: true,
      'data-promotekit': '1393ceb4-d9f7-4a16-8f24-4b14d32ca716',
    } as any,
  ],
  link: [
    {
      rel: 'stylesheet',
      href: 'https://api.fontshare.com/v2/css?f[]=satoshi@400,500,700&display=swap',
    },
  ],
})

const gtm = useGtm()
onMounted(() => {
  gtm?.trackEvent({ event: 'nuxt_gtm_ready', category: 'app', action: 'mounted' })
    const uuid = ensureUuid();             
      const referral = getReferral();   
      console.log('promotekit_referral', uuid,"referral" , referral);
            
})
</script>
