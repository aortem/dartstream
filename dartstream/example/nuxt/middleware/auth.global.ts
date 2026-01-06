export default defineNuxtRouteMiddleware((to) => {
  const token = useCookie("auth_token");

  if (
    !token.value &&
    to.path !== "/auth/login" &&
    to.path !== "/auth/register" && 
    to.path !== "/auth/forgot" 
  ) {
    useCookie("auth_token").value = null;
    localStorage.removeItem("auth_token");
    localStorage.removeItem("refresh_token");
    localStorage.removeItem("auth_user");
    localStorage.removeItem("sandbox");
    localStorage.clear();
    return navigateTo("/auth/login");
  }

  if (process.client && token.value) {
    const userStatusRaw = localStorage.getItem("user_status");

    if (userStatusRaw) {
      try {
        const userStatus = JSON.parse(userStatusRaw);
        const isInactive = ["inactive", "none"].includes(
          userStatus?.subscriptionStatus
        );
        const isSandbox = userStatus?.isSandbox === true;
        const hasActivePlan = userStatus?.subscriptionStatus === "active";

        const onDashboard = to.path.startsWith("/dashboard");
        const onMembership = to.path.startsWith("/membership");

        // ✅ If sandbox or subscription is active → go to dashboard
        if ((isSandbox || hasActivePlan) && !onDashboard) {
          return navigateTo("/dashboard");
        }

        // ❌ If not sandbox and not active → go to membership
        if (!isSandbox && !hasActivePlan && !onMembership) {
          return navigateTo("/membership");
        }
      } catch (err) {
        console.warn("❌ Failed to parse user_status:", err);
      }
    }
  }
});
