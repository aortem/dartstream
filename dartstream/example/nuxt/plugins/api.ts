// plugins/api.ts
export default defineNuxtPlugin((nuxtApp) => {
  const api = async (url: string, options: any = {}) => {
    const { start, stop } = useLoading()
    start()

    try {
      // 🔽 Detect current hostname (client-side only)
      const hostname = process.client ? window.location.hostname : ''

      // 🔽 Production vs Dev
      const baseURL =
        hostname === 'app.intellitoggle.com'
          ? 'https://api.intellitoggle.com'
          : 'https://dev-api.intellitoggle.com'

      const getAccessToken = () => useCookie('auth_token')?.value || localStorage.getItem('auth_token')
      const getRefreshToken = () => localStorage.getItem('refresh_token')

      options.headers = {
        ...(options.headers || {}),
        Authorization: getAccessToken() ? `Bearer ${getAccessToken()}` : '',
        'Content-Type': 'application/json',
      }

      options.credentials = 'include'

      const attemptRequest = async () => {
        return await $fetch(`${baseURL}${url}`, {
          ...options,
        })
      }

      try {
        return await attemptRequest()
      } catch (error: any) {
        if (error?.response?.status === 401 && getRefreshToken()) {
          const refreshResponse: { token: string } = await $fetch(`${baseURL}/auth/refresh-token`, {
            method: 'POST',
            body: { refreshToken: getRefreshToken() },
            headers: { 'Content-Type': 'application/json' },
          })

          if (refreshResponse.token) {
            useCookie('auth_token', { path: '/', maxAge: 60 * 60 }).value = refreshResponse.token
            localStorage.setItem('auth_token', refreshResponse.token)

            options.headers.Authorization = `Bearer ${refreshResponse.token}`
            return await attemptRequest()
          }
        }
        throw error
      }
    } finally {
      stop()
    }
  }

  nuxtApp.provide('api', api)
})
