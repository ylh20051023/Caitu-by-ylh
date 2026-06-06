import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
import { supabase } from '@/config/supabase'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: () => import('@/layouts/DefaultLayout.vue'),
    children: [
      { path: '', name: 'home', component: () => import('@/pages/HomePage.vue'), meta: { title: '首页' } },
      { path: 'internships', name: 'internships', component: () => import('@/pages/InternshipsPage.vue'), meta: { title: '实习广场' } },
      { path: 'internship/:id', name: 'internship-detail', component: () => import('@/pages/InternshipDetailPage.vue'), meta: { title: '实习详情' } },
      { path: 'certificates', name: 'certificates', component: () => import('@/pages/CertificatesPage.vue'), meta: { title: '证书查询' } },
      { path: 'news', name: 'news', component: () => import('@/pages/NewsPage.vue'), meta: { title: '行业资讯' } },
      { path: 'news/:id', name: 'news-detail', component: () => import('@/pages/NewsDetailPage.vue'), meta: { title: '资讯详情' } },
      { path: 'login', name: 'login', component: () => import('@/pages/LoginPage.vue'), meta: { title: '登录/注册' } },
      { path: 'post-job', name: 'post-job', component: () => import('@/pages/PostJobPage.vue'), meta: { title: '发布实习', requiresAuth: true } },
      { path: 'guide', name: 'guide', component: () => import('@/pages/GuidePage.vue'), meta: { title: '用户指南' } },
      { path: 'resume', name: 'resume', component: () => import('@/pages/ResumePage.vue'), meta: { title: '简历诊断' } },
    ],
  },
  {
    path: '/admin',
    component: () => import('@/layouts/AdminLayout.vue'),
    meta: { requiresAuth: true, requiresAdmin: true },
    children: [
      { path: '', name: 'admin', component: () => import('@/pages/AdminPage.vue'), meta: { title: '后台管理', requiresAuth: true, requiresAdmin: true } },
    ],
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  },
})

// 导航守卫
router.beforeEach(async (to, _from, next) => {
  // 设置页面标题
  if (to.meta.title) {
    document.title = `${to.meta.title} - 财途指南`
  }

  const requiresAuth = to.meta.requiresAuth
  const requiresAdmin = to.meta.requiresAdmin

  if (!requiresAuth && !requiresAdmin) {
    // 已登录用户访问登录页时重定向首页
    if (to.name === 'login') {
      const { data: { session } } = await supabase.auth.getSession()
      if (session) return next({ name: 'home' })
    }
    return next()
  }

  const { data: { session } } = await supabase.auth.getSession()

  if (!session) {
    return next({ name: 'login', query: { redirect: to.fullPath } })
  }

  if (requiresAdmin) {
    const { data: adminData } = await supabase
      .from('admins')
      .select('id, status')
      .eq('id', session.user.id)
      .eq('status', 'active')
      .single()

    if (!adminData) {
      return next({ name: 'home' })
    }
  }

  next()
})

export default router
