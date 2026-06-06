<template>
  <div class="container-content py-8">
    <LoadingSpinner v-if="loading" />
    <template v-else-if="job">
      <n-button text @click="$router.back()">← 返回实习广场</n-button>
      <div class="mt-4">
        <InternshipDetail :job="job" />
      </div>
    </template>
    <n-empty v-else description="岗位不存在" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useJobs } from '@/composables/useJobs'
import { NButton, NEmpty } from 'naive-ui'
import InternshipDetail from '@/components/internship/InternshipDetail.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'
import type { Job } from '@/types'

const route = useRoute()
const { fetchJobById } = useJobs()
const job = ref<Job | null>(null)
const loading = ref(true)

onMounted(async () => {
  try {
    const id = Number(route.params.id)
    job.value = await fetchJobById(id)
  } finally {
    loading.value = false
  }
})
</script>
