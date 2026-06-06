<template>
  <div class="container-content py-8 max-w-2xl mx-auto">
    <h1 class="text-2xl font-bold text-text mb-6">✍️ 发布实习</h1>
    <n-card>
      <SubmissionForm @success="handleSuccess" />
    </n-card>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import { NCard } from 'naive-ui'
import SubmissionForm from '@/components/submission/SubmissionForm.vue'

const router = useRouter()

function handleSuccess() {
  router.push('/internships')
}
</script>
