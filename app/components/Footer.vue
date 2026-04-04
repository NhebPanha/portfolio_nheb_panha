<template>
  <!-- Footer -->
  <footer class="w-full py-12 border-t border-slate-200/10 bg-slate-50">
    <div class="flex flex-col md:flex-row justify-between items-center px-8 max-w-7xl mx-auto gap-6">
      <div class="font-headline font-bold text-lg text-on-surface">
        Luminous Architect
      </div>
      <p class="font-body text-xs tracking-widest uppercase text-slate-500">
        © 2024 Luminous Architect. Built with Ethical Futurism.
      </p>
      <div class="flex gap-8">
        <a v-for="social in socialLinks" :key="social.name" :href="social.href"
          class="font-body text-xs tracking-widest uppercase text-slate-500 hover:text-pink-400 transition-transform duration-200 hover:translate-y-[-2px]">
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