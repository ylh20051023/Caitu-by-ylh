import { ref } from 'vue'
import { supabase } from '@/config/supabase'
import { useAuthStore } from '@/stores/auth'
import type { RegisterForm, User, Admin } from '@/types'

export function useAuth() {
  const authStore = useAuthStore()
  const loading = ref(false)

  async function register(form: RegisterForm) {
    loading.value = true
    try {
      const { data, error } = await supabase.auth.signUp({
        email: form.email,
        password: form.password,
      })
      if (error) throw error

      if (data.user) {
        const { error: dbError } = await supabase.from('users').insert({
          id: data.user.id,
          email: form.email,
          username: form.username,
          school: form.school,
          major: form.major,
          grade: form.grade,
          plan: form.plan,
        })
        if (dbError) throw dbError

        const user: User = {
          id: data.user.id,
          email: form.email,
          username: form.username,
          school: form.school,
          major: form.major,
          grade: form.grade,
          plan: form.plan,
          created_at: new Date().toISOString(),
        }
        authStore.setUser(user)
        await checkAdmin()
      }
    } finally {
      loading.value = false
    }
  }

  async function login(email: string, password: string) {
    loading.value = true
    try {
      const { data, error } = await supabase.auth.signInWithPassword({ email, password })
      if (error) throw error

      if (data.user) {
        const { data: userData, error: dbError } = await supabase
          .from('users')
          .select('*')
          .eq('id', data.user.id)
          .single()
        if (dbError) throw dbError
        authStore.setUser(userData as User)
        await checkAdmin()
      }
    } finally {
      loading.value = false
    }
  }

  async function logout() {
    const { error } = await supabase.auth.signOut()
    if (error) throw error
    authStore.clearAuth()
  }

  async function checkAdmin() {
    const { data: { user: authUser } } = await supabase.auth.getUser()
    if (!authUser) {
      authStore.setAdmin(null)
      return
    }

    const { data: adminData } = await supabase
      .from('admins')
      .select('*')
      .eq('id', authUser.id)
      .eq('status', 'active')
      .single()

    authStore.setAdmin(adminData as Admin | null)
  }

  async function initAuth() {
    authStore.setLoading(true)
    try {
      const { data: { session } } = await supabase.auth.getSession()
      if (session?.user) {
        const { data: userData } = await supabase
          .from('users')
          .select('*')
          .eq('id', session.user.id)
          .single()
        if (userData) authStore.setUser(userData as User)
        await checkAdmin()
      }
    } finally {
      authStore.setLoading(false)
    }
  }

  // 监听认证状态变化
  supabase.auth.onAuthStateChange(async (event, session) => {
    if (event === 'SIGNED_IN' && session?.user) {
      const { data: userData } = await supabase
        .from('users')
        .select('*')
        .eq('id', session.user.id)
        .single()
      if (userData) authStore.setUser(userData as User)
      await checkAdmin()
    } else if (event === 'SIGNED_OUT') {
      authStore.clearAuth()
    }
  })

  return {
    user: authStore.user,
    isAdmin: authStore.isAdmin,
    adminInfo: authStore.adminInfo,
    loading,
    register,
    login,
    logout,
    checkAdmin,
    initAuth,
  }
}
