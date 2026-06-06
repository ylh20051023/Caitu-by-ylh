// 数据库表类型

export interface Career {
  id: number
  title: string
  emoji: string
  description: string
  skills: string
  path: string
  advantage: string
  salary: string
  industry: string
  national_support: string
  drawback: string
}

export interface Job {
  id: number
  title: string
  company: string
  city: string
  province: string
  type: string
  salary: string
  deadline: string
  description: string
  featured: boolean
  apply_url: string
  apply_email: string
  status: 'active' | 'closed' | 'draft'
  created_at: string
}

export interface Cert {
  id: number
  name: string
  type: string
  badge: string
  difficulty: string
  value: string
  cost: string
  exam_time: string
  signup_time: string
  suitable: string
  note: string
  exam_mode: string
  difficulty_type: string
  pass_rate: string
  advantage: string
  salary: string
  industry: string
  national_support: string
}

export interface News {
  id: number
  title: string
  date: string
  category: string
  summary: string
  content: string
  created_at: string
}

export interface User {
  id: string
  email: string
  username: string
  school: string
  major: string
  grade: string
  plan: string
  created_at: string
}

export interface Admin {
  id: string
  email: string
  account: string
  name: string
  role: 'super' | 'admin'
  identity: string
  phone: string
  status: 'active' | 'inactive'
  note: string
  permissions: Record<string, boolean>
  created_at: string
}

export interface Submission {
  id: number
  position: string
  company: string
  city: string
  type: string
  salary: string
  deadline: string
  description: string
  apply_url: string
  apply_email: string
  contact: string
  status: 'pending' | 'approved' | 'rejected'
  submitted_at: string
  review_note: string
  created_at: string
}

export interface Setting {
  key: string
  value: string
}

// 前端筛选参数
export interface JobFilter {
  type: string
  city: string
  keyword: string
}

export interface NewsFilter {
  category: string
}

export interface RegisterForm {
  email: string
  password: string
  username: string
  school: string
  major: string
  grade: string
  plan: string
}

export interface ResumeTip {
  id: number
  title: string
  category: '误区' | '建议'
  content: string
}

// 路由 meta 类型
export interface RouteMeta {
  requiresAuth?: boolean
  requiresAdmin?: boolean
  title?: string
  layout?: 'default' | 'admin'
}
