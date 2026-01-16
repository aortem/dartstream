// nuxt.config.ts
export default defineNuxtConfig({
  compatibilityDate: '2025-08-24',

  app: {
    head: {
      link: [
        { rel: 'icon', type: 'image/png', href: '/favicon.png' },
      ],
    },
  },

  ssr: false,

  devtools: { enabled: true },

  css: [
    '~/assets/css/tailwind.css',
    'shepherd.js/dist/css/shepherd.css',
    'vue-multiselect/dist/vue-multiselect.min.css',
  ],

  modules: [
    '@nuxt/content',
    '@nuxt/eslint',
    '@nuxt/icon',
    '@nuxt/image',
    '@nuxt/scripts',
    '@nuxtjs/tailwindcss',
  ],

  runtimeConfig: {
    public: {
      // ✅ DartStream backend
      dartstreamUrl:
        process.env.NUXT_PUBLIC_DARTSTREAM_URL || 'http://localhost:8080',

      // ✅ Auth provider selector (for testing SDKs)
      authProvider:
        process.env.NUXT_PUBLIC_DS_AUTH_PROVIDER || 'okta',

      // existing
      GTM_ID: process.env.NUXT_PUBLIC_GTM_ID || '',
    },
  },
})
