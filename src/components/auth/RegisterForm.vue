<template>
  <n-form ref="formRef" :model="form" :rules="rules" label-placement="left" label-width="80">
    <n-form-item label="邮箱" path="email">
      <n-input v-model:value="form.email" placeholder="请输入邮箱" />
    </n-form-item>
    <n-form-item label="密码" path="password">
      <n-input v-model:value="form.password" type="password" show-password-on="click" placeholder="请输入密码（6位以上）" />
    </n-form-item>
    <n-form-item label="用户名" path="username">
      <n-input v-model:value="form.username" placeholder="请输入用户名" />
    </n-form-item>
    <n-form-item label="学校" path="school">
      <n-input v-model:value="form.school" placeholder="请输入学校" />
    </n-form-item>
    <n-form-item label="专业" path="major">
      <n-input v-model:value="form.major" placeholder="请输入专业" />
    </n-form-item>
    <n-form-item label="年级" path="grade">
      <n-select v-model:value="form.grade" :options="gradeOptions" placeholder="请选择年级" />
    </n-form-item>
    <n-form-item label="毕业打算" path="plan">
      <n-select v-model:value="form.plan" :options="planOptions" placeholder="请选择毕业打算" />
    </n-form-item>
    <n-button type="primary" block :loading="loading" @click="handleRegister">注册</n-button>
  </n-form>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useMessage, type FormInst, type FormRules } from 'naive-ui'
import { NForm, NFormItem, NInput, NSelect, NButton } from 'naive-ui'
import { useAuth } from '@/composables/useAuth'
import type { RegisterForm } from '@/types'

const router = useRouter()
const message = useMessage()
const { register, loading } = useAuth()
const formRef = ref<FormInst | null>(null)

const form = reactive<RegisterForm>({
  email: '', password: '', username: '', school: '', major: '', grade: '', plan: ''
})

const gradeOptions = [
  { label: '大一', value: '大一' },
  { label: '大二', value: '大二' },
  { label: '大三', value: '大三' },
  { label: '大四', value: '大四' },
  { label: '研究生', value: '研究生' },
]

const planOptions = [
  { label: '就业', value: '就业' },
  { label: '考研', value: '考研' },
  { label: '考公', value: '考公' },
  { label: '出国', value: '出国' },
  { label: '暂未确定', value: '暂未确定' },
]

const rules: FormRules = {
  email: [{ required: true, message: '请输入邮箱', trigger: 'blur' }, { type: 'email', message: '请输入有效邮箱', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }, { min: 6, message: '密码至少6位', trigger: 'blur' }],
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  school: [{ required: true, message: '请输入学校', trigger: 'blur' }],
  major: [{ required: true, message: '请输入专业', trigger: 'blur' }],
}

async function handleRegister() {
  try {
    await formRef.value?.validate()
    await register(form)
    message.success('注册成功')
    router.push('/')
  } catch (err: unknown) {
    if (err instanceof Error) message.error(err.message)
  }
}
</script>
