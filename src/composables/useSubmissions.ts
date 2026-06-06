import { ref } from 'vue'
import { supabase } from '@/config/supabase'
import { useAdminStore } from '@/stores/admin'
import type { Submission } from '@/types'

export function useSubmissions() {
  const adminStore = useAdminStore()
  const loading = ref(false)

  async function submitJob(form: Omit<Submission, 'id' | 'status' | 'review_note' | 'created_at' | 'submitted_at'>) {
    loading.value = true
    try {
      const { data, error } = await supabase
        .from('submissions')
        .insert({ ...form, status: 'pending', submitted_at: new Date().toISOString() })
        .select()
        .single()
      if (error) throw error
      if (data) adminStore.addSubmission(data as Submission)
      return data
    } finally {
      loading.value = false
    }
  }

  async function fetchSubmissions() {
    loading.value = true
    adminStore.setLoading(true)
    try {
      const { data, error } = await supabase
        .from('submissions')
        .select('*')
        .order('created_at', { ascending: false })
      if (error) throw error
      adminStore.setSubmissions(data as Submission[])
    } finally {
      loading.value = false
      adminStore.setLoading(false)
    }
  }

  async function approveSubmission(id: number) {
    loading.value = true
    try {
      // 先获取投稿详情
      const { data: submission, error: fetchError } = await supabase
        .from('submissions')
        .select('*')
        .eq('id', id)
        .single()
      if (fetchError) throw fetchError

      // 插入到 jobs 表
      const { error: insertError } = await supabase.from('jobs').insert({
        title: submission.position,
        company: submission.company,
        city: submission.city,
        type: submission.type,
        salary: submission.salary,
        deadline: submission.deadline,
        description: submission.description,
        apply_url: submission.apply_url,
        apply_email: submission.apply_email,
        status: 'active',
        featured: false,
        province: '',
      })
      if (insertError) throw insertError

      // 更新投稿状态
      const { data: updated, error: updateError } = await supabase
        .from('submissions')
        .update({ status: 'approved' })
        .eq('id', id)
        .select()
        .single()
      if (updateError) throw updateError
      if (updated) adminStore.updateSubmission(id, updated as Submission)
    } finally {
      loading.value = false
    }
  }

  async function rejectSubmission(id: number, note: string) {
    loading.value = true
    try {
      const { data, error } = await supabase
        .from('submissions')
        .update({ status: 'rejected', review_note: note })
        .eq('id', id)
        .select()
        .single()
      if (error) throw error
      if (data) adminStore.updateSubmission(id, data as Submission)
    } finally {
      loading.value = false
    }
  }

  return {
    submissions: adminStore.submissions,
    loading,
    submitJob,
    fetchSubmissions,
    approveSubmission,
    rejectSubmission,
  }
}
