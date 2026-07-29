<template>
  <nav class="fixed top-0 w-full z-50 glass-nav shadow-[0_10px_30px_rgba(0,251,251,0.05)] transition-all duration-300">
    <div class="flex justify-between items-center max-w-7xl mx-auto px-4 md:px-8 py-2">

      <!-- Logo -->
      <a href="#hero" @click="(e) => scrollToSection(e, '#hero')" class="flex items-center gap-2.5 group">
        <img src="/logo_test.png" alt="NHEB Panha logo"
             class="w-8 h-8 rounded-lg object-contain group-hover:scale-105 transition-transform duration-300" />
        <div class="text-base md:text-lg font-black tracking-tighter text-on-surface font-headline">
          NHEB
          <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-blue-500 to-pink-500">
            Panha
          </span>
        </div>
      </a>

      <!-- Desktop Nav Links -->
      <div class="hidden xl:flex items-center gap-1 p-1 rounded-full bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 backdrop-blur-md">
        <a v-for="link in navLinks" :key="link.name" :href="link.href" @click="(e) => scrollToSection(e, link.href)"
          :class="[
            'font-headline tracking-tight text-[11px] font-bold uppercase transition-all duration-300 px-3 py-1 rounded-full',
            link.active
              ? 'bg-gradient-to-r from-primary to-purple-600 text-white shadow-sm'
              : 'text-slate-600 dark:text-slate-300 hover:text-cyan-500 hover:bg-black/5 dark:hover:bg-white/5'
          ]">
          {{ link.name }}
        </a>
      </div>

      <!-- Right Actions & Supabase Indicator -->
      <div class="flex items-center gap-2">
        <!-- Supabase Live Connection Pill -->
        <div class="hidden sm:flex items-center gap-1.5 px-2.5 py-1 rounded-full border text-[10px] font-bold tracking-wider uppercase backdrop-blur-md transition-all"
             :class="isConfigured ? 'bg-emerald-500/10 border-emerald-500/30 text-emerald-600 dark:text-emerald-400' : 'bg-cyan-500/10 border-cyan-500/30 text-cyan-600 dark:text-cyan-400'">
          <span class="relative flex h-1.5 w-1.5">
            <span class="animate-ping absolute inline-flex h-full w-full rounded-full opacity-75"
                  :class="isConfigured ? 'bg-emerald-400' : 'bg-cyan-400'"></span>
            <span class="relative inline-flex rounded-full h-1.5 w-1.5"
                  :class="isConfigured ? 'bg-emerald-500' : 'bg-cyan-500'"></span>
          </span>
          <span class="hidden md:inline">{{ isConfigured ? 'Supabase Sync' : 'Supabase Live' }}</span>
        </div>

        <!-- 🌙 Dark Mode Toggle -->
        <button @click="toggleDark" 
                class="w-8 h-8 rounded-lg bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 flex items-center justify-center text-slate-700 dark:text-slate-200 hover:text-cyan-400 hover:border-cyan-500/40 transition-all duration-300"
                aria-label="Toggle Theme">
          <span class="material-symbols-outlined text-lg">
            {{ isDark ? 'light_mode' : 'dark_mode' }}
          </span>
        </button>

        <!-- Resume CTA Button -->
        <a href="#contact" @click="(e) => scrollToSection(e, '#contact')"
          class="hidden sm:inline-flex items-center gap-1.5 bg-gradient-to-r from-primary via-purple-600 to-pink-500 text-white px-3.5 py-1.5 font-headline text-[11px] font-bold uppercase tracking-widest rounded-lg hover:shadow-[0_0_15px_rgba(129,28,217,0.5)] transition-all active:scale-95">
          <span>Hire Me</span>
          <span class="material-symbols-outlined text-xs">arrow_forward</span>
        </a>

        <!-- Mobile Menu Toggle -->
        <button @click="toggleMenu" 
                class="xl:hidden w-8 h-8 rounded-lg bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 flex items-center justify-center text-slate-700 dark:text-slate-200 hover:text-cyan-400 transition-all"
                aria-label="Toggle Navigation Menu">
          <span class="material-symbols-outlined text-xl">
            {{ isMenuOpen ? 'close' : 'menu' }}
          </span>
        </button>
      </div>
    </div>

    <!-- Mobile Navigation Drawer -->
    <Transition name="drawer">
      <div v-show="isMenuOpen"
        class="xl:hidden glass-nav border-t border-black/5 dark:border-white/10 absolute w-full left-0 top-full flex flex-col px-6 py-6 gap-3 shadow-2xl backdrop-blur-2xl">
        
        <div class="flex items-center justify-between pb-3 border-b border-black/5 dark:border-white/5 mb-1">
          <span class="text-[10px] uppercase font-bold tracking-widest text-slate-500 dark:text-slate-400">Navigation</span>
          <div class="flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-[10px] font-bold text-emerald-400 uppercase">
            <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
            {{ isConfigured ? 'Supabase Connected' : 'Supabase Ready' }}
          </div>
        </div>

        <a v-for="link in navLinks" :key="link.name" :href="link.href" @click="(e) => scrollToSection(e, link.href)"
          :class="[
            'font-headline tracking-tight text-sm font-bold uppercase transition-all px-4 py-3 rounded-xl flex justify-between items-center',
            link.active
              ? 'bg-gradient-to-r from-primary to-purple-600 text-white shadow-md'
              : 'text-slate-700 dark:text-slate-200 hover:bg-black/5 dark:hover:bg-white/5'
          ]">
          <span>{{ link.name }}</span>
          <span class="material-symbols-outlined text-sm opacity-60">chevron_right</span>
        </a>

        <a href="#contact" @click="(e) => scrollToSection(e, '#contact')"
           class="mt-2 w-full py-3.5 bg-gradient-to-r from-primary to-pink-500 text-white font-bold text-center text-xs uppercase tracking-widest rounded-xl shadow-lg flex items-center justify-center gap-2">
          <span>Get in Touch</span>
          <span class="material-symbols-outlined text-sm">send</span>
        </a>
      </div>
    </Transition>

    <!-- Power Rail Accent -->
    <div class="h-[2px] w-full power-rail"></div>
  </nav>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const { isConfigured } = useSupabase()

const isMenuOpen = ref(false)
const toggleMenu = () => {
  isMenuOpen.value = !isMenuOpen.value
}

const navLinks = ref([
  { name: 'About', href: '#about', active: true },
  { name: 'Projects', href: '#portfolio', active: false },
  { name: 'Skills', href: '#skills', active: false },
  { name: 'Tech Stack', href: '#techstack', active: false },
  { name: 'Timeline', href: '#timeline', active: false },
  { name: 'Articles', href: '#blog', active: false },
  { name: 'Contact', href: '#contact', active: false }
]);

const scrollToSection = (e, href) => {
  e.preventDefault();
  isMenuOpen.value = false;

  if (!href || href === '#') return;

  const target = document.querySelector(href);
  if (target) {
    const yOffset = -90;
    const y = target.getBoundingClientRect().top + window.pageYOffset + yOffset;
    window.scrollTo({ top: y, behavior: 'smooth' });
  }
}

const handleScroll = () => {
  const scrollPosition = window.scrollY + 180;

  const sections = navLinks.value
    .map(link => {
      const el = document.querySelector(link.href);
      return { href: link.href, offsetTop: el ? el.offsetTop : -1 };
    })
    .filter(item => item.offsetTop !== -1)
    .sort((a, b) => a.offsetTop - b.offsetTop);

  let currentSection = navLinks.value[0].href;

  for (const section of sections) {
    if (section.offsetTop <= scrollPosition) {
      currentSection = section.href;
    }
  }

  if (window.innerHeight + window.scrollY >= document.documentElement.scrollHeight - 60) {
    if (sections.length > 0) {
      currentSection = sections[sections.length - 1].href;
    }
  }

  navLinks.value.forEach(link => {
    link.active = link.href === currentSection;
  });
}

const isDark = ref(false)
const toggleDark = () => {
  isDark.value = !isDark.value
  document.documentElement.classList.toggle('dark')
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme) {
    isDark.value = savedTheme === 'dark'
  } else {
    isDark.value = window.matchMedia('(prefers-color-scheme: dark)').matches
  }

  document.documentElement.classList.toggle('dark', isDark.value)
  window.addEventListener('scroll', handleScroll)
  setTimeout(handleScroll, 100)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
.drawer-enter-active,
.drawer-leave-active {
  transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);
}

.drawer-enter-from,
.drawer-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>