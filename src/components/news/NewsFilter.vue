<template>
  <div class="flex flex-wrap gap-2">
    <n-button
      v-for="cat in categories"
      :key="cat"
      :type="modelValue === cat ? 'primary' : 'default'"
      size="small"
      @click="$emit('update:modelValue', cat)"
    >
      {{ cat }}
    </n-button>
    <n-button
      :type="!modelValue ? 'primary' : 'default'"
      size="small"
      @click="$emit('update:modelValue', '')"
    >
      全部
    </n-button>
  </div>
</template>

<script setup lang="ts">
import { NButton } from 'naive-ui'

defineProps<{
  categories: string[]
  modelValue: string
}>()

defineEmits<{
  'update:modelValue': [value: string]
}>()
</script>
