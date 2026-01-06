// composables/useUser.ts
export async function useUser() {
  const token = localStorage.getItem('auth_token') // or from cookies if SSR-safe
  
  if (!token) return
  const { $api } = useNuxtApp() 
  try {
    const response = await $api('/auth/user-status', {
      headers: { Authorization: `Bearer ${token}` },
    })

    localStorage.setItem('user_status', JSON.stringify(response))
    return response
  } catch (error) {
    console.error('Failed to fetch user:', error)
    localStorage.removeItem('user_status')
  }
}
