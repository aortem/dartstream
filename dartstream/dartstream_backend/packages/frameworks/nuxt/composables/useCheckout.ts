import { ensureUuid, getReferral } from '~/utils/useReferral';

export function useCheckout() {
  const startCheckout = async (planId: string) => {
    try {
      const { $api } = useNuxtApp();

      if (['enterprise', 'entreprise'].includes(planId)) {
        console.warn('Coming Soon');
        return;
      }

      const uuid = ensureUuid();              // string | null
      const referral = getReferral();          // string | undefined

      const payload: Record<string, any> = {
        type: 'subscription',
        planId,
        successUrl: process.client ? `${location.origin}/membership/membership-paid` : '/membership/membership-paid',
        cancelUrl:  process.client ? `${location.origin}/membership` : '/membership',
      };
      if (uuid) payload.promotekit_referral = uuid;
      if (referral) payload.referralCode = referral;

      const res = await $api('/api/billing/checkout', { method: 'POST', body: payload });
      if (res?.checkoutUrl && process.client) window.location.href = res.checkoutUrl;
      else console.warn('⚠️ No checkout URL returned in response');
    } catch (e) {
      console.error('❌ Error starting checkout:', e);
    }
  };

  return { startCheckout };
}
