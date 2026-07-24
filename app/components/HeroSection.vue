<template>
  <div id="hero" class="bg-background text-on-background font-body min-h-screen transition-colors duration-500 relative overflow-hidden">
    <!-- Hero Section -->
    <main class="relative min-h-screen flex items-center pt-28 pb-16 bg-grid-pattern" ref="sectionRef">
      
      <!-- Ambient Glow Layers -->
      <div class="absolute inset-0 overflow-hidden pointer-events-none">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
        <div class="blob blob-3"></div>
      </div>
      <div class="particles"></div>

      <!-- Main Content Container -->
      <div class="max-w-7xl mx-auto px-4 md:px-8 w-full grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-8 items-center relative z-10">

        <!-- Hero Content (Left) -->
        <div class="lg:col-span-7 transition-all duration-1000 ease-out"
             :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">
          
          <!-- Availability & Version Tag -->
          <div class="flex flex-wrap items-center gap-3 mb-6">
            <div class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-emerald-500/10 border border-emerald-500/30 text-emerald-600 dark:text-emerald-400 text-xs font-bold tracking-widest uppercase backdrop-blur-md">
              <span class="relative flex h-2 w-2">
                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                <span class="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
              </span>
              Available for Freelance & Full-time
            </div>

            <div class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 text-on-surface-variant text-[11px] font-mono tracking-wider">
              <span class="text-primary font-bold">v3.0</span>
              <span class="opacity-40">|</span>
              <span>Supabase Edition</span>
            </div>
          </div>

          <!-- Main Headline -->
          <h1 class="text-5xl sm:text-7xl lg:text-8xl font-black leading-[0.9] tracking-tighter mb-6">
            NHEB
            <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-blue-500 to-pink-500 glow-text-cyan">
              Panha
            </span>
          </h1>

          <!-- Role Subtitle -->
          <div class="flex items-center gap-4 mb-6">
            <div class="h-[2px] w-12 bg-gradient-to-r from-primary to-cyan-400"></div>
            <p class="text-lg md:text-xl font-bold uppercase tracking-wide text-on-surface-variant">
              Flutter Architect <span class="text-secondary mx-1.5">/</span> Full-Stack Developer
            </p>
          </div>

          <!-- Bio Pitch -->
          <p class="text-base md:text-lg max-w-xl mb-8 leading-relaxed text-on-surface-variant/90 font-normal">
            Engineering high-precision mobile applications and cloud backends. Specializing in <span class="text-cyan-400 font-semibold">Flutter</span>, <span class="text-purple-400 font-semibold">Nuxt 3</span>, <span class="text-pink-400 font-semibold">Laravel</span>, and <span class="text-emerald-400 font-semibold">Supabase</span> real-time data engines.
          </p>

          <!-- Metric Cards Bar -->
          <div class="grid grid-cols-3 gap-3 md:gap-4 max-w-lg mb-10">
            <div class="p-3.5 rounded-2xl bg-black/5 dark:bg-white/[0.03] border border-black/5 dark:border-white/10 backdrop-blur-md hover:border-primary/40 transition-all">
              <div class="text-2xl md:text-3xl font-black text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 to-blue-500">06+</div>
              <div class="text-[10px] md:text-xs font-bold uppercase tracking-wider text-on-surface-variant mt-0.5">Ecosystems</div>
            </div>

            <div class="p-3.5 rounded-2xl bg-black/5 dark:bg-white/[0.03] border border-black/5 dark:border-white/10 backdrop-blur-md hover:border-primary/40 transition-all">
              <div class="text-2xl md:text-3xl font-black text-transparent bg-clip-text bg-gradient-to-r from-purple-400 to-pink-500">99.9%</div>
              <div class="text-[10px] md:text-xs font-bold uppercase tracking-wider text-on-surface-variant mt-0.5">DB Uptime</div>
            </div>

            <div class="p-3.5 rounded-2xl bg-black/5 dark:bg-white/[0.03] border border-black/5 dark:border-white/10 backdrop-blur-md hover:border-primary/40 transition-all">
              <div class="text-2xl md:text-3xl font-black text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 to-cyan-400">100%</div>
              <div class="text-[10px] md:text-xs font-bold uppercase tracking-wider text-on-surface-variant mt-0.5">Clean Code</div>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="flex flex-wrap items-center gap-4">
            <a href="#portfolio" @click="(e) => scrollTo('#portfolio', e)"
               class="px-8 py-4 rounded-xl bg-gradient-to-r from-primary via-purple-600 to-pink-500 text-white font-bold text-xs uppercase tracking-widest hover:shadow-[0_0_30px_rgba(129,28,217,0.6)] hover:-translate-y-1 transition-all active:scale-95 flex items-center gap-2">
              <span>View Ecosystems</span>
              <span class="material-symbols-outlined text-sm">north_east</span>
            </a>

            <a href="#contact" @click="(e) => scrollTo('#contact', e)"
               class="px-8 py-4 rounded-xl bg-black/5 dark:bg-white/5 border border-cyan-400/40 text-cyan-400 font-bold text-xs uppercase tracking-widest hover:bg-cyan-400/10 hover:-translate-y-1 transition-all active:scale-95 flex items-center gap-2">
              <span>Let's Talk</span>
              <span class="material-symbols-outlined text-sm">chat</span>
            </a>
          </div>

        </div>

        <!-- Profile / Graphic (Right) -->
        <div class="lg:col-span-5 relative flex justify-center lg:justify-end mt-8 lg:mt-0 transition-all duration-1000 ease-out delay-300"
             :class="isVisible ? 'opacity-100 translate-x-0' : 'opacity-0 translate-x-12'">
          
          <div class="relative w-72 h-72 sm:w-96 sm:h-96 lg:w-[420px] lg:h-[420px]">
            
            <!-- Animated Glowing Rings -->
            <div class="ring ring-1"></div>
            <div class="ring ring-2"></div>
            <div class="ring ring-3"></div>

            <!-- Floating Tech Badges -->
            <div class="floating-badge top-left">
              <Icon name="logos:flutter" class="text-lg" />
              <span>Flutter Lead</span>
            </div>

            <div class="floating-badge top-right">
              <Icon name="logos:supabase-icon" class="text-lg" />
              <span>Supabase DB</span>
            </div>

            <div class="floating-badge bottom-left">
              <Icon name="logos:nuxt-icon" class="text-lg" />
              <span>Nuxt 3 SSR</span>
            </div>

            <div class="floating-badge bottom-right">
              <Icon name="logos:laravel" class="text-lg" />
              <span>REST APIs</span>
            </div>

            <!-- Central Profile Container -->
            <div class="w-full h-full rounded-full p-2.5 bg-gradient-to-br from-primary via-cyan-400 to-pink-500 shadow-[0_0_60px_rgba(129,28,217,0.35)] relative z-10">
              <div class="w-full h-full rounded-full overflow-hidden border-4 border-slate-950 bg-slate-900 relative group">
                <img src="/image/panha_profile.png" alt="Nheb Panha" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700" />
                <div class="absolute inset-0 bg-gradient-to-t from-slate-950/80 via-transparent to-transparent opacity-60 group-hover:opacity-30 transition-opacity"></div>
              </div>
            </div>

          </div>

        </div>

      </div>

      <!-- Infinite Marquee Ticker -->
      <div class="absolute bottom-0 left-0 w-full overflow-hidden bg-black/40 dark:bg-black/60 backdrop-blur-xl border-t border-black/5 dark:border-white/10 py-3.5 z-20">
        <div class="marquee-container flex whitespace-nowrap">
          <div class="marquee-content flex gap-8 md:gap-14 items-center px-6">
            <span v-for="skill in skills" :key="skill.name" class="text-xs font-bold tracking-[0.2em] uppercase text-on-surface-variant/80 hover:text-cyan-400 transition-colors flex items-center gap-2.5">
              <Icon :name="skill.icon" class="text-lg" />
              {{ skill.name }}
            </span>
          </div>
          <!-- Duplicate for loop -->
          <div class="marquee-content flex gap-8 md:gap-14 items-center px-6" aria-hidden="true">
            <span v-for="skill in skills" :key="skill.name + '-dup'" class="text-xs font-bold tracking-[0.2em] uppercase text-on-surface-variant/80 hover:text-cyan-400 transition-colors flex items-center gap-2.5">
              <Icon :name="skill.icon" class="text-lg" />
              {{ skill.name }}
            </span>
          </div>
        </div>
      </div>

    </main>
  </div>
</template>

<script setup>
import { useScrollAnimate } from '~/composables/useScrollAnimate'

const { sectionRef, isVisible } = useScrollAnimate(0.1)

const skills = [
  { name: 'Flutter', icon: 'logos:flutter' },
  { name: 'Supabase', icon: 'logos:supabase-icon' },
  { name: 'Nuxt.js', icon: 'logos:nuxt-icon' },
  { name: 'Vue.js', icon: 'logos:vue' },
  { name: 'Laravel', icon: 'logos:laravel' },
  { name: 'Tailwind CSS', icon: 'logos:tailwindcss-icon' },
  { name: 'Firebase', icon: 'logos:firebase' },
  { name: 'Dart', icon: 'logos:dart' },
  { name: 'PostgreSQL', icon: 'logos:postgresql' },
  { name: 'TypeScript', icon: 'logos:typescript-icon' },
  { name: 'Node.js', icon: 'logos:nodejs-icon' }
]

const scrollTo = (href, e) => {
  e.preventDefault()
  const target = document.querySelector(href)
  if (target) {
    const yOffset = -90
    const y = target.getBoundingClientRect().top + window.pageYOffset + yOffset
    window.scrollTo({ top: y, behavior: 'smooth' })
  }
}
</script>

<style scoped>
/* ================= BLOBS ================= */
.blob {
  position: absolute;
  border-radius: 50%;
  filter: blur(140px);
  opacity: 0.35;
  animation: floatBlob 14s infinite ease-in-out alternate;
}

.blob-1 {
  width: 450px;
  height: 450px;
  background: #811cd9;
  top: -10%;
  right: -5%;
}

.blob-2 {
  width: 400px;
  height: 400px;
  background: #00fbfb;
  bottom: 0%;
  left: -5%;
  animation-delay: 4s;
}

.blob-3 {
  width: 350px;
  height: 350px;
  background: #ff81f5;
  top: 40%;
  right: 30%;
  animation-delay: 8s;
}

@keyframes floatBlob {
  0% { transform: translate(0, 0) scale(1); }
  100% { transform: translate(-50px, 50px) scale(1.15); }
}

/* ================= RINGS ================= */
.ring {
  position: absolute;
  border-radius: 50%;
  border: 1px solid rgba(129, 28, 217, 0.25);
  animation: ringPulse 4s infinite ease-in-out;
  pointer-events: none;
}

.ring-1 { inset: -15px; border-color: rgba(129, 28, 217, 0.3); }
.ring-2 { inset: -35px; border-color: rgba(0, 251, 251, 0.25); animation-delay: 1.2s; }
.ring-3 { inset: -55px; border-color: rgba(255, 129, 245, 0.2); animation-delay: 2.4s; }

@keyframes ringPulse {
  0%, 100% { transform: scale(1); opacity: 0.5; }
  50% { transform: scale(1.04); opacity: 0.9; }
}

/* ================= FLOATING BADGES ================= */
.floating-badge {
  position: absolute;
  z-index: 20;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 0.85rem;
  background: rgba(15, 23, 42, 0.75);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 9999px;
  font-size: 11px;
  font-weight: 700;
  color: #fff;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.4);
  animation: floatBadge 6s ease-in-out infinite alternate;
}

.top-left { top: 5%; left: -10px; border-left: 3px solid #811cd9; }
.top-right { top: 12%; right: -15px; border-left: 3px solid #10b981; animation-delay: 1.5s; }
.bottom-left { bottom: 15%; left: -15px; border-left: 3px solid #00fbfb; animation-delay: 3s; }
.bottom-right { bottom: 5%; right: -10px; border-left: 3px solid #ff81f5; animation-delay: 4.5s; }

@keyframes floatBadge {
  0% { transform: translateY(0); }
  100% { transform: translateY(-8px); }
}

/* ================= MARQUEE ================= */
.marquee-container {
  display: flex;
  width: max-content;
  will-change: transform;
  animation: scrollMarquee 35s linear infinite;
}

.marquee-container:hover {
  animation-play-state: paused;
}

@keyframes scrollMarquee {
  0% { transform: translate3d(0, 0, 0); }
  100% { transform: translate3d(-50%, 0, 0); }
}
</style>