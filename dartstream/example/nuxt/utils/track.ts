// utils/track.ts
const PROD_HOST = 'app.intellitoggle.com'
const FAILURE_SUFFIXES = ['_failed']
const SENSITIVE = new Set([
  'password','pwd','secret','client_secret','jwt','access_token','id_token','refresh_token'
])

const toTitle = (s:string) =>
  s.replace(/_/g,' ').replace(/\w\S*/g, w => w[0].toUpperCase()+w.slice(1).toLowerCase())
const toSnake = (k:string) =>
  k.replace(/[A-Z]/g, m => '_' + m.toLowerCase()).replace(/[\s\-]+/g,'_')
const iso = (x:any) => new Date(x).toISOString()

const clean = (obj:Record<string,any>, allowEmail:boolean) => {
  const out:Record<string,any> = {}
  for (const [k,v] of Object.entries(obj||{})) {
    const key = toSnake(k)
    if (v === undefined) continue
    if (SENSITIVE.has(key)) { out[key] = '[REDACTED]'; continue }
    if (!allowEmail && ['email','email_id','user_email'].includes(key)) {
      out[key] = '[REDACTED]'; continue
    }
    out[key] = v instanceof Date ? iso(v) : v
  }
  return out
}

export function track(nameSnake: string, props: Record<string,any> = {}) {
  // Nuxt 3+ safe: prefer import.meta.server over process.server
  if (import.meta.server) return

  // Only push on production host and when GTM is present
  if (window.location.hostname !== PROD_HOST) return
  const cfg = useRuntimeConfig().public
  if (!cfg.GTM_ID) return

  const dl = (window as any).dataLayer
  if (!Array.isArray(dl)) return

  const name = toTitle(nameSnake)
  const isFail = FAILURE_SUFFIXES.some(s => nameSnake.endsWith(s))
  dl.push({ event: name, ...clean(props, !isFail) })
}
