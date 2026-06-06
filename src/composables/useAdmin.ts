import { computed } from 'vue'
import { useAuthStore } from '@/stores/auth'

export function useAdmin() {
  const authStore = useAuthStore()

  const isAdmin = computed(() => authStore.isAdmin)
  const isSuperAdmin = computed(() => authStore.adminInfo?.role === 'super')
  const permissions = computed(() => authStore.adminInfo?.permissions ?? {})

  function hasPermission(module: string): boolean {
    if (isSuperAdmin.value) return true
    return permissions.value[module] === true
  }

  return { isAdmin, isSuperAdmin, permissions, hasPermission }
}
