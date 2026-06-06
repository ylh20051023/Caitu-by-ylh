<template>
  <div class="container-content py-8">
    <h1 class="text-2xl font-bold text-text mb-6">📰 行业资讯</h1>
    <NewsFilter v-model="filter.category" :categories="categories" />
    <LoadingSpinner v-if="loading" />
    <div v-else-if="filteredNews.length === 0" class="py-12">
      <n-empty description="暂无资讯" />
    </div>
    <div v-else class="space-y-4 mt-6">
      <NewsCard v-for="item in filteredNews" :key="item.id" :item="item" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useNews } from '@/composables/useNews'
import { NEmpty } from 'naive-ui'
import NewsFilter from '@/components/news/NewsFilter.vue'
import NewsCard from '@/components/news/NewsCard.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'

const { filteredNews, filter, loading, categories, fetchNews } = useNews()

onMounted(() => {
  if (filteredNews.value.length === 0) fetchNews()
})
</script>
