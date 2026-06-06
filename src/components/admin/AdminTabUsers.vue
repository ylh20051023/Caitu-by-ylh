<template>
  <div>
    <h2 class="text-lg font-bold mb-4">用户管理</h2>
    <n-data-table :columns="columns" :data="users" :loading="loading" :pagination="{ pageSize: 10 }" />
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useMessage } from 'naive-ui'
import { NDataTable } from 'naive-ui'
import type { DataTableColumns } from 'naive-ui/es/data-table'
import { supabase } from '@/config/supabase'
import { useAdminStore } from '@/stores/admin'
import type { User } from '@/types'

const message = useMessage()
const adminStore = useAdminStore()
const users = adminStore.users
const loading = adminStore.loading

const columns: DataTableColumns<User> = [
  { title: '用户名', key: 'username', width: 120 },
  { title: '邮箱', key: 'email', width: 200 },
  { title: '学校', key: 'school', width: 150 },
  { title: '专业', key: 'major', width: 120 },
  { title: '年级', key: 'grade', width: 80 },
  { title: '毕业打算', key: 'plan', width: 100 },
  { title: '注册时间', key: 'created_at', width: 160 },
]

onMounted(async () => {
  try {
    const { data, error } = await supabase.from('users').select('*').order('created_at', { ascending: false })
    if (error) throw error
    adminStore.setUsers(data as User[])
  } catch (err: unknown) {
    if (err instanceof Error) message.error(err.message)
  }
})
</script>
