<template>
  <div>
    <div class="flex gap-6 h-full">
      <AdminSidebar v-model:active-tab="activeTab" />
      <div class="flex-1 min-w-0">
        <AdminTabJobs v-if="activeTab === 'jobs'" />
        <AdminTabNews v-else-if="activeTab === 'news'" />
        <AdminTabCareers v-else-if="activeTab === 'careers'" />
        <AdminTabCerts v-else-if="activeTab === 'certs'" />
        <AdminTabSubmissions v-else-if="activeTab === 'submissions'" />
        <AdminTabUsers v-else-if="activeTab === 'users'" />
        <AdminTabAdmins v-else-if="activeTab === 'admins'" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import AdminSidebar from '@/components/admin/AdminSidebar.vue'
import AdminTabJobs from '@/components/admin/AdminTabJobs.vue'
import AdminTabNews from '@/components/admin/AdminTabNews.vue'
import AdminTabCareers from '@/components/admin/AdminTabCareers.vue'
import AdminTabCerts from '@/components/admin/AdminTabCerts.vue'
import AdminTabSubmissions from '@/components/admin/AdminTabSubmissions.vue'
import AdminTabUsers from '@/components/admin/AdminTabUsers.vue'
import AdminTabAdmins from '@/components/admin/AdminTabAdmins.vue'

const activeTab = ref('jobs')
</script>
