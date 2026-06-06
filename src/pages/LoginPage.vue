<template>
  <div class="container-content py-8 max-w-md mx-auto">
    <n-card>
      <n-tabs v-model:value="activeTab" type="line" animated>
        <n-tab-pane name="login" tab="登录">
          <LoginForm />
        </n-tab-pane>
        <n-tab-pane name="register" tab="注册">
          <RegisterForm />
        </n-tab-pane>
      </n-tabs>
    </n-card>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { NCard, NTabs, NTabPane } from 'naive-ui'
import LoginForm from '@/components/auth/LoginForm.vue'
import RegisterForm from '@/components/auth/RegisterForm.vue'

const activeTab = ref('login')
</script>
