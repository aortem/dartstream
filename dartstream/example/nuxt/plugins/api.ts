// plugins/api.ts
export default defineNuxtPlugin((nuxtApp) => {
  const api = async (url: string, options: any = {}) => {
    const { start, stop } = useLoading()
    start()

    try {
      const hostname = process.client ? window.location.hostname : ''

      const isDartStreamDev =
        process.client && hostname === 'localhost'

      const baseURL =
        hostname === 'localhost'
          ? 'http://localhost:8080'
          : hostname === 'app.dartstream.com'
            ? 'https://api.dartstream.com'
            : 'https://dev-api.dartstream.com'

      // 🚨 BLOCK non-auth calls in DartStream mode
      if (isDartStreamDev && !url.startsWith('/auth')) {
        console.warn('[DartStream DEV] Skipped:', url)
        return null
      }

      options.headers = {
        ...(options.headers || {}),
        'Content-Type': 'application/json',
      }

      options.credentials = 'include'

      const attemptRequest = async () => {
        return await $fetch(`${baseURL}${url}`, {
          ...options,
        })
      }

      return await attemptRequest()
    } finally {
      stop()
    }
  }

  nuxtApp.provide('api', api)
})
