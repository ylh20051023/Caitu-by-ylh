import { ref, computed } from 'vue'
import { supabase } from '@/config/supabase'
import { useDataStore } from '@/stores/data'
import type { User } from '@/types'

export function useUsers() {
  const dataStore = useDataStore()
  const loading = ref(false)

  const users = computed(() => dataStore.users)

  async function fetchUsers() {
    loading.value = true
    dataStore.setLoadingFlag('users', true)
    try {
      const { data, error } = await supabase
        .from('users')
        .select('*')
      if (error) throw error
      dataStore.setUsers((data ?? []) as User[])
    } finally {
      loading.value = false
      dataStore.setLoadingFlag('users', false)
    }
  }

  return { users, loading, fetchUsers }
}
