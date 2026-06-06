import { onUnmounted } from 'vue'
import { supabase } from '@/config/supabase'

export function useRealtime() {
  const channels: ReturnType<typeof supabase.channel>[] = []

  function subscribeToTable(
    table: string,
    event: string = '*',
    callback: (payload: Record<string, unknown>) => void
  ) {
    const channel = supabase
      .channel(`${table}-changes`)
      .on('postgres_changes', { event: event as 'INSERT' | 'UPDATE' | 'DELETE' | '*', schema: 'public', table }, (payload) => {
        callback(payload)
      })
      .subscribe()

    channels.push(channel)
    return channel
  }

  function unsubscribeAll() {
    channels.forEach(channel => {
      supabase.removeChannel(channel)
    })
    channels.length = 0
  }

  onUnmounted(() => {
    unsubscribeAll()
  })

  return { subscribeToTable, unsubscribeAll }
}
