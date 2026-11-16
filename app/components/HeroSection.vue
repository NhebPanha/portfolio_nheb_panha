<template>
  <section id="hero" class="hero relative overflow-hidden pt-32 pb-20 md:pt-40 md:pb-28">
    <!--
      Backdrop: one static layer of plain gradients. No `filter: blur()` and no huge blurred
      element, so nothing expensive has to be repainted while the page scrolls.
    -->
    <div aria-hidden="true" class="hero-backdrop pointer-events-none absolute inset-0 -z-10"></div>

    <div class="container-page grid items-center gap-14 lg:grid-cols-12 lg:gap-10">
      <!-- Intro: each line eases in on first paint with a short stagger (pure CSS, no JS wait). -->
      <div class="lg:col-span-7">
        <p class="hero-in inline-flex items-center gap-2 rounded-full border border-line bg-background px-3 py-1 text-sm text-on-surface-variant" style="--d: 0ms">
          <span class="h-2 w-2 rounded-full bg-emerald-500"></span>
          Available for freelance and full-time roles
        </p>

        <h1 class="hero-in mt-6 text-5xl font-bold tracking-tight text-on-surface sm:text-6xl" style="--d: 60ms">
          Nheb Panha
        </h1>
        <p class="hero-in mt-3 text-xl font-medium text-on-surface-variant sm:text-2xl" style="--d: 120ms">
          Flutter &amp; Full-Stack Developer
        </p>

        <p class="hero-in mt-6 max-w-xl text-base leading-relaxed text-on-surface-variant md:text-lg" style="--d: 180ms">
          I build cross-platform mobile apps and web platforms end to end, from the database
          and APIs to a polished interface. I work mainly with Flutter, Nuxt, Laravel and Supabase,
          and I bring an accounting background to products where data accuracy matters.
        </p>

        <div class="hero-in mt-8 flex flex-wrap items-center gap-3" style="--d: 240ms">
          <a href="#portfolio" class="btn-primary group" @click="(e) => scrollTo('#portfolio', e)">
            View my work
            <span class="material-symbols-outlined text-[18px] transition-transform duration-200 group-hover:translate-x-0.5">arrow_forward</span>
          </a>
          <a href="#contact" class="btn-secondary" @click="(e) => scrollTo('#contact', e)">
            Get in touch
          </a>
          <a href="https://github.com/panhanheb" target="_blank" rel="noopener noreferrer"
             class="btn-secondary !px-3" aria-label="GitHub profile">
            <Icon name="mdi:github" class="text-xl" />
          </a>
        </div>

        <dl class="hero-in mt-12 grid max-w-lg grid-cols-3 gap-6 border-t border-line pt-6" style="--d: 300ms">
          <div v-for="fact in facts" :key="fact.label">
            <dt class="text-xs font-medium uppercase tracking-wider text-on-surface-variant">{{ fact.label }}</dt>
            <dd class="mt-1 text-sm font-semibold text-on-surface">{{ fact.value }}</dd>
          </div>
        </dl>
      </div>

      <!-- Portrait -->
      <div class="hero-in lg:col-span-5" style="--d: 150ms">
        <div class="relative mx-auto max-w-sm lg:ml-auto lg:mr-0">
          <div aria-hidden="true" class="absolute -inset-3 rounded-[28px] border border-line"></div>
          <!-- Fixed aspect box + placeholder color: no layout jump, and the photo fades in once decoded. -->
          <div class="relative aspect-square overflow-hidden rounded-3xl border border-line bg-zinc-900 shadow-xl shadow-black/10">
            <img
              ref="photo"
              src="/image/panha_portrait.jpg"
              alt="Portrait of Nheb Panha"
              width="840"
              height="840"
              fetchpriority="high"
              class="hero-photo h-full w-full object-cover"
              :class="{ 'is-loaded': photoLoaded }"
              @load="photoLoaded = true"
            />
          </div>
          <div class="absolute -bottom-5 left-5 right-5 flex items-center justify-between gap-3 rounded-xl border border-line bg-background px-4 py-3 shadow-lg">
            <div class="flex items-center gap-2 text-sm">
              <span class="material-symbols-outlined text-[18px] text-on-surface-variant">location_on</span>
              <span class="font-medium text-on-surface">Phnom Penh, Cambodia</span>
            </div>
            <span class="font-mono text-xs text-on-surface-variant">UTC+7</span>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'

const facts = [
  { label: 'Focus', value: 'Mobile & Web' },
  { label: 'Building since', value: '2022' },
  { label: 'Core stack', value: 'Flutter · Nuxt' }
]

const photo = ref<HTMLImageElement | null>(null)
const photoLoaded = ref(false)

onMounted(() => {
  // A cached image can finish loading before Vue attaches @load.
  if (photo.value?.complete && photo.value.naturalWidth > 0) photoLoaded.value = true
})

const scrollTo = (href: string, e: Event) => {
  e.preventDefault()
  const target = document.querySelector(href)
  if (!target) return
  window.scrollTo({ top: target.getBoundingClientRect().top + window.scrollY - 72, behavior: 'smooth' })
}
</script>

<style scoped>
.hero {
  /* Keep the hero's painting isolated from the rest of the page. */
  contain: paint;
}

.hero-backdrop {
  background-image:
    radial-gradient(ellipse 60% 55% at 50% -5%, rgb(var(--accent-rgb) / 0.14), transparent 70%),
    linear-gradient(to right, rgb(var(--border-rgb) / 0.55) 1px, transparent 1px),
    linear-gradient(to bottom, rgb(var(--border-rgb) / 0.55) 1px, transparent 1px);
  background-size: 100% 100%, 56px 56px, 56px 56px;
  -webkit-mask-image: radial-gradient(ellipse 75% 65% at 50% 0%, #000 35%, transparent 80%);
  mask-image: radial-gradient(ellipse 75% 65% at 50% 0%, #000 35%, transparent 80%);
}

/* Entrance: opacity + transform only (GPU-friendly), smooth ease-out, staggered via --d. */
.hero-in {
  animation: heroIn 0.7s cubic-bezier(0.22, 1, 0.36, 1) both;
  animation-delay: var(--d, 0ms);
}

@keyframes heroIn {
  from { opacity: 0; transform: translate3d(0, 12px, 0); }
  to   { opacity: 1; transform: none; }
}

.hero-photo {
  opacity: 0;
  transform: scale(1.03);
  transition: opacity 0.6s ease, transform 0.9s cubic-bezier(0.22, 1, 0.36, 1);
}
.hero-photo.is-loaded {
  opacity: 1;
  transform: none;
}
</style>
