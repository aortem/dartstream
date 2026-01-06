// composables/useAnalytics.ts
// Dynamic, low-code analytics API.
// - All events funnel through `track(name, props)` -> {event:'track', event_name, props:{}, ts}
// - Separate lightweight 'identify' + 'alias' events for GTM → Mixpanel tags.

type Dict = Record<string, unknown>

export type AnalyticsEventName =
  | 'page_view'
  | 'signup_login'        // your combined auth event (still supported)
  | 'signup_started'
  | 'signup_completed'
  | 'login_success'
  | 'login_failed'
  | 'project_created'
  | 'flag_created' | 'flag_updated' | 'flag_deleted' | 'flag_toggled'
  | 'experiment_created'
  | 'profile_updated'
  | 'billing_page_opened'
  | 'plan_upgraded'
  | 'plan_canceled'

// NOTE: user_id is optional so call sites like (res.user.id || res.user._id) type-check,
// and helpers below no-op if it's missing.
export type SignupLoginPayload = {
  user_id?: string
  email?: string             // will be redacted before sending
  full_name?: string
  plan?: 'standard' | 'enhanced' | 'enterprise' | string
  user_role?: string
  signup_ts?: number         // Date.now()
  method?: 'email' | 'google' | 'microsoft' | 'github' | string
  referral_source?: string
  project_id?: string
  flag_id?: string
  experiment_id?: string
}

// ---- helpers (minimal and safe) --------------------------------------------

function redactEmail(email?: string | null): string | undefined {
  if (!email) return undefined
  const [u, d] = email.split('@')
  if (!u || !d) return undefined
  const [name, ...rest] = d.split('.')
  const maskedU = u.length <= 1 ? '*' : `${u[0]}***`
  const maskedName = name ? `${name[0]}***` : '***'
  const tld = rest.join('.') || '***'
  return `${maskedU}@${maskedName}.${tld}`
}

function prune<T extends Dict>(obj: T): T {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const out: any = {}
  Object.entries(obj || {}).forEach(([k, v]) => {
    if (v !== null && v !== undefined) out[k] = v
  })
  return out
}

function dlPush(payload: Dict) {
  if (typeof window === 'undefined') return
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const w = window as any
  w.dataLayer = w.dataLayer || []
  w.dataLayer.push(payload)
}

/** Best-effort env for your DLV - env (dev/stage/prod). */
function getEnv(): string | undefined {
  try {
    // Nuxt 3 public runtime config or typical envs; fallbacks are harmless

    const nuxtEnv = window?.__NUXT__?.config?.public?.appEnv
    // @ts-expect-error vite/import meta in client
    const viteEnv = import.meta?.env?.VITE_APP_ENV || import.meta?.env?.MODE
 
    const nodeEnv = (window as any)?.process?.env?.NUXT_PUBLIC_APP_ENV || (window as any)?.process?.env?.NODE_ENV
    return (nuxtEnv || viteEnv || nodeEnv || undefined) as string | undefined
  } catch {
    return undefined
  }
}

/** Attach first-touch UTM *and* normalize to your DLV - referral_source. */
function withAttribution(props: Dict = {}): Dict {
  try {
    const url = new URL(window.location.href)
    const utm_source =
      url.searchParams.get('utm_source') || localStorage.getItem('utm_source') || undefined
    const utm_medium =
      url.searchParams.get('utm_medium') || localStorage.getItem('utm_medium') || undefined
    const utm_campaign =
      url.searchParams.get('utm_campaign') || localStorage.getItem('utm_campaign') || undefined

    // Persist first-touch UTM if not already stored
    const pairs: Array<[key: string, value?: string]> = [
      ['utm_source', utm_source],
      ['utm_medium', utm_medium],
      ['utm_campaign', utm_campaign],
    ]
    for (const [key, value] of pairs) {
      if (typeof value === 'string' && !localStorage.getItem(key)) {
        localStorage.setItem(key, value)
      }
    }

    // IMPORTANT: you have DLV - referral_source in GTM.
    // We populate both `utm_*` AND `referral_source` so GTM can pick either.
    const referral_source =
      (props['referral_source'] as string | undefined) ||
      utm_source ||
      (document.referrer ? new URL(document.referrer).hostname : undefined)

    return prune({
      ...props,
      utm_source,
      utm_medium,
      utm_campaign,
      referral_source, // ← maps your DLV - referral_source
    })
  } catch {
    return props
  }
}

// ---- public API -------------------------------------------------------------

/** Generic event: the ONE function most of your code should call. */
function track(eventName: AnalyticsEventName, props: Dict = {}) {
  const enrichedProps = withAttribution(
    prune({
      ...props,
      env: getEnv(),
      path: typeof window !== 'undefined' ? window.location.pathname : undefined,
      sdk_lang: 'vue',
      ts: Date.now(),
    })
  )

  const payload = prune({
    event: eventName,
    ...enrichedProps,
  })
  
  dlPush(payload)

}

/** Identify the user (Mixpanel People set happens in GTM). */
// TS-safe: accept possibly-undefined, no-op if missing to avoid "string | undefined" errors.
function identify(user_id?: string, user_properties: Dict = {}) {
  if (!user_id) return
  dlPush({
    event: 'identify',
    user_id,
    user_properties: prune(user_properties), // e.g., { full_name, plan, user_role }
  })
}

/** Join anonymous → known (first login on this device/session). */
// TS-safe: accept possibly-undefined, no-op if missing.
function alias(new_id?: string, previous_id?: string) {
  if (!new_id) return
  dlPush({ event: 'alias', new_id, previous_id })
}

/** Convenience for SPA page views (auto-called in the pageview plugin). */
function trackPageView(extra?: Dict) {
  track('page_view', prune({ ...extra }))
}

/**
 * Backward-compatible helper you already use in login/register.
 * - Calls identify first (with *redacted* email only)
 * - Emits a single 'signup_login' event carrying your DLV fields.
 *   (GTM will forward event_name + props into Mixpanel).
 */
function trackSignupLogin(p: SignupLoginPayload) {
  const safe = prune({
    ...p,
    email_redacted: redactEmail(p.email), // ← never send raw email
  })
  // we do NOT attach raw `email` to the data layer
  delete (safe as Dict)['email']

  if (p.user_id) {
    identify(p.user_id, {
      full_name: p.full_name,
      $email: p.email,
      email_redacted: safe.email_redacted,
      plan: p.plan,
      user_role: p.user_role,
    })
  }

  // Include your DLV keys right under props:
  // user_id, full_name, plan, user_role, signup_ts, method, referral_source, etc.
  track('signup_login', safe)
}

export function useAnalytics() {
  return { track, trackPageView, identify, alias, trackSignupLogin, redactEmail, prune }
}
