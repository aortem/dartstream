export const useLoading = () => {
  const isLoading = useState('isLoading', () => false)

  const start = () => (isLoading.value = true)
  const stop = () => (isLoading.value = false)

  return { isLoading, start, stop }
}