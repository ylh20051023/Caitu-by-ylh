import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { Submission, Admin, User } from '@/types'

export const useAdminStore = defineStore('admin', () => {
  const submissions = ref<Submission[]>([])
  const admins = ref<Admin[]>([])
  const users = ref<User[]>([])
  const loading = ref(false)

  function setSubmissions(data: Submission[]) { submissions.value = data }
  function addSubmission(s: Submission) { submissions.value.unshift(s) }
  function updateSubmission(id: number, data: Partial<Submission>) {
    const idx = submissions.value.findIndex(s => s.id === id)
    if (idx !== -1) submissions.value[idx] = { ...submissions.value[idx], ...data }
  }

  function setAdmins(data: Admin[]) { admins.value = data }
  function addAdmin(a: Admin) { admins.value.push(a) }
  function updateAdmin(id: string, data: Partial<Admin>) {
    const idx = admins.value.findIndex(a => a.id === id)
    if (idx !== -1) admins.value[idx] = { ...admins.value[idx], ...data }
  }
  function removeAdmin(id: string) { admins.value = admins.value.filter(a => a.id !== id) }

  function setUsers(data: User[]) { users.value = data }

  function setLoading(v: boolean) { loading.value = v }

  return {
    submissions, admins, users, loading,
    setSubmissions, addSubmission, updateSubmission,
    setAdmins, addAdmin, updateAdmin, removeAdmin,
    setUsers, setLoading,
  }
})
