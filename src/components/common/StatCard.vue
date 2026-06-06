<template>
  <n-card class="text-center" hoverable>
    <div class="text-3xl mb-2">{{ emoji }}</div>
    <div class="text-2xl font-bold text-primary">{{ value }}</div>
    <div class="text-text-secondary text-sm mt-1">{{ label }}</div>
  </n-card>
</template>

<script setup lang="ts">
import { NCard } from 'naive-ui'

defineProps<{
  emoji: string
  value: string | number
  label: string
}>()
</script>
