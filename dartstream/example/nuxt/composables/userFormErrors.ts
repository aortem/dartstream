// composables/useFormErrors.ts
import { ref } from 'vue'

export default function useFormErrors<T extends Record<string, any>>(fields: (keyof T)[]) {
  const errors = ref<Partial<Record<keyof T, string>>>({})

  const validate = (formData: T): boolean => {
    const newErrors: Partial<Record<keyof T, string>> = {}

    fields.forEach((field) => {
      const value = formData[field]
      if (!value || value.toString().trim() === '') {
        newErrors[field] = `${String(field)} is required`
      }
    })

    errors.value = newErrors
    return Object.keys(newErrors).length === 0
  }

  const setFieldError = (field: keyof T, message: string) => {
    errors.value[field] = message
  }

  const clearErrors = () => {
    errors.value = {}
  }

  return {
    errors,
    validate,
    setFieldError,
    clearErrors,
  }
}
