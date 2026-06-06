<template>
  <n-tabs v-model:value="currentTab" type="line" animated>
    <n-tab v-for="tab in tabs" :key="tab" :name="tab">{{ tab }}</n-tab>
  </n-tabs>
</template>

<script setup lang="ts">
import { NTabs, NTab } from 'naive-ui'

const tabs = ['全部', '在校可考', '毕业可考', '需工作年限']

const currentTab = defineModel<string>({ default: '全部' })
</script>
