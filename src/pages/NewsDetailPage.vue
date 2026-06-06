<template>
  <div class="container-content py-8">
    <LoadingSpinner v-if="loading" />
    <template v-else-if="item">
      <n-button text @click="$router.back()">← 返回资讯列表</n-button>
      <article class="mt-4 max-w-3xl mx-auto">
        <div class="flex items-center gap-2 mb-3">
          <n-tag size="small">{{ item.category }}</n-tag>
          <span class="text-text-secondary text-xs">{{ item.date }}</span>
        </div>
        <h1 class="text-2xl font-bold text-text mb-4">{{ item.title }}</h1>
        <n-divider />
        <div class="prose max-w-none whitespace-pre-line text-text leading-relaxed">
          {{ item.content }}
        </div>
      </article>
    </template>
    <n-empty v-else description="资讯不存在" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useNews } from '@/composables/useNews'
import { NButton, NTag, NDivider, NEmpty } from 'naive-ui'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'
import type { News } from '@/types'

const route = useRoute()
const { fetchNewsById } = useNews()
const item = ref<News | null>(null)
const loading = ref(true)

onMounted(async () => {
  try {
    const id = Number(route.params.id)
    item.value = await fetchNewsById(id)
  } finally {
    loading.value = false
  }
})
</script>
