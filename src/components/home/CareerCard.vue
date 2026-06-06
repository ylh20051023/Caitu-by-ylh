<template>
  <n-card hoverable class="cursor-pointer transition-all hover:-translate-y-1 hover:shadow-lg" @click="showModal = true">
    <div class="flex items-start gap-4">
      <span class="text-4xl flex-shrink-0">{{ career.emoji }}</span>
      <div class="flex-1 min-w-0">
        <h3 class="text-lg font-bold text-text mb-2">{{ career.title }}</h3>
        <p class="text-text-secondary text-sm line-clamp-2 leading-relaxed">{{ career.description }}</p>
      </div>
    </div>
  </n-card>

  <!-- 详情弹窗 -->
  <n-modal
    v-model:show="showModal"
    :title="`${career.emoji} ${career.title}`"
    preset="card"
    class="max-w-xl"
    style="max-width: 560px"
    :bordered="false"
    size="medium"
  >
    <div class="space-y-3 max-h-[70vh] overflow-y-auto pr-1">
      <p class="text-sm text-gray-600 leading-relaxed">{{ career.description }}</p>

      <div class="bg-green-50 rounded-lg p-4">
        <div class="text-sm font-semibold text-green-700 mb-1">💪 财会人的优势</div>
        <div class="text-sm text-green-800 leading-relaxed">{{ career.advantage }}</div>
      </div>

      <div class="bg-blue-50 rounded-lg p-4">
        <div class="text-sm font-semibold text-blue-700 mb-1">💰 薪资前景</div>
        <div class="text-sm text-blue-800 leading-relaxed">{{ career.salary }}</div>
      </div>

      <div class="bg-amber-50 rounded-lg p-4">
        <div class="text-sm font-semibold text-amber-700 mb-1">🏭 行业状况</div>
        <div class="text-sm text-amber-800 leading-relaxed">{{ career.industry }}</div>
      </div>

      <div class="bg-purple-50 rounded-lg p-4">
        <div class="text-sm font-semibold text-purple-700 mb-1">🏛️ 国家政策支持</div>
        <div class="text-sm text-purple-800 leading-relaxed">{{ career.national_support }}</div>
      </div>

      <div class="bg-red-50 rounded-lg p-4">
        <div class="text-sm font-semibold text-red-700 mb-1">⚠️ 现实烦恼与弊端</div>
        <div class="text-sm text-red-800 leading-relaxed">{{ career.drawback }}</div>
      </div>

      <div class="bg-gray-50 rounded-lg p-4">
        <div class="text-sm font-semibold text-gray-700 mb-1">🛤️ 职业路径</div>
        <div class="text-sm text-gray-800 leading-relaxed">{{ career.path }}</div>
      </div>

      <div class="bg-gray-50 rounded-lg p-4">
        <div class="text-sm font-semibold text-gray-700 mb-1">🛠️ 核心能力</div>
        <div class="text-sm text-gray-800 leading-relaxed">{{ career.skills }}</div>
      </div>
    </div>
  </n-modal>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { NCard, NModal } from 'naive-ui'
import type { Career } from '@/types'

defineProps<{ career: Career }>()

const showModal = ref(false)
</script>
