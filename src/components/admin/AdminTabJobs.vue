<template>
  <div>
    <div class="flex justify-between items-center mb-4">
      <h2 class="text-lg font-bold">职位管理</h2>
      <n-button type="primary" @click="showModal = true">新增职位</n-button>
    </div>

    <n-data-table :columns="columns" :data="jobs" :loading="loading" :pagination="{ pageSize: 10 }" />

    <n-modal v-model:show="showModal" preset="dialog" :title="editingId ? '编辑职位' : '新增职位'" style="width: 600px">
      <n-form ref="formRef" :model="form" label-placement="left" label-width="80">
        <n-form-item label="职位名称"><n-input v-model:value="form.title" /></n-form-item>
        <n-form-item label="公司名称"><n-input v-model:value="form.company" /></n-form-item>
        <n-form-item label="城市"><n-input v-model:value="form.city" /></n-form-item>
        <n-form-item label="省份"><n-input v-model:value="form.province" /></n-form-item>
        <n-form-item label="岗位方向"><n-input v-model:value="form.type" /></n-form-item>
        <n-form-item label="薪资范围"><n-input v-model:value="form.salary" /></n-form-item>
        <n-form-item label="截止日期"><n-input v-model:value="form.deadline" /></n-form-item>
        <n-form-item label="职位描述"><n-input v-model:value="form.description" type="textarea" :rows="3" /></n-form-item>
        <n-form-item label="官网链接"><n-input v-model:value="form.apply_url" /></n-form-item>
        <n-form-item label="投递邮箱"><n-input v-model:value="form.apply_email" /></n-form-item>
        <n-form-item label="状态">
          <n-select v-model:value="form.status" :options="statusOptions" />
        </n-form-item>
        <n-form-item label="推荐">
          <n-switch v-model:value="form.featured" />
        </n-form-item>
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
import { NDataTable, NButton, NModal, NForm, NFormItem, NInput, NSelect, NSwitch, NTag, NPopconfirm } from 'naive-ui'
import { useJobs } from '@/composables/useJobs'
import type { Job } from '@/types'

const message = useMessage()
const { jobs, loading, fetchJobs, createJob, updateJob, deleteJob } = useJobs()
const showModal = ref(false)
const saving = ref(false)
const editingId = ref<number | null>(null)

const statusOptions = [
  { label: '招聘中', value: 'active' },
  { label: '已关闭', value: 'closed' },
  { label: '草稿', value: 'draft' },
]

const defaultForm = {
  title: '', company: '', city: '', province: '', type: '', salary: '',
  deadline: '', description: '', apply_url: '', apply_email: '',
  status: 'active' as const, featured: false,
}
const form = reactive({ ...defaultForm })

const columns: DataTableColumns<Job> = [
  { title: '职位', key: 'title', width: 150 },
  { title: '公司', key: 'company', width: 120 },
  { title: '城市', key: 'city', width: 80 },
  { title: '方向', key: 'type', width: 80 },
  { title: '状态', key: 'status', width: 80, render: (row) => h(NTag, { type: row.status === 'active' ? 'success' : 'default', size: 'small' }, () => row.status === 'active' ? '招聘中' : row.status === 'closed' ? '已关闭' : '草稿') },
  { title: '推荐', key: 'featured', width: 60, render: (row) => h(NTag, { type: row.featured ? 'warning' : 'default', size: 'small' }, () => row.featured ? '是' : '否') },
  {
    title: '操作', key: 'actions', width: 140,
    render: (row) => [
      h(NButton, { text: true, type: 'primary', onClick: () => openEdit(row) }, () => '编辑'),
      h(NPopconfirm, { onPositiveClick: () => handleDelete(row.id) }, { trigger: () => h(NButton, { text: true, type: 'error' }, () => '删除'), default: () => '确认删除？' }),
    ],
  },
]

function openEdit(job: Job) {
  editingId.value = job.id
  Object.assign(form, { ...job })
  showModal.value = true
}

async function handleSave() {
  saving.value = true
  try {
    if (editingId.value) {
      await updateJob(editingId.value, { ...form })
      message.success('更新成功')
    } else {
      await createJob({ ...form })
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
  try {
    await deleteJob(id)
    message.success('删除成功')
  } catch (err: unknown) {
    if (err instanceof Error) message.error(err.message)
  }
}

onMounted(() => fetchJobs())
</script>
