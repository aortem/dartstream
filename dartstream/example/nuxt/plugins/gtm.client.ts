// plugins/gtm.client.ts
// Loads GTM on client; gates by host; guarantees dataLayer exists early.

import VueGtm from '@gtm-support/vue-gtm'
import { defineNuxtPlugin, useRuntimeConfig } from 'nuxt/app'

export default defineNuxtPlugin((nuxtApp) => {
  if (import.meta.server) return

  const { public: cfg } = useRuntimeConfig()
  const host = window.location.hostname

  // Allow on prod, Firebase preview, or local — plus an explicit override
  const onProdHost = host === 'app.dartstream.com'
  const onFirebasePreview = host.startsWith('dartstream-open-dev--')
  const onLocal =
    host === 'localhost' || host === '127.0.0.1' || host === '0.0.0.0'
  const forceEnable = (cfg.GTM_FORCE_ENABLE || '').toString() === 'true'

  if (!cfg.GTM_ID || !(onProdHost || onFirebasePreview || onLocal || forceEnable)) return

  // Ensure dataLayer exists BEFORE GTM boots (some tags read gtm.start)
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const w = window as any
  w.dataLayer = w.dataLayer || []
  w.dataLayer.push({ 'gtm.start': Date.now(), event: 'gtm.js' })

  // TS: we know it's truthy after the guard; cast to satisfy VueGtm types.
  const gtmId = cfg.GTM_ID as string

  // Load GTM via vue-gtm (adds the script + router integration)
  nuxtApp.vueApp.use(VueGtm, {
    id: gtmId,
    enabled: true,
    loadScript: true,
    defer: true,
    vueRouter: nuxtApp.$router,   // lets GTM listen to route changes if you ever need it
    trackOnNextTick: false,
  })

  // Optional: a boot breadcrumb you can see in GTM preview
  w.dataLayer.push({ event: 'gtm_boot', ts: Date.now() })
})
