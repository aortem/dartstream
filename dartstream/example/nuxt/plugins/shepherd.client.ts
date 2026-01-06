import { defineNuxtPlugin } from 'nuxt/app'
import Shepherd from 'shepherd.js'
import 'shepherd.js/dist/css/shepherd.css'

export default defineNuxtPlugin(() => {
  return {
    provide: {
      shepherd: Shepherd
    }
  }
})
