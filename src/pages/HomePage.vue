<template>
  <div>
    <HeroSection />
    <div class="container-content py-10 space-y-12">
      <!-- 职业方向 -->
      <section id="careers">
        <div class="mb-2">
          <h2 class="text-xl font-bold text-text">🧭 财会专业 ≠ 只能算账</h2>
        </div>
        <p class="text-sm text-text-secondary mb-4 max-w-2xl">
          很多财会同学以为毕业只能做"会计"，其实你的专业背景在很多领域都极具竞争力。点击卡片，了解每个方向在做什么、需要什么能力、实习怎么找。
        </p>
        <LoadingSpinner v-if="dataStore.loading.careers" />
        <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <CareerCard v-for="career in dataStore.careers" :key="career.id" :career="career" />
        </div>
      </section>

      <!-- 快速入口 -->
      <section>
        <h2 class="text-xl font-bold text-text mb-4">🚀 快速入口</h2>
        <QuickLinks />
      </section>

      <!-- 热门实习 -->
      <section>
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-xl font-bold text-text">🔥 热门实习</h2>
          <router-link to="/internships" class="text-primary text-sm">查看全部 →</router-link>
        </div>
        <LoadingSpinner v-if="dataStore.loading.jobs" />
        <HotInternships v-else :jobs="featuredJobs" />
      </section>

      <!-- 数据看板 -->
      <section>
        <h2 class="text-xl font-bold text-text mb-4">📊 平台数据</h2>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
          <StatCard emoji="💼" :value="dataStore.jobs.length" label="实习岗位" />
          <StatCard emoji="🧭" :value="dataStore.careers.length" label="职业方向" />
          <StatCard emoji="📜" :value="dataStore.certs.length" label="财会证书" />
          <StatCard emoji="📰" :value="dataStore.news.length" label="行业资讯" />
        </div>
      </section>

      <!-- 高校 & 专业排行 -->
      <section>
        <LoadingSpinner v-if="dataStore.loading.users" />
        <RankingBoard v-else :users="dataStore.users" />
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useDataStore } from '@/stores/data'
import { useAuth } from '@/composables/useAuth'
import { useJobs } from '@/composables/useJobs'
import { useCareers } from '@/composables/useCareers'
import { useCerts } from '@/composables/useCerts'
import { useNews } from '@/composables/useNews'
import { useUsers } from '@/composables/useUsers'
import HeroSection from '@/components/common/HeroSection.vue'
import QuickLinks from '@/components/home/QuickLinks.vue'
import StatCard from '@/components/common/StatCard.vue'
import CareerCard from '@/components/home/CareerCard.vue'
import HotInternships from '@/components/home/HotInternships.vue'
import RankingBoard from '@/components/home/RankingBoard.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'

const dataStore = useDataStore()
const { initAuth } = useAuth()
const { fetchJobs } = useJobs()
const { fetchCareers } = useCareers()
const { fetchCerts } = useCerts()
const { fetchNews } = useNews()
const { fetchUsers } = useUsers()

const featuredJobs = computed(() =>
  dataStore.jobs.filter(j => j.featured && j.status === 'active').slice(0, 5)
)

onMounted(async () => {
  await Promise.all([
    initAuth(),
    fetchJobs(),
    fetchCareers(),
    fetchCerts(),
    fetchNews(),
    fetchUsers(),
  ])
})
</script>
