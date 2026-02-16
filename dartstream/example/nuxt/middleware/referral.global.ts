export default defineNuxtRouteMiddleware((to) => {
  if (process.server) return;

  const ref = (to.query.ref as string) || (to.query.pk_ref as string);
  if (ref) {
    // 1) persist the explicit ref param
    setReferralCookie(ref);
  } else {
    // 2) fallback to window variable from script (if not already cookie’d)
    const hasCookie = document.cookie.includes('promotekit_referral=');
    if (!hasCookie) {
      const winRef = (window as any)?.promotekit_referral as string | undefined;
      if (winRef) setReferralCookie(winRef);
    }
  }
});
