<template>
  <router-link :to="`/internship/${job.id}`" class="no-underline block">
    <n-card hoverable class="transition-transform hover:-translate-y-1">
      <div class="flex flex-col md:flex-row md:items-center justify-between gap-3">
        <div class="flex-1">
          <div class="flex items-center gap-2 mb-1">
            <h3 class="text-lg font-bold text-text">{{ job.title }}</h3>
            <n-tag v-if="job.featured" size="small" type="warning">推荐</n-tag>
          </div>
          <div class="text-text-secondary text-sm space-x-3">
            <span>{{ job.company }}</span>
            <span>{{ job.city }}</span>
            <span>{{ job.type }}</span>
          </div>
        </div>
        <div class="flex items-center gap-3">
          <span v-if="job.salary" class="text-success font-medium">{{ job.salary }}</span>
          <span v-if="job.deadline" class="text-text-secondary text-xs">截止：{{ job.deadline }}</span>
          <n-button type="primary" size="small">查看详情</n-button>
        </div>
      </div>
    </n-card>
  </router-link>
</template>

<script setup lang="ts">
import { NCard, NTag, NButton } from 'naive-ui'
import type { Job } from '@/types'

defineProps<{ job: Job }>()
</script>
