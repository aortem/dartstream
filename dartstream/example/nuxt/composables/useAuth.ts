// composables/useAuth.ts
export const useAuth = () => {
  const user = useState<any | null>('user', () => null)

  const fetchSession = async () => {
    try {
      const res = await $fetch('http://localhost:8080/auth/session', {
        credentials: 'include',
      })
      user.value = res.user
    } catch {
      user.value = null
    }
  }

  return { user, fetchSession }
}
