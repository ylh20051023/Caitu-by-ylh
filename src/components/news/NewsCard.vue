<template>
  <router-link :to="`/news/${item.id}`" class="no-underline block">
    <n-card hoverable class="transition-transform hover:-translate-y-1">
      <div class="flex flex-col md:flex-row gap-3">
        <div class="flex-1">
          <div class="flex items-center gap-2 mb-1">
            <n-tag size="small">{{ item.category }}</n-tag>
            <span class="text-text-secondary text-xs">{{ item.date }}</span>
          </div>
          <h3 class="text-base font-bold text-text mb-1">{{ item.title }}</h3>
          <p class="text-text-secondary text-sm line-clamp-2">{{ item.summary }}</p>
        </div>
      </div>
    </n-card>
  </router-link>
</template>

<script setup lang="ts">
import { NCard, NTag } from 'naive-ui'
import type { News } from '@/types'

defineProps<{ item: News }>()
</script>
