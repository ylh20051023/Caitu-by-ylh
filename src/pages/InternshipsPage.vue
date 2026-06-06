<template>
  <div class="container-content py-8">
    <h1 class="text-2xl font-bold text-text mb-6">💼 实习广场</h1>

    <!-- 筛选栏 -->
    <InternshipFilter :cities="cities" :types="types" @filter="handleFilter" />

    <!-- 岗位列表 -->
    <LoadingSpinner v-if="loading" />
    <div v-else-if="filteredJobs.length === 0" class="py-12">
      <n-empty description="暂无符合条件的实习岗位" />
    </div>
    <div v-else class="space-y-4 mt-6">
      <InternshipCard v-for="job in filteredJobs" :key="job.id" :job="job" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useJobs } from '@/composables/useJobs'
import { NEmpty } from 'naive-ui'
import InternshipFilter from '@/components/internship/InternshipFilter.vue'
import InternshipCard from '@/components/internship/InternshipCard.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'

const { filteredJobs, loading, cities, types, fetchJobs, setFilter } = useJobs()

function handleFilter(filter: { type: string; city: string; keyword: string }) {
  setFilter(filter)
}

onMounted(() => {
  if (filteredJobs.value.length === 0) fetchJobs()
})
</script>
