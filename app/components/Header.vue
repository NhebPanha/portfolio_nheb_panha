<template>
  <!-- TopNavBar -->
  <nav class="fixed top-0 w-full z-50 glass-nav shadow-[0_20px_40px_rgba(0,245,255,0.06)]">
    <div class="flex justify-between items-center max-w-7xl mx-auto px-8 py-4">
      <div class="text-2xl font-black tracking-tighter text-on-surface font-headline">
        Luminous Architect
      </div>

      <div class="hidden md:flex gap-8 items-center">
        <a v-for="link in navLinks" :key="link.name" :href="link.href" :class="[
          'font-headline tracking-tight text-sm uppercase transition-colors',
          link.active ? 'text-cyan-500 border-b-2 border-cyan-500 pb-1' : 'text-slate-600 hover:text-cyan-500'
        ]">
          {{ link.name }}
        </a>
      </div>

      <div class="flex items-center gap-4">
        <div class="flex gap-2">
          <span
            class="material-symbols-outlined text-on-surface-variant hover:text-primary cursor-pointer transition-colors">terminal</span>
          <span
            class="material-symbols-outlined text-on-surface-variant hover:text-primary cursor-pointer transition-colors">code</span>
        </div>
        <button
          class="bg-primary text-on-primary px-6 py-2 font-headline text-sm uppercase tracking-widest rounded-lg hover:bg-primary-dim transition-all active:scale-95">
          Resume
        </button>
      </div>
    </div>
    <!-- Power Rail Accent -->
    <div class="h-[2px] w-full power-rail"></div>
  </nav>

</template>

<script setup>
const navLinks = [
  { name: 'Hero', href: '#', active: true },
  { name: 'About', href: '#' },
  { name: 'Projects', href: '#' },
  { name: 'Experience', href: '#' },
  { name: 'Skills', href: '#' },
  { name: 'Contact', href: '#' }
];
</script>