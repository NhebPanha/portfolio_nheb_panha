<template>
  <!-- Footer -->
  <footer class="w-full py-12 border-t border-slate-200/10 dark:border-slate-700/50 bg-slate-50 dark:bg-slate-900">
    <div class="flex flex-col md:flex-row justify-between items-center px-4 md:px-8 max-w-7xl mx-auto gap-6">
      <div class="font-headline font-bold text-lg text-slate-900 dark:text-slate-100">
        NHEB
        <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-blue-500 to-pink-500">
          Panha
        </span>
      </div>
      <p class="font-body text-xs tracking-widest uppercase text-slate-500 dark:text-slate-400 text-center md:text-left">
        &copy; 2024 NHEB Panha. All rights reserved.
      </p>
      <div class="flex flex-wrap gap-4 sm:gap-8 justify-center">
        <a v-for="social in socialLinks" :key="social.name" :href="social.href"
          class="font-body text-xs tracking-widest uppercase text-slate-500 dark:text-slate-400 hover:text-pink-400 dark:hover:text-pink-300 transition-transform duration-200 hover:translate-y-[-2px]">
          {{ social.name }}
        </a>
      </div>
    </div>
  </footer>
</template>

<script setup>
const socialLinks = [
  { name: 'Github', href: '#' },
  { name: 'LinkedIn', href: '#' },
  { name: 'Twitter', href: '#' },
  { name: 'Discord', href: '#' },
];</script>