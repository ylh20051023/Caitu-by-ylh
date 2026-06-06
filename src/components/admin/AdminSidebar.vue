<template>
  <aside class="w-52 bg-white h-screen sticky top-0 border-r p-4">
    <div class="flex items-center gap-2 mb-6">
      <span class="text-xl">🧭</span>
      <span class="font-bold text-primary">后台管理</span>
    </div>
    <n-menu :value="activeTab" :options="menuOptions" @update:value="$emit('update:activeTab', $event)" />
    <div class="mt-8">
      <n-button text @click="$router.push('/')">← 返回首页</n-button>
    </div>
  </aside>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useAdmin } from '@/composables/useAdmin'
import { NMenu, NButton } from 'naive-ui'
import type { MenuOption } from 'naive-ui'

defineProps<{ activeTab: string }>()
defineEmits<{ 'update:activeTab': [value: string] }>()

const { isSuperAdmin } = useAdmin()

const menuOptions = computed<MenuOption[]>(() => {
  const items: MenuOption[] = [
    { label: '职位管理', key: 'jobs' },
    { label: '资讯管理', key: 'news' },
    { label: '职业方向', key: 'careers' },
    { label: '证书管理', key: 'certs' },
    { label: '审批管理', key: 'submissions' },
    { label: '用户管理', key: 'users' },
  ]
  if (isSuperAdmin.value) {
    items.push({ label: '管理员管理', key: 'admins' })
  }
  return items
})
</script>
