<template>
  <div>
    <div class="flex justify-between items-center mb-4">
      <h2 class="text-lg font-bold">管理员管理</h2>
      <n-button type="primary" @click="showModal = true">新增管理员</n-button>
    </div>
    <n-data-table :columns="columns" :data="admins" :loading="loading" :pagination="{ pageSize: 10 }" />
    <n-modal v-model:show="showModal" preset="dialog" title="新增管理员" style="width: 500px">
      <n-form :model="form" label-placement="left" label-width="80">
        <n-form-item label="邮箱"><n-input v-model:value="form.email" /></n-form-item>
        <n-form-item label="账号名"><n-input v-model:value="form.account" /></n-form-item>
        <n-form-item label="显示名"><n-input v-model:value="form.name" /></n-form-item>
        <n-form-item label="角色">
          <n-select v-model:value="form.role" :options="roleOptions" />
        </n-form-item>
        <n-form-item label="身份标识"><n-input v-model:value="form.identity" /></n-form-item>
        <n-form-item label="电话"><n-input v-model:value="form.phone" /></n-form-item>
        <n-form-item label="备注"><n-input v-model:value="form.note" /></n-form-item>
      </n-form>
      <template #action>
        <n-button @click="showModal = false">取消</n-button>
        <n-button type="primary" :loading="saving" @click="handleSave">保存</n-button>
      </template>
    </n-modal>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, h } from 'vue'
import { useMessage, type DataTableColumns } from 'naive-ui'
import { NDataTable, NButton, NModal, NForm, NFormItem, NInput, NSelect, NTag, NPopconfirm } from 'naive-ui'
import { supabase } from '@/config/supabase'
import { useAdminStore } from '@/stores/admin'
import type { Admin } from '@/types'

const message = useMessage()
const adminStore = useAdminStore()
const admins = adminStore.admins
const loading = adminStore.loading
const showModal = ref(false)
const saving = ref(false)
const roleOptions = [
  { label: '超级管理员', value: 'super' },
  { label: '普通管理员', value: 'admin' },
]
const defaultForm = { email: '', account: '', name: '', role: 'admin' as const, identity: '', phone: '', note: '' }
const form = reactive({ ...defaultForm })

const columns: DataTableColumns<Admin> = [
  { title: '账号', key: 'account', width: 100 },
  { title: '显示名', key: 'name', width: 100 },
  { title: '邮箱', key: 'email', width: 180 },
  { title: '角色', key: 'role', width: 100, render: (row) => h(NTag, { type: row.role === 'super' ? 'error' : 'info', size: 'small' }, () => row.role === 'super' ? '超管' : '管理员') },
  { title: '状态', key: 'status', width: 80 },
  {
    title: '操作', key: 'actions', width: 100,
    render: (row) => row.role !== 'super'
      ? h(NPopconfirm, { onPositiveClick: () => handleDelete(row.id) }, { trigger: () => h(NButton, { text: true, type: 'error' }, () => '删除'), default: () => '确认删除？' })
      : null,
  },
]

async function handleSave() {
  saving.value = true
  try {
    const { data, error } = await supabase.from('admins').insert({ ...form, status: 'active', permissions: {} }).select().single()
    if (error) throw error
    if (data) adminStore.addAdmin(data as Admin)
    message.success('创建成功（注意：需先在 Supabase Auth 中为此邮箱创建账户）')
    showModal.value = false
    Object.assign(form, { ...defaultForm })
  } catch (err: unknown) {
    if (err instanceof Error) message.error(err.message)
  } finally {
    saving.value = false
  }
}

async function handleDelete(id: string) {
  try {
    const { error } = await supabase.from('admins').delete().eq('id', id)
    if (error) throw error
    adminStore.removeAdmin(id)
    message.success('删除成功')
  } catch (err: unknown) {
    if (err instanceof Error) message.error(err.message)
  }
}

onMounted(async () => {
  try {
    const { data, error } = await supabase.from('admins').select('*').order('created_at', { ascending: true })
    if (error) throw error
    adminStore.setAdmins(data as Admin[])
  } catch (err: unknown) {
    if (err instanceof Error) message.error(err.message)
  }
})
</script>
