<template>
  <div class="min-h-screen flex">
    <AdminSidebar active-tab="jobs" />
    <main class="flex-1 bg-gray-50 p-6">
      <router-view />
    </main>
  </div>
</template>

<script setup lang="ts">
import AdminSidebar from '@/components/admin/AdminSidebar.vue'
</script>
