// plugins/analytics-pageview.client.ts
// Fires a 'page_view' event on first paint + every Nuxt route change.

import { defineNuxtPlugin } from 'nuxt/app'
import { useAnalytics } from '~/composables/useAnalytics'

export default defineNuxtPlugin((nuxtApp) => {
  if (import.meta.server) return
  const { trackPageView } = useAnalytics()

  // First paint
  trackPageView()

  // Dedupe guard: page:finish can also fire on initial load.
  // We remember the last path and only send when it changes.
  let lastPath =
    typeof window !== 'undefined'
      ? `${location.pathname}${location.search}${location.hash}`
      : ''

  // On SPA navigations
  nuxtApp.hook('page:finish', () => {
    const path = `${location.pathname}${location.search}${location.hash}`
    if (path === lastPath) return // prevent duplicate fire on initial render
    lastPath = path
    trackPageView()
  })
})
