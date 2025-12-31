
export default defineNuxtConfig({
   app: {
    head: {
      link: [
        { rel: 'icon', type: 'image/png', href: '/favicon.png' } // ✅ Path from public folder
      ]
    }
  },
  ssr: false,
  runtimeConfig: {
    public: {
     
    },
  },
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
    "@nuxtjs/tailwindcss",
  ],
});

