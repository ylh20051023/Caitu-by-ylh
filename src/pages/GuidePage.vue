<template>
  <div class="container-content py-8 max-w-3xl mx-auto">
    <h1 class="text-2xl font-bold text-text mb-6">📖 用户指南</h1>
    <n-card>
      <div class="space-y-6">
        <section>
          <h2 class="text-lg font-bold mb-2">🧭 关于财途指南</h2>
          <p class="text-text-secondary">财途指南是一个面向财会专业本科在校生的实习信息聚合与职业导航平台，帮助你找到实习机会、了解职业方向、规划考证路线。</p>
        </section>
        <n-divider />
        <section>
          <h2 class="text-lg font-bold mb-2">💼 浏览实习</h2>
          <p class="text-text-secondary">在「实习广场」页面，你可以按岗位方向、城市、关键词筛选实习岗位，点击岗位卡片查看详情和投递方式。</p>
        </section>
        <n-divider />
        <section>
          <h2 class="text-lg font-bold mb-2">📜 证书查询</h2>
          <p class="text-text-secondary">在「证书查询」页面，你可以浏览14个财会相关证书的详细信息，按「在校可考」「毕业可考」「需工作年限」分类查看。</p>
        </section>
        <n-divider />
        <section>
          <h2 class="text-lg font-bold mb-2">✍️ 发布实习</h2>
          <p class="text-text-secondary">注册登录后，你可以在「发布实习」页面分享你了解的实习信息，提交后等待管理员审核通过即可展示。</p>
        </section>
        <n-divider />
        <section>
          <h2 class="text-lg font-bold mb-2">📰 行业资讯</h2>
          <p class="text-text-secondary">在「行业资讯」页面，你可以浏览最新的财会行业动态，按分类筛选感兴趣的内容。</p>
        </section>
      </div>
    </n-card>
  </div>
</template>

<script setup lang="ts">
import { NCard, NDivider } from 'naive-ui'
</script>
