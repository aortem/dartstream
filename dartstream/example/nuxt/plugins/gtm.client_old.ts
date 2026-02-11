// plugins/gtm.client.ts
import VueGtm from '@gtm-support/vue-gtm'
import { defineNuxtPlugin, useRuntimeConfig } from 'nuxt/app'

export default defineNuxtPlugin((nuxtApp) => {
  if (import.meta.server) return

  const { public: cfg } = useRuntimeConfig()
  const host = window.location.hostname

  // ✅ Prod host
  const onProdHost = host === 'app.dartstream.com'

  // ✅ Firebase preview host (always starts with dartstream-open-dev--)
  const onFirebasePreview = host.startsWith('dartstream-open-dev--')

  // ✅ Local dev convenience
  const onLocal =
    host === 'localhost' || host === '127.0.0.1' || host === '0.0.0.0'

  // ✅ Optional override via CI/CD
  const forceEnable = (cfg.GTM_FORCE_ENABLE || '').toString() === 'true'

  // Allow GTM if any of the above are true
  if (!cfg.GTM_ID || !(onProdHost || onFirebasePreview || onLocal || forceEnable)) return

  nuxtApp.vueApp.use(VueGtm, {
    id: cfg.GTM_ID,
    enabled: true,
    loadScript: true,
    defer: true,
    vueRouter: nuxtApp.$router,
    trackOnNextTick: false,
  })

  window.dataLayer = window.dataLayer || []
  window.dataLayer.push({ event: 'gtm_boot', ts: Date.now() })
})
