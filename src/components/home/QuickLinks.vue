<template>
  <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
    <router-link v-for="link in links" :key="link.to" :to="link.to" class="no-underline">
      <n-card hoverable class="text-center cursor-pointer transition-transform hover:-translate-y-1">
        <div class="text-3xl mb-2">{{ link.emoji }}</div>
        <div class="font-medium text-text">{{ link.label }}</div>
        <div class="text-text-secondary text-xs mt-1">{{ link.desc }}</div>
      </n-card>
    </router-link>
  </div>
</template>

<script setup lang="ts">
import { NCard } from 'naive-ui'

const links = [
  { to: '/internships', emoji: '💼', label: '实习广场', desc: '浏览最新实习岗位' },
  { to: '/certificates', emoji: '📜', label: '证书查询', desc: '14个财会证书详解' },
  { to: '/news', emoji: '📰', label: '行业资讯', desc: '财会行业动态' },
  { to: '/post-job', emoji: '✍️', label: '发布实习', desc: '分享实习信息' },
]
</script>
