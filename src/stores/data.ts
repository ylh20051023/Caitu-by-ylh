import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { Job, News, Career, Cert, Setting, User, ResumeTip } from '@/types'

export const useDataStore = defineStore('data', () => {
  const jobs = ref<Job[]>([])
  const news = ref<News[]>([])
  const careers = ref<Career[]>([])
  const certs = ref<Cert[]>([])
  const users = ref<User[]>([])
  const resumeTips = ref<ResumeTip[]>([])
  const settings = ref<Setting[]>([])
  const loading = ref({
    jobs: false,
    news: false,
    careers: false,
    certs: false,
    users: false,
  })

  function setJobs(data: Job[]) { jobs.value = data }
  function addJob(job: Job) { jobs.value.unshift(job) }
  function updateJob(id: number, data: Partial<Job>) {
    const idx = jobs.value.findIndex(j => j.id === id)
    if (idx !== -1) jobs.value[idx] = { ...jobs.value[idx], ...data }
  }
  function removeJob(id: number) { jobs.value = jobs.value.filter(j => j.id !== id) }

  function setNews(data: News[]) { news.value = data }
  function addNews(item: News) { news.value.unshift(item) }
  function updateNews(id: number, data: Partial<News>) {
    const idx = news.value.findIndex(n => n.id === id)
    if (idx !== -1) news.value[idx] = { ...news.value[idx], ...data }
  }
  function removeNews(id: number) { news.value = news.value.filter(n => n.id !== id) }

  function setCareers(data: Career[]) { careers.value = data }
  function updateCareer(id: number, data: Partial<Career>) {
    const idx = careers.value.findIndex(c => c.id === id)
    if (idx !== -1) careers.value[idx] = { ...careers.value[idx], ...data }
  }
  function removeCareer(id: number) { careers.value = careers.value.filter(c => c.id !== id) }

  function setCerts(data: Cert[]) { certs.value = data }
  function updateCert(id: number, data: Partial<Cert>) {
    const idx = certs.value.findIndex(c => c.id === id)
    if (idx !== -1) certs.value[idx] = { ...certs.value[idx], ...data }
  }
  function removeCert(id: number) { certs.value = certs.value.filter(c => c.id !== id) }

  function setSettings(data: Setting[]) { settings.value = data }
  function getSetting(key: string): string | undefined {
    return settings.value.find(s => s.key === key)?.value
  }

  function setUsers(data: User[]) { users.value = data }
  function setResumeTips(data: ResumeTip[]) { resumeTips.value = data }

  function setLoadingFlag(key: keyof typeof loading.value, v: boolean) {
    loading.value[key] = v
  }

  return {
    jobs, news, careers, certs, users, resumeTips, settings, loading,
    setJobs, addJob, updateJob, removeJob,
    setNews, addNews, updateNews, removeNews,
    setCareers, updateCareer, removeCareer,
    setCerts, updateCert, removeCert,
    setUsers, setResumeTips,
    setSettings, getSetting,
    setLoadingFlag,
  }
})
