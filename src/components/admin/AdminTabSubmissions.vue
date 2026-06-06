<template>
  <div>
    <h2 class="text-lg font-bold mb-4">审批管理</h2>
    <n-data-table :columns="columns" :data="submissions" :loading="loading" :pagination="{ pageSize: 10 }" />

    <n-modal v-model:show="showRejectModal" preset="dialog" title="拒绝投稿" positive-text="确认拒绝" negative-text="取消" @positive-click="handleReject">
      <n-input v-model:value="rejectNote" type="textarea" placeholder="请输入拒绝原因" :rows="3" />
    </n-modal>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, h } from 'vue'
import { useMessage, type DataTableColumns } from 'naive-ui'
import { NDataTable, NButton, NTag, NModal, NInput } from 'naive-ui'
import { useSubmissions } from '@/composables/useSubmissions'
import type { Submission } from '@/types'

const message = useMessage()
const { submissions, loading, fetchSubmissions, approveSubmission, rejectSubmission } = useSubmissions()
const showRejectModal = ref(false)
const rejectNote = ref('')
const rejectingId = ref<number | null>(null)

const columns: DataTableColumns<Submission> = [
  { title: '职位', key: 'position', width: 150 },
  { title: '公司', key: 'company', width: 120 },
  { title: '城市', key: 'city', width: 80 },
  { title: '方向', key: 'type', width: 80 },
  { title: '状态', key: 'status', width: 80, render: (row) => h(NTag, { type: row.status === 'pending' ? 'warning' : row.status === 'approved' ? 'success' : 'error', size: 'small' }, () => row.status === 'pending' ? '待审核' : row.status === 'approved' ? '已通过' : '已拒绝') },
  { title: '提交时间', key: 'submitted_at', width: 120 },
  {
    title: '操作', key: 'actions', width: 160,
    render: (row) => row.status === 'pending' ? [
      h(NButton, { text: true, type: 'success', onClick: () => handleApprove(row.id) }, () => '通过'),
      h(NButton, { text: true, type: 'error', onClick: () => { rejectingId.value = row.id; showRejectModal.value = true } }, () => '拒绝'),
    ] : h('span', { class: 'text-gray-400' }, row.review_note || '-'),
  },
]

async function handleApprove(id: number) {
  try { await approveSubmission(id); message.success('审核通过') } catch (err: unknown) { if (err instanceof Error) message.error(err.message) }
}

async function handleReject() {
  if (!rejectingId.value || !rejectNote.value) { message.warning('请输入拒绝原因'); return false }
  try { await rejectSubmission(rejectingId.value, rejectNote.value); message.success('已拒绝'); rejectNote.value = ''; rejectingId.value = null } catch (err: unknown) { if (err instanceof Error) message.error(err.message) }
  return true
}

onMounted(() => fetchSubmissions())
</script>
