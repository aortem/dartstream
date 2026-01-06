// tailwind.config.ts
import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './components/**/*.{vue,js,ts}',
    './layouts/**/*.vue',
    './pages/**/*.vue',
    './app.vue',
    './plugins/**/*.{js,ts}',
    './nuxt.config.{js,ts}',
  ],
  theme: {
    extend: {
         screens: {
        // keep Tailwind defaults: sm(640) md(768) lg(1024) xl(1280) 2xl(1536)
        'xl-1336': '1336px',
        'xl-1440': '1440px',
        'xl-1660': '1660px',
        '3xl': '1920px',
      },
      fontFamily: {
        satoshi: ['Satoshi', 'sans-serif'],
      },
      letterSpacing: {
        tightest: '-0.17px',
      },
      lineHeight: {
        snugger: '18px',
      },
      fontSize: {
        baseCustom: ['16px', {
          lineHeight: '18px',
          letterSpacing: '-0.17px',
        }],
      },
    },
  },
  plugins: [],
}

export default config
