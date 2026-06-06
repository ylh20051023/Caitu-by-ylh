<template>
  <div>
    <div class="flex justify-between items-center mb-4">
      <h2 class="text-lg font-bold">资讯管理</h2>
      <n-button type="primary" @click="showModal = true">新增资讯</n-button>
    </div>
    <n-data-table :columns="columns" :data="newsList" :loading="loading" :pagination="{ pageSize: 10 }" />
    <n-modal v-model:show="showModal" preset="dialog" :title="editingId ? '编辑资讯' : '新增资讯'" style="width: 600px">
      <n-form :model="form" label-placement="left" label-width="80">
        <n-form-item label="标题"><n-input v-model:value="form.title" /></n-form-item>
        <n-form-item label="分类"><n-input v-model:value="form.category" /></n-form-item>
        <n-form-item label="日期"><n-input v-model:value="form.date" placeholder="如：2026-06-06" /></n-form-item>
        <n-form-item label="摘要"><n-input v-model:value="form.summary" type="textarea" :rows="2" /></n-form-item>
        <n-form-item label="正文"><n-input v-model:value="form.content" type="textarea" :rows="6" /></n-form-item>
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
import { NDataTable, NButton, NModal, NForm, NFormItem, NInput, NPopconfirm } from 'naive-ui'
import { useNews } from '@/composables/useNews'
import type { News } from '@/types'

const message = useMessage()
const { newsList, loading, fetchNews, createNews, updateNews, deleteNews } = useNews()
const showModal = ref(false)
const saving = ref(false)
const editingId = ref<number | null>(null)
const defaultForm = { title: '', category: '', date: '', summary: '', content: '' }
const form = reactive({ ...defaultForm })

const columns: DataTableColumns<News> = [
  { title: '标题', key: 'title', width: 200 },
  { title: '分类', key: 'category', width: 100 },
  { title: '日期', key: 'date', width: 100 },
  {
    title: '操作', key: 'actions', width: 140,
    render: (row) => [
      h(NButton, { text: true, type: 'primary', onClick: () => { editingId.value = row.id; Object.assign(form, row); showModal.value = true } }, () => '编辑'),
      h(NPopconfirm, { onPositiveClick: () => handleDelete(row.id) }, { trigger: () => h(NButton, { text: true, type: 'error' }, () => '删除'), default: () => '确认删除？' }),
    ],
  },
]

async function handleSave() {
  saving.value = true
  try {
    if (editingId.value) {
      await updateNews(editingId.value, { ...form })
      message.success('更新成功')
    } else {
      await createNews({ ...form })
      message.success('创建成功')
    }
    showModal.value = false
    Object.assign(form, { ...defaultForm })
    editingId.value = null
  } catch (err: unknown) {
    if (err instanceof Error) message.error(err.message)
  } finally {
    saving.value = false
  }
}

async function handleDelete(id: number) {
  try { await deleteNews(id); message.success('删除成功') } catch (err: unknown) { if (err instanceof Error) message.error(err.message) }
}

onMounted(() => fetchNews())
</script>
