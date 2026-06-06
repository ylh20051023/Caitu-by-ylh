<template>
  <section class="bg-gradient-to-br from-blue-600 via-blue-500 to-emerald-500 text-white py-16 md:py-24">
    <div class="container-content text-center">
      <h1 class="text-3xl md:text-5xl font-bold mb-4 leading-tight">
        财会不止做会计<br>
        你的职业可能<span class="text-yellow-300">远超想象</span>
      </h1>
      <p class="text-base md:text-lg mb-8 text-blue-100 max-w-2xl mx-auto leading-relaxed">
        专为财会在校大学生打造，帮你发现审计、税务、风控、咨询等多元职业方向，找到最适合你的实习机会。
      </p>
      <div class="flex flex-wrap justify-center gap-4">
        <a href="#careers" class="no-underline">
          <n-button type="primary" size="large" class="bg-white text-blue-600 hover:bg-blue-50 font-medium">
            探索职业方向
          </n-button>
        </a>
        <router-link to="/internships">
          <n-button size="large" ghost class="text-white border-white hover:bg-white/10 font-medium">
            浏览实习职位
          </n-button>
        </router-link>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { NButton } from 'naive-ui'
</script>
