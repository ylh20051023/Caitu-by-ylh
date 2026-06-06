<template>
  <div>
    <div class="flex justify-between items-center mb-4">
      <h2 class="text-lg font-bold">职业方向管理</h2>
      <n-button type="primary" @click="showModal = true">新增方向</n-button>
    </div>
    <n-data-table :columns="columns" :data="careers" :loading="loading" :pagination="{ pageSize: 10 }" />
    <n-modal v-model:show="showModal" preset="dialog" :title="editingId ? '编辑方向' : '新增方向'" style="width: 650px">
      <n-form :model="form" label-placement="left" label-width="80">
        <n-form-item label="名称"><n-input v-model:value="form.title" /></n-form-item>
        <n-form-item label="图标"><n-input v-model:value="form.emoji" placeholder="如：📊" /></n-form-item>
        <n-form-item label="描述"><n-input v-model:value="form.description" type="textarea" :rows="2" /></n-form-item>
        <n-form-item label="所需技能"><n-input v-model:value="form.skills" type="textarea" :rows="2" /></n-form-item>
        <n-form-item label="发展路径"><n-input v-model:value="form.path" type="textarea" :rows="2" /></n-form-item>
        <n-form-item label="优势分析"><n-input v-model:value="form.advantage" type="textarea" :rows="2" /></n-form-item>
        <n-form-item label="薪资范围"><n-input v-model:value="form.salary" /></n-form-item>
        <n-form-item label="行业前景"><n-input v-model:value="form.industry" /></n-form-item>
        <n-form-item label="政策支持"><n-input v-model:value="form.national_support" /></n-form-item>
        <n-form-item label="不足之处"><n-input v-model:value="form.drawback" type="textarea" :rows="2" /></n-form-item>
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
import { useCareers } from '@/composables/useCareers'
import type { Career } from '@/types'

const message = useMessage()
const { careers, loading, fetchCareers, createCareer, updateCareer, deleteCareer } = useCareers()
const showModal = ref(false)
const saving = ref(false)
const editingId = ref<number | null>(null)
const defaultForm = { title: '', emoji: '', description: '', skills: '', path: '', advantage: '', salary: '', industry: '', national_support: '', drawback: '' }
const form = reactive({ ...defaultForm })

const columns: DataTableColumns<Career> = [
  { title: '图标', key: 'emoji', width: 50 },
  { title: '名称', key: 'title', width: 120 },
  { title: '描述', key: 'description', ellipsis: { tooltip: true } },
  { title: '薪资', key: 'salary', width: 100 },
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
    if (editingId.value) { await updateCareer(editingId.value, { ...form }); message.success('更新成功') }
    else { await createCareer({ ...form }); message.success('创建成功') }
    showModal.value = false; Object.assign(form, { ...defaultForm }); editingId.value = null
  } catch (err: unknown) { if (err instanceof Error) message.error(err.message) } finally { saving.value = false }
}

async function handleDelete(id: number) {
  try { await deleteCareer(id); message.success('删除成功') } catch (err: unknown) { if (err instanceof Error) message.error(err.message) }
}

onMounted(() => fetchCareers())
</script>
