import { ref, computed } from 'vue'
import { supabase } from '@/config/supabase'
import { useDataStore } from '@/stores/data'
import type { Job, JobFilter } from '@/types'

export function useJobs() {
  const dataStore = useDataStore()
  const loading = ref(false)
  const filter = ref<JobFilter>({ type: '', city: '', keyword: '' })

  const filteredJobs = computed(() => {
    let result = dataStore.jobs.filter(j => j.status === 'active')

    if (filter.value.type) {
      result = result.filter(j => j.type === filter.value.type)
    }
    if (filter.value.city) {
      result = result.filter(j => j.city === filter.value.city)
    }
    if (filter.value.keyword) {
      const kw = filter.value.keyword.toLowerCase()
      result = result.filter(j =>
        j.title.toLowerCase().includes(kw) ||
        j.company.toLowerCase().includes(kw) ||
        j.description.toLowerCase().includes(kw)
      )
    }
    return result
  })

  const cities = computed(() => {
    const set = new Set(dataStore.jobs.filter(j => j.status === 'active').map(j => j.city))
    return Array.from(set).sort()
  })

  const types = computed(() => {
    const set = new Set(dataStore.jobs.filter(j => j.status === 'active').map(j => j.type))
    return Array.from(set).sort()
  })

  async function fetchJobs() {
    loading.value = true
    dataStore.setLoadingFlag('jobs', true)
    try {
      const { data, error } = await supabase
        .from('jobs')
        .select('*')
        .order('created_at', { ascending: false })
      if (error) throw error
      dataStore.setJobs(data as Job[])
    } finally {
      loading.value = false
      dataStore.setLoadingFlag('jobs', false)
    }
  }

  async function fetchJobById(id: number): Promise<Job | null> {
    const { data, error } = await supabase
      .from('jobs')
      .select('*')
      .eq('id', id)
      .single()
    if (error) throw error
    return data as Job
  }

  function setFilter(newFilter: Partial<JobFilter>) {
    filter.value = { ...filter.value, ...newFilter }
  }

  async function createJob(job: Omit<Job, 'id' | 'created_at'>) {
    const { data, error } = await supabase
      .from('jobs')
      .insert(job)
      .select()
      .single()
    if (error) throw error
    if (data) dataStore.addJob(data as Job)
    return data
  }

  async function updateJob(id: number, data: Partial<Job>) {
    const { data: updated, error } = await supabase
      .from('jobs')
      .update(data)
      .eq('id', id)
      .select()
      .single()
    if (error) throw error
    if (updated) dataStore.updateJob(id, updated as Job)
    return updated
  }

  async function deleteJob(id: number) {
    const { error } = await supabase.from('jobs').delete().eq('id', id)
    if (error) throw error
    dataStore.removeJob(id)
  }

  return {
    jobs: computed(() => dataStore.jobs),
    filteredJobs,
    filter,
    loading,
    cities,
    types,
    fetchJobs,
    fetchJobById,
    setFilter,
    createJob,
    updateJob,
    deleteJob,
  }
}
