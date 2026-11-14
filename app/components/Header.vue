<template>
  <header
    class="fixed inset-x-0 top-0 z-50 transition-[background-color,border-color] duration-300"
    :class="scrolled || isMenuOpen
      ? 'border-b border-line bg-background/85 backdrop-blur-md'
      : 'border-b border-transparent bg-transparent'"
  >
    <nav class="container-page flex h-16 items-center justify-between" aria-label="Main">
      <!-- Logo -->
      <a href="#hero" class="flex items-center gap-2.5" @click="(e) => scrollToSection(e, '#hero')">
        <img src="/logo_test.png" alt="" class="h-8 w-8 rounded-lg bg-zinc-900 object-contain p-1 ring-1 ring-line" />
        <span class="text-[15px] font-semibold tracking-tight text-on-surface">Nheb Panha</span>
      </a>

      <!-- Desktop links -->
      <ul class="hidden items-center gap-1 lg:flex">
        <li v-for="link in navLinks" :key="link.href">
          <a
            :href="link.href"
            class="rounded-md px-3 py-2 text-sm font-medium transition-colors"
            :class="activeHref === link.href ? 'text-on-surface' : 'text-on-surface-variant hover:text-on-surface'"
            :aria-current="activeHref === link.href ? 'true' : undefined"
            @click="(e) => scrollToSection(e, link.href)"
          >
            {{ link.name }}
          </a>
        </li>
      </ul>

      <!-- Actions -->
      <div class="flex items-center gap-2">
        <button
          class="flex h-9 w-9 items-center justify-center rounded-lg border border-line text-on-surface-variant transition-colors hover:text-on-surface"
          :aria-label="isDark ? 'Switch to light theme' : 'Switch to dark theme'"
          @click="toggleDark"
        >
          <span class="material-symbols-outlined text-[20px]">{{ isDark ? 'light_mode' : 'dark_mode' }}</span>
        </button>

        <a href="#contact" class="btn-primary hidden !px-4 !py-2 sm:inline-flex" @click="(e) => scrollToSection(e, '#contact')">
          Contact me
        </a>

        <button
          class="flex h-9 w-9 items-center justify-center rounded-lg border border-line text-on-surface lg:hidden"
          :aria-expanded="isMenuOpen"
          aria-controls="mobile-menu"
          aria-label="Toggle navigation menu"
          @click="isMenuOpen = !isMenuOpen"
        >
          <span class="material-symbols-outlined text-[20px]">{{ isMenuOpen ? 'close' : 'menu' }}</span>
        </button>
      </div>
    </nav>

    <!-- Mobile menu -->
    <Transition name="drawer">
      <div v-show="isMenuOpen" id="mobile-menu" class="border-t border-line bg-background lg:hidden">
        <ul class="container-page flex flex-col py-3">
          <li v-for="link in navLinks" :key="link.href">
            <a
              :href="link.href"
              class="block rounded-md px-2 py-3 text-base font-medium"
              :class="activeHref === link.href ? 'text-primary' : 'text-on-surface'"
              @click="(e) => scrollToSection(e, link.href)"
            >
              {{ link.name }}
            </a>
          </li>
          <li class="pt-2">
            <a href="#contact" class="btn-primary w-full" @click="(e) => scrollToSection(e, '#contact')">Contact me</a>
          </li>
        </ul>
      </div>
    </Transition>
  </header>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const navLinks = [
  { name: 'About', href: '#about' },
  { name: 'Experience', href: '#timeline' },
  { name: 'Projects', href: '#portfolio' },
  { name: 'Skills', href: '#skills' },
  { name: 'Writing', href: '#blog' },
  { name: 'Contact', href: '#contact' }
]

const isMenuOpen = ref(false)
const scrolled = ref(false)
const activeHref = ref('')
const isDark = ref(false)

const scrollToSection = (e: Event, href: string) => {
  e.preventDefault()
  isMenuOpen.value = false
  const target = document.querySelector(href)
  if (!target) return
  const y = target.getBoundingClientRect().top + window.scrollY - 72
  window.scrollTo({ top: y, behavior: 'smooth' })
  history.replaceState(null, '', href)
}

// Section positions are measured once (and again on resize), not on every scroll event,
// so scrolling never forces the browser to recalculate layout.
let sectionTops: { href: string; top: number }[] = []
let docHeight = 0
const measure = () => {
  sectionTops = navLinks
    .map(link => {
      const el = document.querySelector<HTMLElement>(link.href)
      return el ? { href: link.href, top: el.getBoundingClientRect().top + window.scrollY } : null
    })
    .filter((s): s is { href: string; top: number } => s !== null)
  docHeight = document.documentElement.scrollHeight
}

const update = () => {
  const y = window.scrollY
  const isScrolled = y > 8
  if (scrolled.value !== isScrolled) scrolled.value = isScrolled

  let current = ''
  for (const s of sectionTops) if (s.top <= y + 140) current = s.href
  if (window.innerHeight + y >= docHeight - 40 && sectionTops.length) {
    current = sectionTops[sectionTops.length - 1]!.href
  }
  if (activeHref.value !== current) activeHref.value = current
}

// At most one update per animation frame.
let ticking = false
const handleScroll = () => {
  if (ticking) return
  ticking = true
  requestAnimationFrame(() => {
    update()
    ticking = false
  })
}

let resizeObserver: ResizeObserver | null = null

const toggleDark = () => {
  isDark.value = !isDark.value
  document.documentElement.classList.toggle('dark', isDark.value)
  try { localStorage.setItem('theme', isDark.value ? 'dark' : 'light') } catch {}
}

onMounted(() => {
  // The theme class was already applied by the inline script in nuxt.config.ts.
  isDark.value = document.documentElement.classList.contains('dark')
  window.addEventListener('scroll', handleScroll, { passive: true })
  // Re-measure whenever the page height changes (projects/blog load async, fonts, resize).
  resizeObserver = new ResizeObserver(() => {
    measure()
    update()
  })
  resizeObserver.observe(document.body)
  measure()
  update()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  resizeObserver?.disconnect()
})
</script>

<style scoped>
.drawer-enter-active,
.drawer-leave-active {
  transition: opacity 0.2s ease, transform 0.2s ease;
}
.drawer-enter-from,
.drawer-leave-to {
  opacity: 0;
  transform: translateY(-6px);
}
</style>
