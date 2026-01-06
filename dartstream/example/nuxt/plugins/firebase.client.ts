import { defineNuxtPlugin } from 'nuxt/app'
import { initializeApp } from 'firebase/app'
import { getAuth } from 'firebase/auth'

export default defineNuxtPlugin(() => {
  // Default to dev config
  let firebaseConfig = {
    apiKey: 'AIzaSyB9d9RmiRCu4xs0JIDb7YdJlTH1PNLsf3w',
    authDomain: 'intellitoggle-prod.firebaseapp.com',
    projectId: 'intellitoggle-prod',
    storageBucket: 'intellitoggle-prod.appspot.com',
    messagingSenderId: '811694630640',
    appId: '1:811694630640:web:0f69a7f41f7f2a71950435',
    measurementId: 'G-JEDF6S44SR',
  }

  // Use production keys when running on app.intellitoggle.com
  if (process.client && window.location.hostname === 'app.intellitoggle.com') {
    firebaseConfig = {
   apiKey: "AIzaSyAobzbF40iCnzngKtQlHifNX5CkigHLQt8",
  authDomain: "intellitoggle-prod.firebaseapp.com",
  projectId: "intellitoggle-prod",
  storageBucket: "intellitoggle-prod.firebasestorage.app",
  messagingSenderId: "811694630640",
  appId: "1:811694630640:web:0f69a7f41f7f2a71950435",
  measurementId: "G-JEDF6S44SR"
    }
  }

  const app = initializeApp(firebaseConfig)
  const auth = getAuth(app)

  return {
    provide: {
      firebaseApp: app,
      firebaseAuth: auth,
    },
  }
})
