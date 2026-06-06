<template>
  <n-card hoverable class="transition-transform hover:-translate-y-1">
    <div class="flex items-start gap-3">
      <span class="text-2xl">{{ cert.badge || '📜' }}</span>
      <div class="flex-1">
        <h3 class="text-lg font-bold text-text">{{ cert.name }}</h3>
        <div class="flex flex-wrap gap-2 mt-2">
          <n-tag size="small" :type="cert.type === '在校可考' ? 'success' : 'default'">{{ cert.type }}</n-tag>
          <n-tag size="small">难度：{{ cert.difficulty }}</n-tag>
          <n-tag size="small" type="warning">含金量：{{ cert.value }}</n-tag>
        </div>
        <n-collapse class="mt-3">
          <n-collapse-item title="详细信息" name="detail">
            <div class="space-y-2 text-sm">
              <p v-if="cert.cost"><strong>报考费用：</strong>{{ cert.cost }}</p>
              <p v-if="cert.exam_time"><strong>考试时间：</strong>{{ cert.exam_time }}</p>
              <p v-if="cert.signup_time"><strong>报名时间：</strong>{{ cert.signup_time }}</p>
              <p v-if="cert.exam_mode"><strong>考试方式：</strong>{{ cert.exam_mode }}</p>
              <p v-if="cert.pass_rate"><strong>通过率：</strong>{{ cert.pass_rate }}</p>
              <p v-if="cert.suitable"><strong>适合岗位：</strong>{{ cert.suitable }}</p>
              <p v-if="cert.note"><strong>备注：</strong>{{ cert.note }}</p>
              <p v-if="cert.advantage"><strong>优势：</strong>{{ cert.advantage }}</p>
              <p v-if="cert.salary"><strong>薪资关联：</strong>{{ cert.salary }}</p>
            </div>
          </n-collapse-item>
        </n-collapse>
      </div>
    </div>
  </n-card>
</template>

<script setup lang="ts">
import { NCard, NTag, NCollapse, NCollapseItem } from 'naive-ui'
import type { Cert } from '@/types'

defineProps<{ cert: Cert }>()
</script>
