<template>
  <div v-if="users.length === 0" class="text-center text-text-secondary py-8">
    暂无数据，等待用户注册
  </div>
  <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-6">
    <!-- 🏫 高校使用榜单 -->
    <div class="bg-white rounded-xl border border-gray-100 p-5 shadow-sm">
      <h3 class="text-base font-bold text-text mb-4">🏫 高校使用榜单</h3>
      <div class="space-y-3">
        <div v-for="(item, idx) in schoolRanking" :key="item.name" class="flex items-center gap-3">
          <span class="w-6 text-center font-bold text-sm" :class="rankClass(idx)">{{ rankLabel(idx) }}</span>
          <div class="flex-1 min-w-0">
            <div class="flex items-center justify-between mb-1">
              <span class="text-sm text-text truncate">{{ item.name }}</span>
              <span class="text-xs text-text-secondary ml-2 shrink-0">{{ item.count }}人</span>
            </div>
            <div class="h-2 rounded-full bg-gray-100 overflow-hidden">
              <div
                class="h-full rounded-full transition-all duration-500"
                :style="{ width: `${item.percent}%`, background: rankBarGradient(idx, 'school') }"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 📚 专业热度榜单 -->
    <div class="bg-white rounded-xl border border-gray-100 p-5 shadow-sm">
      <h3 class="text-base font-bold text-text mb-4">📚 专业热度榜单</h3>
      <div class="space-y-3">
        <div v-for="(item, idx) in majorRanking" :key="item.name" class="flex items-center gap-3">
          <span class="w-6 text-center font-bold text-sm" :class="rankClass(idx)">{{ rankLabel(idx) }}</span>
          <div class="flex-1 min-w-0">
            <div class="flex items-center justify-between mb-1">
              <span class="text-sm text-text truncate">{{ item.name }}</span>
              <span class="text-xs text-text-secondary ml-2 shrink-0">{{ item.count }}人</span>
            </div>
            <div class="h-2 rounded-full bg-gray-100 overflow-hidden">
              <div
                class="h-full rounded-full transition-all duration-500"
                :style="{ width: `${item.percent}%`, background: rankBarGradient(idx, 'major') }"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { User } from '@/types'

interface RankingItem {
  name: string
  count: number
  percent: number
}

const props = defineProps<{
  users: User[]
}>()

const MEDALS = ['🥇', '🥈', '🥉']

/** 统计指定字段的人数并排序，取前10 */
function computeRanking(field: keyof Pick<User, 'school' | 'major'>): RankingItem[] {
  const counts: Record<string, number> = {}
  props.users.forEach((u) => {
    const val = u[field]
    if (val && val.trim()) {
      counts[val.trim()] = (counts[val.trim()] || 0) + 1
    }
  })
  const sorted = Object.entries(counts)
    .map(([name, count]) => ({ name, count }))
    .sort((a, b) => b.count - a.count)
    .slice(0, 10)
  const max = sorted.length > 0 ? sorted[0].count : 1
  return sorted.map((item) => ({
    name: item.name,
    count: item.count,
    percent: Math.round((item.count / max) * 100),
  }))
}

const schoolRanking = computed(() => computeRanking('school'))
const majorRanking = computed(() => computeRanking('major'))

function rankLabel(idx: number): string {
  return idx < 3 ? MEDALS[idx] : `${idx + 1}`
}

function rankClass(idx: number): string {
  if (idx === 0) return 'text-yellow-500'
  if (idx === 1) return 'text-gray-400'
  if (idx === 2) return 'text-amber-600'
  return 'text-text-secondary'
}

function rankBarGradient(idx: number, type: 'school' | 'major'): string {
  if (type === 'school') {
    if (idx === 0) return 'linear-gradient(90deg, #3b82f6, #8b5cf6)'
    if (idx === 1) return 'linear-gradient(90deg, #60a5fa, #a78bfa)'
    if (idx === 2) return 'linear-gradient(90deg, #93c5fd, #c4b5fd)'
    return '#d1d5db'
  }
  // major
  if (idx === 0) return 'linear-gradient(90deg, #10b981, #059669)'
  if (idx === 1) return 'linear-gradient(90deg, #34d399, #10b981)'
  if (idx === 2) return 'linear-gradient(90deg, #6ee7b7, #34d399)'
  return '#d1d5db'
}
</script>
