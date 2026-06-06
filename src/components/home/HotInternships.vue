<template>
  <div v-if="jobs.length === 0">
    <n-empty description="暂无热门实习" />
  </div>
  <div v-else class="space-y-3">
    <router-link v-for="job in jobs" :key="job.id" :to="`/internship/${job.id}`" class="no-underline block">
      <n-card hoverable size="small" class="transition-transform hover:-translate-y-0.5">
        <div class="flex items-center justify-between">
          <div>
            <span class="font-medium text-text">{{ job.title }}</span>
            <span class="text-text-secondary ml-2">{{ job.company }}</span>
          </div>
          <div class="flex items-center gap-2">
            <n-tag v-if="job.featured" size="small" type="warning">推荐</n-tag>
            <n-tag size="small">{{ job.city }}</n-tag>
            <span v-if="job.salary" class="text-success text-sm">{{ job.salary }}</span>
          </div>
        </div>
      </n-card>
    </router-link>
  </div>
</template>

<script setup lang="ts">
import { NCard, NTag, NEmpty } from 'naive-ui'
import type { Job } from '@/types'

defineProps<{ jobs: Job[] }>()
</script>
