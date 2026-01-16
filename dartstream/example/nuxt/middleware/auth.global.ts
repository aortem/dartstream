// middleware/auth.global.ts
export default defineNuxtRouteMiddleware(async (to) => {
  const publicRoutes = [
    '/auth/login',
    '/auth/register',
    '/auth/forgot',
  ]

  if (publicRoutes.includes(to.path)) {
    return
  }

  const { fetchSession, user } = useUser()

  // Try to restore session from DartStream
  const sessionUser = user.value ?? (await fetchSession())

  // ❌ Not authenticated → login
  if (!sessionUser) {
    return navigateTo('/auth/login')
  }

  /* ----------------------------------
   * Business logic (unchanged concept)
   * ---------------------------------- */
  const subscriptionStatus = sessionUser.subscriptionStatus
  const isSandbox = sessionUser.isSandbox === true

  const hasActivePlan = subscriptionStatus === 'active'
  const isInactive = ['inactive', 'none'].includes(subscriptionStatus)

  const onDashboard = to.path.startsWith('/dashboard')
  const onMembership = to.path.startsWith('/membership')

  // ✅ Sandbox or active subscription → dashboard
  if ((isSandbox || hasActivePlan) && !onDashboard) {
    return navigateTo('/dashboard')
  }

  // ❌ No plan → membership
  if (!isSandbox && isInactive && !onMembership) {
    return navigateTo('/membership')
  }
})
