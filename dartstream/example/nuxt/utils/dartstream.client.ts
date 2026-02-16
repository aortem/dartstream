export const dartstreamFetch = $fetch.create({
  baseURL: 'http://localhost:8080',
  headers: {
    'Content-Type': 'application/json',
  },
  credentials: 'include',
})
