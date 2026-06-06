<template>
  <div>
    <div class="flex justify-between items-center mb-4">
      <h2 class="text-lg font-bold">证书管理</h2>
      <n-button type="primary" @click="showModal = true">新增证书</n-button>
    </div>
    <n-data-table :columns="columns" :data="certs" :loading="loading" :pagination="{ pageSize: 10 }" />
    <n-modal v-model:show="showModal" preset="dialog" :title="editingId ? '编辑证书' : '新增证书'" style="width: 650px">
      <n-form :model="form" label-placement="left" label-width="80">
        <n-form-item label="名称"><n-input v-model:value="form.name" /></n-form-item>
        <n-form-item label="分类"><n-select v-model:value="form.type" :options="typeOptions" /></n-form-item>
        <n-form-item label="图标"><n-input v-model:value="form.badge" placeholder="如：📜" /></n-form-item>
        <n-form-item label="难度"><n-input v-model:value="form.difficulty" /></n-form-item>
        <n-form-item label="含金量"><n-input v-model:value="form.value" /></n-form-item>
        <n-form-item label="费用"><n-input v-model:value="form.cost" /></n-form-item>
        <n-form-item label="考试时间"><n-input v-model:value="form.exam_time" /></n-form-item>
        <n-form-item label="报名时间"><n-input v-model:value="form.signup_time" /></n-form-item>
        <n-form-item label="适合岗位"><n-input v-model:value="form.suitable" /></n-form-item>
        <n-form-item label="备注"><n-input v-model:value="form.note" type="textarea" :rows="2" /></n-form-item>
        <n-form-item label="考试方式"><n-input v-model:value="form.exam_mode" /></n-form-item>
        <n-form-item label="难度类型"><n-input v-model:value="form.difficulty_type" /></n-form-item>
        <n-form-item label="通过率"><n-input v-model:value="form.pass_rate" /></n-form-item>
        <n-form-item label="优势"><n-input v-model:value="form.advantage" /></n-form-item>
        <n-form-item label="薪资"><n-input v-model:value="form.salary" /></n-form-item>
        <n-form-item label="行业前景"><n-input v-model:value="form.industry" /></n-form-item>
        <n-form-item label="政策支持"><n-input v-model:value="form.national_support" /></n-form-item>
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
import { NDataTable, NButton, NModal, NForm, NFormItem, NInput, NSelect, NPopconfirm } from 'naive-ui'
import { useCerts } from '@/composables/useCerts'
import type { Cert } from '@/types'

const message = useMessage()
const { certs, loading, fetchCerts, createCert, updateCert, deleteCert } = useCerts()
const showModal = ref(false)
const saving = ref(false)
const editingId = ref<number | null>(null)

const typeOptions = [
  { label: '在校可考', value: '在校可考' },
  { label: '毕业可考', value: '毕业可考' },
  { label: '需工作年限', value: '需工作年限' },
]

const defaultForm = { name: '', type: '在校可考', badge: '', difficulty: '', value: '', cost: '', exam_time: '', signup_time: '', suitable: '', note: '', exam_mode: '', difficulty_type: '', pass_rate: '', advantage: '', salary: '', industry: '', national_support: '' }
const form = reactive({ ...defaultForm })

const columns: DataTableColumns<Cert> = [
  { title: '图标', key: 'badge', width: 50 },
  { title: '名称', key: 'name', width: 150 },
  { title: '分类', key: 'type', width: 100 },
  { title: '难度', key: 'difficulty', width: 80 },
  { title: '含金量', key: 'value', width: 80 },
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
    if (editingId.value) { await updateCert(editingId.value, { ...form }); message.success('更新成功') }
    else { await createCert({ ...form }); message.success('创建成功') }
    showModal.value = false; Object.assign(form, { ...defaultForm }); editingId.value = null
  } catch (err: unknown) { if (err instanceof Error) message.error(err.message) } finally { saving.value = false }
}

async function handleDelete(id: number) {
  try { await deleteCert(id); message.success('删除成功') } catch (err: unknown) { if (err instanceof Error) message.error(err.message) }
}

onMounted(() => fetchCerts())
</script>
