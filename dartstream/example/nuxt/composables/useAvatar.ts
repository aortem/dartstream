// composables/useAvatar.ts
import { useState } from "nuxt/app";

export function useAvatar() {
  const avatarUrl = useState<string | null>("avatar_url", () => null);

  async function refreshAvatar(userId: string, tenantId: string) {
    const { $api } = useNuxtApp();

    try {
      const blob: Blob = await $api(`/api/users/${userId}/avatar`, {
        method: "GET",
        headers: { "X-Tenant-ID": tenantId },
        parseResponse: false,
      });

      if (blob instanceof Blob && blob.size > 0) {
        avatarUrl.value = URL.createObjectURL(blob);
      } else {
        avatarUrl.value = null;
      }
    } catch (error: any) {
      avatarUrl.value = null;
    }
  }

  return { avatarUrl, refreshAvatar };
}
