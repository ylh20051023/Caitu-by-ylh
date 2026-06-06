import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { User, Admin } from '@/types'

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const isAdmin = ref(false)
  const adminInfo = ref<Admin | null>(null)
  const loading = ref(true)

  function setUser(u: User | null) {
    user.value = u
  }

  function setAdmin(admin: Admin | null) {
    isAdmin.value = !!admin && admin.status === 'active'
    adminInfo.value = admin
  }

  function setLoading(v: boolean) {
    loading.value = v
  }

  function clearAuth() {
    user.value = null
    isAdmin.value = false
    adminInfo.value = null
    loading.value = false
  }

  return { user, isAdmin, adminInfo, loading, setUser, setAdmin, setLoading, clearAuth }
})
