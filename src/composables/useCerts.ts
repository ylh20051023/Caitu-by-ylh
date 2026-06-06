import { ref, computed } from 'vue'
import { supabase } from '@/config/supabase'
import { useDataStore } from '@/stores/data'
import type { Cert } from '@/types'

export function useCerts() {
  const dataStore = useDataStore()
  const loading = ref(false)
  const currentTab = ref('全部')

  const tabs = ['全部', '在校可考', '毕业可考', '需工作年限']

  const filteredCerts = computed(() => {
    if (currentTab.value === '全部') return dataStore.certs
    return dataStore.certs.filter(c => c.type === currentTab.value)
  })

  async function fetchCerts() {
    loading.value = true
    dataStore.setLoadingFlag('certs', true)
    try {
      const { data, error } = await supabase
        .from('certs')
        .select('*')
        .order('id', { ascending: true })
      if (error) throw error
      dataStore.setCerts(data as Cert[])
    } finally {
      loading.value = false
      dataStore.setLoadingFlag('certs', false)
    }
  }

  function setTab(tab: string) {
    currentTab.value = tab
  }

  async function createCert(item: Omit<Cert, 'id'>) {
    const { data, error } = await supabase
      .from('certs')
      .insert(item)
      .select()
      .single()
    if (error) throw error
    if (data) dataStore.setCerts([...dataStore.certs, data as Cert])
    return data
  }

  async function updateCert(id: number, data: Partial<Cert>) {
    const { data: updated, error } = await supabase
      .from('certs')
      .update(data)
      .eq('id', id)
      .select()
      .single()
    if (error) throw error
    if (updated) dataStore.updateCert(id, updated as Cert)
    return updated
  }

  async function deleteCert(id: number) {
    const { error } = await supabase.from('certs').delete().eq('id', id)
    if (error) throw error
    dataStore.removeCert(id)
  }

  return { certs: computed(() => dataStore.certs), currentTab, tabs, filteredCerts, loading, fetchCerts, setTab, createCert, updateCert, deleteCert }
}
