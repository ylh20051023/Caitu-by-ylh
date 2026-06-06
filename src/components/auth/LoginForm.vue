<template>
  <n-form ref="formRef" :model="form" :rules="rules" label-placement="left" label-width="80">
    <n-form-item label="邮箱" path="email">
      <n-input v-model:value="form.email" placeholder="请输入邮箱" />
    </n-form-item>
    <n-form-item label="密码" path="password">
      <n-input v-model:value="form.password" type="password" show-password-on="click" placeholder="请输入密码" />
    </n-form-item>
    <n-button type="primary" block :loading="loading" @click="handleLogin">登录</n-button>
  </n-form>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useMessage, type FormInst, type FormRules } from 'naive-ui'
import { NForm, NFormItem, NInput, NButton } from 'naive-ui'
import { useAuth } from '@/composables/useAuth'

const router = useRouter()
const message = useMessage()
const { login, loading } = useAuth()
const formRef = ref<FormInst | null>(null)

const form = reactive({ email: '', password: '' })

const rules: FormRules = {
  email: [{ required: true, message: '请输入邮箱', trigger: 'blur' }, { type: 'email', message: '请输入有效邮箱', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
}

async function handleLogin() {
  try {
    await formRef.value?.validate()
    await login(form.email, form.password)
    message.success('登录成功')
    const redirect = (router.currentRoute.value.query.redirect as string) || '/'
    router.push(redirect)
  } catch (err: unknown) {
    if (err instanceof Error) message.error(err.message)
  }
}
</script>
