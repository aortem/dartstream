export default defineNuxtPlugin(async () => {
  try {
    const data = await $fetch('http://localhost:8080/auth/session', {
      credentials: 'include',
    })

    useUserStore().setUser(data.user)
  } catch {
    // not logged in → ignore
  }
})
