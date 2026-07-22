<template>
  <footer class="w-full py-12 border-t border-black/5 dark:border-white/10 bg-black/5 dark:bg-slate-950/60 backdrop-blur-xl relative z-10 font-body">
    <div class="flex flex-col md:flex-row justify-between items-center px-4 md:px-8 max-w-7xl mx-auto gap-6">
      
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-primary via-purple-600 to-cyan-400 p-[1px]">
          <div class="w-full h-full bg-slate-950 rounded-[7px] flex items-center justify-center font-black text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 to-pink-400 text-xs">
            NP
          </div>
        </div>
        <div class="font-headline font-black text-base text-on-surface">
          NHEB
          <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-blue-500 to-pink-500">
            Panha
          </span>
        </div>
      </div>

      <p class="font-body text-[11px] font-bold tracking-widest uppercase text-on-surface-variant/70 text-center md:text-left">
        &copy; 2026 NHEB Panha. Powered by Nuxt 3 & Supabase DB.
      </p>

      <div class="flex flex-wrap gap-4 sm:gap-6 justify-center">
        <a v-for="social in socialLinks" :key="social.name" :href="social.href" target="_blank"
          class="font-body text-xs font-bold tracking-wider uppercase text-on-surface-variant hover:text-cyan-400 transition-all duration-200 hover:-translate-y-0.5">
          {{ social.name }}
        </a>
      </div>

    </div>
  </footer>
</template>

<script setup>
const socialLinks = [
  { name: 'Github', href: 'https://github.com/nhebpanha' },
  { name: 'Telegram', href: 'https://t.me/nhebpanha' },
  { name: 'LinkedIn', href: '#' },
  { name: 'Email', href: 'mailto:samlot.development@gmail.com' },
];
</script>