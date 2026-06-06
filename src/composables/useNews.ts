import { ref, computed } from 'vue'
import { supabase } from '@/config/supabase'
import { useDataStore } from '@/stores/data'
import type { News, NewsFilter } from '@/types'

export function useNews() {
  const dataStore = useDataStore()
  const loading = ref(false)
  const filter = ref<NewsFilter>({ category: '' })

  const filteredNews = computed(() => {
    if (!filter.value.category) return dataStore.news
    return dataStore.news.filter(n => n.category === filter.value.category)
  })

  const categories = computed(() => {
    const set = new Set(dataStore.news.map(n => n.category))
    return Array.from(set).sort()
  })

  async function fetchNews() {
    loading.value = true
    dataStore.setLoadingFlag('news', true)
    try {
      const { data, error } = await supabase
        .from('news')
        .select('*')
        .order('created_at', { ascending: false })
      if (error) throw error
      dataStore.setNews(data as News[])
    } finally {
      loading.value = false
      dataStore.setLoadingFlag('news', false)
    }
  }

  async function fetchNewsById(id: number): Promise<News | null> {
    const { data, error } = await supabase
      .from('news')
      .select('*')
      .eq('id', id)
      .single()
    if (error) throw error
    return data as News
  }

  function setFilter(newFilter: Partial<NewsFilter>) {
    filter.value = { ...filter.value, ...newFilter }
  }

  async function createNews(item: Omit<News, 'id' | 'created_at'>) {
    const { data, error } = await supabase
      .from('news')
      .insert(item)
      .select()
      .single()
    if (error) throw error
    if (data) dataStore.addNews(data as News)
    return data
  }

  async function updateNews(id: number, data: Partial<News>) {
    const { data: updated, error } = await supabase
      .from('news')
      .update(data)
      .eq('id', id)
      .select()
      .single()
    if (error) throw error
    if (updated) dataStore.updateNews(id, updated as News)
    return updated
  }

  async function deleteNews(id: number) {
    const { error } = await supabase.from('news').delete().eq('id', id)
    if (error) throw error
    dataStore.removeNews(id)
  }

  return {
    newsList: computed(() => dataStore.news),
    filteredNews,
    filter,
    loading,
    categories,
    fetchNews,
    fetchNewsById,
    setFilter,
    createNews,
    updateNews,
    deleteNews,
  }
}
