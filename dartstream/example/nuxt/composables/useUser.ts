// composables/useUser.ts
export const useUser = () => {
  const user = useState<any | null>('user', () => null)
  const loading = useState<boolean>('auth-loading', () => false)

  const config = useRuntimeConfig()

  const api = $fetch.create({
    baseURL: config.public.dartstreamUrl,
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json',
    },
  })

  const signIn = async (payload: {
    email: string
    password: string
    provider: string
  }) => {
    loading.value = true
    try {
      const res: any = await api('/auth/sign-in', {
        method: 'POST',
        body: payload,
      })

      user.value = res.user
      return res
    } finally {
      loading.value = false
    }
  }

  const signOut = async () => {
    await api('/auth/logout', { method: 'POST' })
    user.value = null
  }

  const fetchSession = async () => {
    try {
      const res: any = await api('/auth/session')
      user.value = res.user
      return res.user
    } catch {
      user.value = null
      return null
    }
  }

  return {
    user,
    loading,
    signIn,
    signOut,
    fetchSession,
  }
}
