// plugins/00-promotekit.client.ts
import { defineNuxtPlugin, useCookie } from 'nuxt/app';

const REF_COOKIE = 'promotekit_referral';
const PK_URL = 'https://cdn.promotekit.com/promotekit.js';
const PK_KEY = '1393ceb4-d9f7-4a16-8f24-4b14d32ca716';

export default defineNuxtPlugin(() => {
  if (!process.client) return;

  // DEV override: last-click wins via URL param
  const url = new URL(window.location.href);
  const via =
    url.searchParams.get('via') ||
    url.searchParams.get('ref') ||
    url.searchParams.get('pk');

  if (via && via.trim()) {
    const ck = useCookie<string | null>(REF_COOKIE, {
      path: '/',
      sameSite: 'lax',
      maxAge: 60 * 60 * 24 * 30,
    });

  const shouldOverride = process.dev || !ck.value;
    if (shouldOverride && ck.value !== via) {
      // (optional) clear old values first to avoid any “restore”
      try { localStorage.removeItem(REF_COOKIE); } catch {}
      ck.value = via;
      try { localStorage.setItem(REF_COOKIE, via); } catch {}
      (globalThis as any).promotekit_referral = via;
      console.log('[PK] referral set from query:', via);
    }

    // Clean the URL
    ['via', 'ref', 'pk'].forEach((k) => url.searchParams.delete(k));
    history.replaceState({}, '', url.toString());
  }

  // Load PK script once, then run your capture
  if (!document.querySelector(`script[src="${PK_URL}"]`)) {
    const s = document.createElement('script');
    s.src = PK_URL;
    s.async = true;
    s.setAttribute('data-promotekit', PK_KEY);
    s.onload = () => {
      console.log('[PK] script loaded', (window as any).promotekit);
      captureWithRetry();
    };
    document.head.appendChild(s);
  } else {
    captureWithRetry();
  }
});

// ---- minimal capture (reads window.promotekit_referral/cookie/LS) ----
function captureWithRetry() {
  if (captureOnce()) return;
  let tries = 0;
  const iv = setInterval(() => {
    if (captureOnce() || ++tries > 30) clearInterval(iv);
  }, 100);
}

function captureOnce(): boolean {
  const ck = useCookie<string | null>(REF_COOKIE, {
    path: '/', sameSite: 'lax', maxAge: 60 * 60 * 24 * 30,
  });

  if (ck.value?.trim()) return true;

  const w: any = window;
  const fromGlobal = w?.promotekit_referral as string | undefined;
  const fromCookie = readCookie(REF_COOKIE);
  const fromLS = safeLSGet(REF_COOKIE);

  const candidate = [fromGlobal, fromCookie, fromLS]
    .find(v => typeof v === 'string' && v.trim().length > 0) as string | undefined;

  if (candidate) {
    ck.value = candidate;
    safeLSSet(REF_COOKIE, candidate);
    console.log('[PK] captured referral:', candidate);
    return true;
  }
  return false;
}

function readCookie(name: string): string | undefined {
  const re = new RegExp(`(?:^|;\\s*)${name}=([^;]*)`);
  const m = re.exec(document.cookie);
  const raw = m?.[1];
  if (!raw) return undefined;
  try { return decodeURIComponent(raw.replace(/\+/g, '%20')); } catch { return raw; }
}
function safeLSGet(key: string): string | undefined {
  try { return localStorage.getItem(key) ?? undefined; } catch { return undefined; }
}
function safeLSSet(key: string, val: string) {
  try { localStorage.setItem(key, val); } catch {}
}
