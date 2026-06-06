import { ref, computed } from 'vue'
import { supabase } from '@/config/supabase'
import { useDataStore } from '@/stores/data'
import type { Career } from '@/types'

export function useCareers() {
  const dataStore = useDataStore()
  const loading = ref(false)

  const careers = computed(() => dataStore.careers)

  async function fetchCareers() {
    loading.value = true
    dataStore.setLoadingFlag('careers', true)
    try {
      const { data, error } = await supabase
        .from('careers')
        .select('*')
        .order('id', { ascending: true })
      if (error) throw error
      dataStore.setCareers(data as Career[])
    } finally {
      loading.value = false
      dataStore.setLoadingFlag('careers', false)
    }
  }

  async function createCareer(item: Omit<Career, 'id'>) {
    const { data, error } = await supabase
      .from('careers')
      .insert(item)
      .select()
      .single()
    if (error) throw error
    if (data) dataStore.setCareers([...dataStore.careers, data as Career])
    return data
  }

  async function updateCareer(id: number, data: Partial<Career>) {
    const { data: updated, error } = await supabase
      .from('careers')
      .update(data)
      .eq('id', id)
      .select()
      .single()
    if (error) throw error
    if (updated) dataStore.updateCareer(id, updated as Career)
    return updated
  }

  async function deleteCareer(id: number) {
    const { error } = await supabase.from('careers').delete().eq('id', id)
    if (error) throw error
    dataStore.removeCareer(id)
  }

  return { careers, loading, fetchCareers, createCareer, updateCareer, deleteCareer }
}
