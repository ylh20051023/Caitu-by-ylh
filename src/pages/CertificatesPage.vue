<template>
  <div class="container-content py-8">
    <h1 class="text-2xl font-bold text-text mb-6">📜 证书查询</h1>
    <CertTabs v-model="currentTab" />
    <LoadingSpinner v-if="loading" />
    <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-6">
      <CertCard v-for="cert in filteredCerts" :key="cert.id" :cert="cert" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useCerts } from '@/composables/useCerts'
import CertTabs from '@/components/cert/CertTabs.vue'
import CertCard from '@/components/cert/CertCard.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'

const { currentTab, filteredCerts, loading, fetchCerts } = useCerts()

onMounted(() => {
  if (filteredCerts.value.length === 0) fetchCerts()
})
</script>
