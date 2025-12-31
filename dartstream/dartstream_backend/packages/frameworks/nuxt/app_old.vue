<template>
  <div>
    <GlobalLoader />
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
  </div>
</template>

<script setup lang="ts">
import { useGtm } from '@gtm-support/vue-gtm'
import GlobalLoader from '~/components/GlobalLoader.vue'
const referralCookie = useCookie<string | undefined>('promotekit_referral')

useHead({
  link: [{ rel: 'stylesheet', href: 'https://api.fontshare.com/v2/css?f[]=satoshi@400,500,700&display=swap' }],
})

const gtm = useGtm()
onMounted(() => {
  gtm?.trackEvent({ event: 'nuxt_gtm_ready', category: 'app', action: 'mounted' })
  const params = new URLSearchParams(location.search)
  const fromCookie = referralCookie.value || null
  const fromWin = (window as any)?.promotekit_referral || null
  const fromUrl =
    params.get('referralId') ||
    params.get('via') ||
    params.get('referral') ||
    params.get('ref') ||
    null

  console.table({ referral_id: fromCookie })
  console.log('Referral ID:', fromCookie )
})
</script>
