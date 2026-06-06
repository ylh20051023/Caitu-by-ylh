<template>
  <div class="flex flex-wrap gap-3 items-center">
    <n-select
      v-model:value="jobFilter.type"
      :options="typeOptions"
      placeholder="岗位方向"
      clearable
      style="width: 150px"
      @update:value="onFilterChange"
    />
    <n-select
      v-model:value="jobFilter.city"
      :options="cityOptions"
      placeholder="城市"
      clearable
      style="width: 120px"
      @update:value="onFilterChange"
    />
    <n-input
      v-model:value="jobFilter.keyword"
      placeholder="搜索关键词"
      clearable
      style="width: 200px"
      @update:value="onFilterChange"
    />
  </div>
</template>

<script setup lang="ts">
import { reactive } from 'vue'
import { NSelect, NInput } from 'naive-ui'

const props = defineProps<{
  cities: string[]
  types: string[]
}>()

const emit = defineEmits<{
  filter: [filter: { type: string; city: string; keyword: string }]
}>()

const jobFilter = reactive({ type: '', city: '', keyword: '' })

const typeOptions = props.types.map(t => ({ label: t, value: t }))
const cityOptions = props.cities.map(c => ({ label: c, value: c }))

function onFilterChange() {
  emit('filter', { ...jobFilter })
}
</script>
