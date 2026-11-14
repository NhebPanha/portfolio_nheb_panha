<template>
  <footer class="border-t border-line">
    <div class="container-page flex flex-col items-center justify-between gap-4 py-8 text-sm text-on-surface-variant sm:flex-row">
      <p>&copy; {{ year }} Nheb Panha. All rights reserved.</p>
      <ul class="flex items-center gap-5">
        <li v-for="social in socialLinks" :key="social.name">
          <a :href="social.href" target="_blank" rel="noopener noreferrer"
             class="inline-flex items-center gap-1.5 transition-colors hover:text-on-surface">
            <Icon :name="social.icon" class="text-base" />
            {{ social.name }}
          </a>
        </li>
      </ul>
    </div>
  </footer>
</template>

<script setup lang="ts">
const year = new Date().getFullYear()

const socialLinks = [
  { name: 'GitHub', href: 'https://github.com/nhebpanha', icon: 'mdi:github' },
  { name: 'Telegram', href: 'https://t.me/nhebpanha', icon: 'mdi:telegram' },
  { name: 'Email', href: 'mailto:samlot.development@gmail.com', icon: 'mdi:email-outline' }
]
</script>
