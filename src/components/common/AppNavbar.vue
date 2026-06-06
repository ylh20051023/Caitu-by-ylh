<template>
  <n-layout-header class="sticky top-0 z-50 bg-white shadow-sm">
    <div class="container-content flex items-center justify-between h-16">
      <router-link to="/" class="flex items-center gap-2 no-underline">
        <span class="text-2xl">🧭</span>
        <span class="text-xl font-bold text-primary">财途指南</span>
      </router-link>

      <!-- 桌面导航 -->
      <div class="hidden md:flex items-center gap-1">
        <n-menu mode="horizontal" :value="activeKey" :options="menuOptions" @update:value="handleMenuClick" />
        <!-- 登录后的额外菜单 -->
        <template v-if="authStore.user">
          <n-menu mode="horizontal" :value="activeKey" :options="authMenuOptions" @update:value="handleMenuClick" />
        </template>
      </div>

      <div class="flex items-center gap-3">
        <template v-if="authStore.user">
          <n-tag v-if="authStore.isAdmin" type="success" size="small">管理员</n-tag>
          <n-dropdown :options="userOptions" @select="handleUserAction">
            <n-button text>{{ authStore.user.username }}</n-button>
          </n-dropdown>
        </template>
        <template v-else>
          <router-link to="/login">
            <n-button type="primary" size="small">登录/注册</n-button>
          </router-link>
        </template>

        <!-- 移动端菜单按钮 -->
        <n-button class="md:hidden" quaternary @click="showMobileMenu = !showMobileMenu">
          <template #icon><n-icon><menu-outline /></n-icon></template>
        </n-button>
      </div>
    </div>

    <!-- 移动端菜单 -->
    <n-drawer v-model:show="showMobileMenu" placement="top" :height="350">
      <n-drawer-content>
        <n-menu :value="activeKey" :options="menuOptions" @update:value="handleMobileMenuClick" />
        <n-menu v-if="authStore.user" :value="activeKey" :options="authMenuOptions" @update:value="handleMobileMenuClick" />
      </n-drawer-content>
    </n-drawer>
  </n-layout-header>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useAuth } from '@/composables/useAuth'
import { NLayoutHeader, NMenu, NButton, NTag, NDropdown, NDrawer, NDrawerContent, NIcon } from 'naive-ui'
import { MenuOutline } from '@vicons/ionicons5'
import type { MenuOption, DropdownOption } from 'naive-ui'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()
const { logout } = useAuth()
const showMobileMenu = ref(false)

const activeKey = computed(() => {
  const path = route.path
  if (path === '/') return 'home'
  if (path.startsWith('/internship')) return 'internships'
  if (path.startsWith('/certificates')) return 'certificates'
  if (path.startsWith('/news')) return 'news'
  if (path.startsWith('/resume')) return 'resume'
  if (path.startsWith('/post-job')) return 'post-job'
  if (path.startsWith('/admin')) return 'admin'
  return ''
})

const menuOptions: MenuOption[] = [
  { label: '首页', key: 'home' },
  { label: '实习广场', key: 'internships' },
  { label: '证书查询', key: 'certificates' },
  { label: '行业资讯', key: 'news' },
  { label: '简历诊断', key: 'resume' },
]

// 动态菜单：登录后显示的额外选项
const authMenuOptions = computed<MenuOption[]>(() => {
  const options: MenuOption[] = [
    { label: '✍️ 发布实习', key: 'post-job' },
  ]
  if (authStore.isAdmin) {
    options.push({ label: '⚙️ 后台管理', key: 'admin' })
  }
  return options
})

const userOptions: DropdownOption[] = [
  { label: '发布实习', key: 'post-job' },
  { label: '后台管理', key: 'admin', show: authStore.isAdmin },
  { type: 'divider', key: 'd1' },
  { label: '退出登录', key: 'logout' },
]

function handleMenuClick(key: string) {
  router.push({ name: key })
}

function handleMobileMenuClick(key: string) {
  showMobileMenu.value = false
  router.push({ name: key })
}

async function handleUserAction(key: string) {
  if (key === 'logout') {
    await logout()
    router.push({ name: 'home' })
  } else {
    router.push({ name: key })
  }
}
</script>
