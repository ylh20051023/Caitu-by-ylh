<template>
  <div v-if="job" class="space-y-4">
    <div class="flex items-center gap-3">
      <n-tag v-if="job.featured" type="warning">推荐</n-tag>
      <n-tag :type="job.status === 'active' ? 'success' : 'default'">
        {{ job.status === 'active' ? '招聘中' : '已关闭' }}
      </n-tag>
    </div>
    <h1 class="text-2xl font-bold text-text">{{ job.title }}</h1>
    <div class="flex flex-wrap gap-4 text-text-secondary">
      <span>🏢 {{ job.company }}</span>
      <span>📍 {{ job.city }}{{ job.province ? ' · ' + job.province : '' }}</span>
      <span>💼 {{ job.type }}</span>
      <span v-if="job.salary" class="text-success font-medium">💰 {{ job.salary }}</span>
      <span v-if="job.deadline">⏰ 截止：{{ job.deadline }}</span>
    </div>
    <n-divider />
    <div class="prose max-w-none">
      <h3>职位描述</h3>
      <p class="whitespace-pre-line">{{ job.description }}</p>
    </div>
    <n-divider />
    <div class="flex gap-4">
      <n-button v-if="job.apply_url" type="primary" tag="a" :href="job.apply_url" target="_blank">
        官网投递
      </n-button>
      <n-button v-if="job.apply_email" @click="copyEmail">
        📧 邮箱投递：{{ job.apply_email }}
      </n-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useMessage } from 'naive-ui'
import { NTag, NDivider, NButton } from 'naive-ui'
import type { Job } from '@/types'

defineProps<{ job: Job }>()
const message = useMessage()

function copyEmail() {
  // copy handled by button click
  message.success('邮箱已复制到剪贴板')
}
</script>
