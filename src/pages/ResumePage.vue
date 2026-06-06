<template>
  <div>
    <!-- Hero 区域 -->
    <section class="bg-gradient-to-r from-yellow-50 to-green-50 py-12">
      <div class="container-content text-center">
        <h1 class="text-2xl md:text-3xl font-bold text-text mb-3">简历诊断</h1>
        <p class="text-text-secondary max-w-xl mx-auto text-sm md:text-base">
          好的简历是拿到面试的第一步。掌握以下常见误区和写作建议，让你的简历脱颖而出。
        </p>
      </div>
    </section>

    <!-- 内容区域 -->
    <div class="container-content py-10 space-y-8">
      <!-- 常见简历误区 -->
      <section>
        <h2 class="text-xl font-bold text-text mb-4 flex items-center gap-2">
          <span class="text-red-500">⚠️</span> 常见简历误区
        </h2>
        <div class="space-y-3">
          <div
            v-for="tip in mistakeTips"
            :key="tip.id"
            class="border border-red-200 rounded-lg overflow-hidden bg-white"
          >
            <div
              class="flex items-center justify-between px-5 py-4 cursor-pointer select-none hover:bg-red-50 transition-colors"
              @click="toggleTip(tip.id)"
            >
              <div class="flex items-center gap-3">
                <n-tag type="error" size="small" :bordered="false">误区</n-tag>
                <span class="text-sm font-medium text-text">{{ tip.title }}</span>
              </div>
              <n-icon size="18" class="text-text-secondary transition-transform duration-200" :class="{ 'rotate-180': expandedIds.has(tip.id) }">
                <chevron-down-outline />
              </n-icon>
            </div>
            <div v-show="expandedIds.has(tip.id)" class="px-5 pb-4 pt-0">
              <p class="text-sm text-text-secondary leading-relaxed border-t border-red-100 pt-3">{{ tip.content }}</p>
            </div>
          </div>
        </div>
      </section>

      <!-- 💡 财会简历写作建议 -->
      <section>
        <h2 class="text-xl font-bold text-text mb-4 flex items-center gap-2">
          <span>💡</span> 财会简历写作建议
        </h2>
        <div class="space-y-3">
          <div
            v-for="tip in suggestTips"
            :key="tip.id"
            class="border border-blue-200 rounded-lg overflow-hidden bg-white"
          >
            <div
              class="flex items-center justify-between px-5 py-4 cursor-pointer select-none hover:bg-blue-50 transition-colors"
              @click="toggleTip(tip.id)"
            >
              <div class="flex items-center gap-3">
                <n-tag type="info" size="small" :bordered="false">建议</n-tag>
                <span class="text-sm font-medium text-text">{{ tip.title }}</span>
              </div>
              <n-icon size="18" class="text-text-secondary transition-transform duration-200" :class="{ 'rotate-180': expandedIds.has(tip.id) }">
                <chevron-down-outline />
              </n-icon>
            </div>
            <div v-show="expandedIds.has(tip.id)" class="px-5 pb-4 pt-0">
              <p class="text-sm text-text-secondary leading-relaxed border-t border-blue-100 pt-3">{{ tip.content }}</p>
            </div>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { NTag, NIcon } from 'naive-ui'
import { ChevronDownOutline } from '@vicons/ionicons5'
import { useResumeTips } from '@/composables/useResumeTips'

const { resumeTips, fetchResumeTips } = useResumeTips()
const expandedIds = ref<Set<number>>(new Set())

const mistakeTips = computed(() => resumeTips.value.filter((t) => t.category === '误区'))
const suggestTips = computed(() => resumeTips.value.filter((t) => t.category === '建议'))

function toggleTip(id: number) {
  const next = new Set(expandedIds.value)
  if (next.has(id)) {
    next.delete(id)
  } else {
    next.add(id)
  }
  expandedIds.value = next
}

onMounted(() => {
  fetchResumeTips()
})
</script>
