// utils/useReferral.ts
import { useCookie } from 'nuxt/app';

export const REF_COOKIE  = 'promotekit_referral';
export const UUID_COOKIE = 'promotekit_referral_uuid';

/**
 * Ensure there's a UUID stored in cookies (and mirror to localStorage).
 * Returns the UUID string on client, or null during SSR if not yet set.
 */
export function ensureUuid(): string | null {
  const uuidCookie = useCookie<string | null>(UUID_COOKIE, {
    path: '/', sameSite: 'lax', maxAge: 60 * 60 * 24 * 365,
  });

  if (uuidCookie.value?.trim()) return uuidCookie.value;
  if (!process.client) return null;

  const newUuid = globalThis.crypto?.randomUUID?.() ?? v4polyfill();
  uuidCookie.value = newUuid;
  try { localStorage.setItem(UUID_COOKIE, newUuid); } catch {}
  return newUuid;
}

/**
 * Get the PromoteKit referral code.
 * Prefers the official cookie, then legacy cookie, then window/global or localStorage.
 */
export function getReferral(): string | undefined {
  const ck = useCookie<string | null>(REF_COOKIE, { path: '/' });
  if (ck.value?.trim()) return ck.value;

  // legacy cookie name (if you used it earlier)
  const legacy = useCookie<string | null>('promotekit_referral_code', { path: '/' });
  if (legacy.value?.trim()) return legacy.value;

  if (!process.client) return undefined;

  const w = window as any;
  const fromGlobal = (w?.promotekit_referral as string | undefined)?.trim();
  if (fromGlobal) return fromGlobal;

  try {
    const fromLS = localStorage.getItem(REF_COOKIE)?.trim();
    return fromLS || undefined;
  } catch {
    return undefined;
  }
}

// ---------- helpers ----------
function v4polyfill(): string {
  const rnds = getRandomBytes(16);
  const r6 = rnds[6] ?? 0;
  const r8 = rnds[8] ?? 0;
  rnds[6] = (r6 & 0x0f) | 0x40; // version 4
  rnds[8] = (r8 & 0x3f) | 0x80; // variant
  const hex = Array.from(rnds, (b) => b.toString(16).padStart(2, '0')).join('');
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20)}`;
}

function getRandomBytes(n: number): Uint8Array {
  const arr = new Uint8Array(n);
  if (typeof globalThis !== 'undefined' && globalThis.crypto?.getRandomValues) {
    return globalThis.crypto.getRandomValues(arr);
  }
  for (let i = 0; i < n; i++) arr[i] = Math.floor(Math.random() * 256);
  return arr;
}
