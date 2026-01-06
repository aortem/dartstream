// nuxt.config.ts
export default defineNuxtConfig({
   compatibilityDate: '2025-08-24',
  app: {
    head: {
      link: [
        { rel: 'icon', type: 'image/png', href: '/favicon.png' } 
      ]
    }
  },
  ssr: false,
  devtools: { enabled: true },
  css: [
    "~/assets/css/tailwind.css",
    "shepherd.js/dist/css/shepherd.css",
    "vue-multiselect/dist/vue-multiselect.min.css",
  ],
  modules: [
    "@nuxt/content",
    "@nuxt/eslint",
    "@nuxt/icon",
    "@nuxt/image",
    "@nuxt/scripts",
    "@nuxtjs/tailwindcss"
  ],
  // ⬅️ added: expose GTM ID only (we’re using GTM, not raw GA)
  runtimeConfig: {
    public: {
      GTM_ID: process.env.NUXT_PUBLIC_GTM_ID || '' // set only in prod deploy
    }
  }
})
