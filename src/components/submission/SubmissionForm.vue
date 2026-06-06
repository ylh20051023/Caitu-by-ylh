<template>
  <n-form ref="formRef" :model="form" :rules="rules" label-placement="left" label-width="80">
    <n-form-item label="职位名称" path="position">
      <n-input v-model:value="form.position" placeholder="请输入职位名称" />
    </n-form-item>
    <n-form-item label="公司名称" path="company">
      <n-input v-model:value="form.company" placeholder="请输入公司名称" />
    </n-form-item>
    <n-form-item label="城市" path="city">
      <n-input v-model:value="form.city" placeholder="请输入城市" />
    </n-form-item>
    <n-form-item label="岗位方向" path="type">
      <n-input v-model:value="form.type" placeholder="如：审计、税务、财务分析" />
    </n-form-item>
    <n-form-item label="薪资范围" path="salary">
      <n-input v-model:value="form.salary" placeholder="如：150-200元/天" />
    </n-form-item>
    <n-form-item label="截止日期" path="deadline">
      <n-input v-model:value="form.deadline" placeholder="如：2026-06-30" />
    </n-form-item>
    <n-form-item label="职位描述" path="description">
      <n-input v-model:value="form.description" type="textarea" :rows="4" placeholder="请输入职位描述" />
    </n-form-item>
    <n-form-item label="官网链接" path="apply_url">
      <n-input v-model:value="form.apply_url" placeholder="投递官网链接（选填）" />
    </n-form-item>
    <n-form-item label="投递邮箱" path="apply_email">
      <n-input v-model:value="form.apply_email" placeholder="投递邮箱（选填）" />
    </n-form-item>
    <n-form-item label="联系方式" path="contact">
      <n-input v-model:value="form.contact" placeholder="您的联系方式（选填）" />
    </n-form-item>
    <n-button type="primary" block :loading="loading" @click="handleSubmit">提交审核</n-button>
  </n-form>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useMessage, type FormInst, type FormRules } from 'naive-ui'
import { NForm, NFormItem, NInput, NButton } from 'naive-ui'
import { useSubmissions } from '@/composables/useSubmissions'

const emit = defineEmits<{ success: [] }>()
const message = useMessage()
const { submitJob, loading } = useSubmissions()
const formRef = ref<FormInst | null>(null)

const form = reactive({
  position: '', company: '', city: '', type: '', salary: '',
  deadline: '', description: '', apply_url: '', apply_email: '', contact: '',
})

const rules: FormRules = {
  position: [{ required: true, message: '请输入职位名称', trigger: 'blur' }],
  company: [{ required: true, message: '请输入公司名称', trigger: 'blur' }],
  description: [{ required: true, message: '请输入职位描述', trigger: 'blur' }],
}

async function handleSubmit() {
  try {
    await formRef.value?.validate()
    await submitJob(form)
    message.success('提交成功，等待管理员审核')
    emit('success')
  } catch (err: unknown) {
    if (err instanceof Error) message.error(err.message)
  }
}
</script>
