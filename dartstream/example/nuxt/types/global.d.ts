// types/global.d.ts
export {}

declare global {
  interface Window {
    dataLayer?: any[]
  }
}
