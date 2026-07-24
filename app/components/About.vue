<template>
  <div id="about" class="bg-background text-on-background font-body relative overflow-hidden transition-colors duration-500">

    <!-- Ambient Glows -->
    <div class="absolute top-0 right-0 w-[550px] h-[550px] bg-primary/5 rounded-full blur-[140px] pointer-events-none"></div>
    <div class="absolute bottom-0 left-0 w-[550px] h-[550px] bg-secondary/5 rounded-full blur-[140px] pointer-events-none"></div>

    <main class="pt-24 md:pt-36 pb-28 px-4 md:px-8 max-w-7xl mx-auto relative z-10" ref="sectionRef">

      <!-- About Me Header -->
      <section class="transition-all duration-1000 ease-out"
               :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">

        <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
          <span class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 text-primary text-[11px] font-bold tracking-[0.35em] uppercase">
            <span class="w-2 h-2 rounded-full bg-primary animate-pulse"></span>
            About Panha
          </span>

          <div class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 text-xs font-medium text-on-surface-variant">
            <span class="material-symbols-outlined text-sm text-cyan-400">location_on</span>
            <span>Phnom Penh, Cambodia</span>
            <span class="opacity-30">|</span>
            <span class="text-emerald-400 font-mono font-bold">UTC+7</span>
          </div>
        </div>

        <h2 class="font-headline text-5xl sm:text-7xl md:text-8xl font-black tracking-tighter leading-[0.85] mb-10">
          Digital <br class="hidden sm:block"/>
          <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-blue-500 to-pink-500">
            Craftsman
          </span>
        </h2>

        <!-- Content Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 items-start">

          <!-- Left Main Story -->
          <div class="lg:col-span-7 space-y-6">

            <!-- Interactive Bio Tabs -->
            <div class="flex gap-2 p-1.5 rounded-2xl bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 backdrop-blur-md mb-6">
              <button v-for="tab in tabs" :key="tab.id" @click="activeTab = tab.id"
                      :class="[
                        'flex-1 py-2.5 px-4 rounded-xl text-xs font-bold uppercase tracking-wider transition-all duration-300',
                        activeTab === tab.id
                          ? 'bg-gradient-to-r from-primary to-purple-600 text-white shadow-lg'
                          : 'text-on-surface-variant hover:text-cyan-400'
                      ]">
                {{ tab.label }}
              </button>
            </div>

            <!-- Tab Content -->
            <div class="glass-panel-elevated p-8 rounded-3xl relative overflow-hidden">

              <Transition name="fade" mode="out-in">
                <!-- Overview -->
                <div v-if="activeTab === 'overview'" key="overview" class="space-y-4">
                  <p class="text-lg md:text-2xl text-on-surface-variant font-light leading-snug">
                    I am a <span class="text-on-surface font-semibold underline decoration-primary decoration-2 underline-offset-4">Full-Stack Architect & Mobile Specialist</span> bridging technical precision with elegant UI execution.
                  </p>
                  <p class="text-base text-on-surface-variant/80 leading-relaxed">
                    My engineering approach blends robust backend data modelling with state-driven client applications. With expertise across Flutter cross-platform mobile development, Nuxt 3 server-side rendering, and Supabase real-time infrastructure, I craft scalable solutions engineered for real-world reliability.
                  </p>
                </div>

                <!-- Architecture Philosophy -->
                <div v-else-if="activeTab === 'philosophy'" key="philosophy" class="space-y-4">
                  <h3 class="text-xl font-bold text-cyan-400">Clean Architecture & Modern Tooling</h3>
                  <p class="text-base text-on-surface-variant/80 leading-relaxed">
                    Every software project requires modular separation of concerns. I build applications utilizing predictable state patterns (BLoC/Riverpod in Flutter, Pinia in Vue), declarative UI schemas, and strict TypeScript types to eliminate runtime errors before deployment.
                  </p>
                  <ul class="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-2 text-xs font-bold uppercase tracking-wider text-on-surface">
                    <li class="flex items-center gap-2">
                      <span class="material-symbols-outlined text-primary text-base">check_circle</span>
                      Decoupled API Adapters
                    </li>
                    <li class="flex items-center gap-2">
                      <span class="material-symbols-outlined text-cyan-400 text-base">check_circle</span>
                      Real-time Database Sync
                    </li>
                    <li class="flex items-center gap-2">
                      <span class="material-symbols-outlined text-pink-400 text-base">check_circle</span>
                      Strict Type Safety
                    </li>
                    <li class="flex items-center gap-2">
                      <span class="material-symbols-outlined text-emerald-400 text-base">check_circle</span>
                      Responsive Glass UI
                    </li>
                  </ul>
                </div>

                <!-- Tech Stack Breakdown -->
                <div v-else key="stack" class="space-y-4">
                  <h3 class="text-xl font-bold text-pink-400">Production-Ready Ecosystem</h3>
                  <p class="text-base text-on-surface-variant/80 leading-relaxed">
                    From mobile client applications to cloud database layers, my primary technology stack handles high-concurrency payloads with maximum maintainability.
                  </p>
                  <div class="flex flex-wrap gap-2 pt-2">
                    <span v-for="tech in coreStack" :key="tech.name"
                          class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-black/5 dark:bg-white/10 border border-black/5 dark:border-white/10 text-xs font-semibold">
                      <Icon :name="tech.icon" class="text-base" />
                      {{ tech.name }}
                    </span>
                  </div>
                </div>
              </Transition>

            </div>

            <!-- Stats Grid -->
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 pt-2">
              <div class="glass-panel p-5 rounded-2xl border border-black/5 dark:border-white/10 text-center">
                <p class="text-primary text-[10px] tracking-[0.25em] font-bold uppercase mb-1">Experience</p>
                <h3 class="text-3xl font-black">02+ Yrs</h3>
                <p class="text-xs text-on-surface-variant mt-1">Full-Stack Dev</p>
              </div>

              <div class="glass-panel p-5 rounded-2xl border border-black/5 dark:border-white/10 text-center">
                <p class="text-secondary text-[10px] tracking-[0.25em] font-bold uppercase mb-1">Ecosystems</p>
                <h3 class="text-3xl font-black">06+</h3>
                <p class="text-xs text-on-surface-variant mt-1">Delivered</p>
              </div>

              <div class="glass-panel p-5 rounded-2xl border border-black/5 dark:border-white/10 text-center">
                <p class="text-cyan-400 text-[10px] tracking-[0.25em] font-bold uppercase mb-1">Database</p>
                <h3 class="text-2xl font-black">Supabase</h3>
                <p class="text-xs text-on-surface-variant mt-1">Real-time DB</p>
              </div>

              <div class="glass-panel p-5 rounded-2xl border border-black/5 dark:border-white/10 text-center">
                <p class="text-emerald-400 text-[10px] tracking-[0.25em] font-bold uppercase mb-1">Status</p>
                <h3 class="text-2xl font-black">Active</h3>
                <p class="text-xs text-on-surface-variant mt-1">Ready for Hire</p>
              </div>
            </div>

          </div>

          <!-- Right Feature Card -->
          <div class="lg:col-span-5">
            <div class="glass-panel border border-black/5 dark:border-white/10 rounded-[2.5rem] p-8 relative overflow-hidden">
              <div class="absolute inset-0 bg-gradient-to-br from-primary/15 via-transparent to-cyan-400/15 pointer-events-none"></div>

              <div class="relative z-10 space-y-6">
                
                <div class="w-16 h-16 rounded-2xl bg-gradient-to-br from-primary to-cyan-400 flex items-center justify-center shadow-xl">
                  <span class="material-symbols-outlined text-white text-3xl">developer_mode</span>
                </div>

                <div>
                  <span class="text-[10px] font-bold tracking-[0.3em] uppercase text-cyan-400 block mb-1">Engineering Profile</span>
                  <h3 class="text-3xl font-black tracking-tight">Nheb Panha</h3>
                </div>

                <p class="text-sm text-on-surface-variant leading-relaxed">
                  Dedicated to crafting exceptional digital products with intuitive interactions, resilient API layers, and pixel-perfect responsiveness across all form factors.
                </p>

                <div class="space-y-3 pt-2">
                  <div class="flex items-center gap-3 p-3 rounded-xl bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/5 text-xs font-semibold">
                    <Icon name="logos:flutter" class="text-xl" />
                    <span>Cross-Platform Flutter & Dart</span>
                  </div>

                  <div class="flex items-center gap-3 p-3 rounded-xl bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/5 text-xs font-semibold">
                    <Icon name="logos:supabase-icon" class="text-xl" />
                    <span>Supabase DB & RLS Security</span>
                  </div>

                  <div class="flex items-center gap-3 p-3 rounded-xl bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/5 text-xs font-semibold">
                    <Icon name="logos:nuxt-icon" class="text-xl" />
                    <span>Nuxt 3 SSR & Vue 3 Architecture</span>
                  </div>

                  <div class="flex items-center gap-3 p-3 rounded-xl bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/5 text-xs font-semibold">
                    <Icon name="logos:laravel" class="text-xl" />
                    <span>Laravel Backend & RESTful APIs</span>
                  </div>
                </div>

              </div>
            </div>
          </div>

        </div>
      </section>

      <!-- Technical Ecosystem Marquee -->
      <div class="mt-20 md:mt-28 relative transition-all duration-1000 delay-300"
           :class="isVisible ? 'opacity-100 scale-100' : 'opacity-0 scale-95'">
        
        <h3 class="text-center text-[11px] font-bold tracking-[0.4em] text-on-surface-variant/60 uppercase mb-8">
          Technology Ecosystem Stack
        </h3>

        <!-- Marquee Row 1 (Left Stream) -->
        <div class="marquee-wrap mb-4 py-2 overflow-hidden relative">
          <div class="marquee-track animate-marquee">
            <div class="flex gap-4 items-center shrink-0 pr-4">
              <div v-for="skill in allSkills" :key="skill.name + '-row1-a'" class="skill-tag">
                <Icon :name="skill.icon" class="text-xl shrink-0" />
                <span class="font-bold text-xs tracking-wider uppercase whitespace-nowrap">{{ skill.name }}</span>
              </div>
            </div>
            <div class="flex gap-4 items-center shrink-0 pr-4" aria-hidden="true">
              <div v-for="skill in allSkills" :key="skill.name + '-row1-b'" class="skill-tag">
                <Icon :name="skill.icon" class="text-xl shrink-0" />
                <span class="font-bold text-xs tracking-wider uppercase whitespace-nowrap">{{ skill.name }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Marquee Row 2 (Right Stream) -->
        <div class="marquee-wrap py-2 overflow-hidden relative">
          <div class="marquee-track animate-marquee-reverse">
            <div class="flex gap-4 items-center shrink-0 pr-4">
              <div v-for="skill in allSkills" :key="skill.name + '-row2-a'" class="skill-tag skill-tag-alt">
                <Icon :name="skill.icon" class="text-xl shrink-0" />
                <span class="font-bold text-xs tracking-wider uppercase whitespace-nowrap">{{ skill.name }}</span>
              </div>
            </div>
            <div class="flex gap-4 items-center shrink-0 pr-4" aria-hidden="true">
              <div v-for="skill in allSkills" :key="skill.name + '-row2-b'" class="skill-tag skill-tag-alt">
                <Icon :name="skill.icon" class="text-xl shrink-0" />
                <span class="font-bold text-xs tracking-wider uppercase whitespace-nowrap">{{ skill.name }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Ambient Side Edge Fades -->
        <div class="absolute inset-y-0 left-0 w-28 bg-gradient-to-r from-background via-background/80 to-transparent z-10 pointer-events-none"></div>
        <div class="absolute inset-y-0 right-0 w-28 bg-gradient-to-l from-background via-background/80 to-transparent z-10 pointer-events-none"></div>
      </div>

    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useScrollAnimate } from '~/composables/useScrollAnimate'

const { sectionRef, isVisible } = useScrollAnimate(0.1)

const activeTab = ref('overview')

const tabs = [
  { id: 'overview', label: 'Overview' },
  { id: 'philosophy', label: 'Philosophy' },
  { id: 'stack', label: 'Tech Stack' }
]

const coreStack = [
  { name: 'Flutter', icon: 'logos:flutter' },
  { name: 'Supabase', icon: 'logos:supabase-icon' },
  { name: 'Nuxt 3', icon: 'logos:nuxt-icon' },
  { name: 'Vue 3', icon: 'logos:vue' },
  { name: 'Laravel', icon: 'logos:laravel' },
  { name: 'PostgreSQL', icon: 'logos:postgresql' },
  { name: 'Tailwind CSS', icon: 'logos:tailwindcss-icon' },
  { name: 'TypeScript', icon: 'logos:typescript-icon' }
]

const allSkills = [
  { name: 'Flutter', icon: 'logos:flutter' },
  { name: 'Supabase', icon: 'logos:supabase-icon' },
  { name: 'Nuxt 3', icon: 'logos:nuxt-icon' },
  { name: 'Vue.js', icon: 'logos:vue' },
  { name: 'Laravel', icon: 'logos:laravel' },
  { name: 'PostgreSQL', icon: 'logos:postgresql' },
  { name: 'Tailwind CSS', icon: 'logos:tailwindcss-icon' },
  { name: 'Dart', icon: 'logos:dart' },
  { name: 'Node.js', icon: 'logos:nodejs-icon' },
  { name: 'Firebase', icon: 'logos:firebase' },
  { name: 'TypeScript', icon: 'logos:typescript-icon' },
  { name: 'Git', icon: 'logos:git-icon' }
]
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(6px);
}

.marquee-wrap {
  overflow: hidden;
  position: relative;
  width: 100%;
  padding: 0.5rem 0;
}

.marquee-track {
  display: flex;
  width: max-content;
  will-change: transform;
}

.animate-marquee {
  animation: scrollLinear 32s linear infinite;
}

.animate-marquee-reverse {
  animation: scrollLinearReverse 36s linear infinite;
}

.marquee-track:hover {
  animation-play-state: paused;
}

.skill-tag {
  flex-shrink: 0;
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1.5rem;
  background-color: var(--glass-bg);
  border: 1px solid var(--glass-border);
  backdrop-filter: blur(12px);
  border-radius: 1rem;
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.skill-tag:hover {
  background: rgba(0, 251, 251, 0.12);
  border-color: var(--accent);
  transform: translateY(-2px);
  box-shadow: 0 10px 25px -5px rgba(0, 251, 251, 0.3);
}

.skill-tag-alt:hover {
  background: rgba(255, 129, 245, 0.12);
  border-color: var(--secondary);
  box-shadow: 0 10px 25px -5px rgba(255, 129, 245, 0.3);
}

@keyframes scrollLinear {
  0% { transform: translate3d(0, 0, 0); }
  100% { transform: translate3d(-50%, 0, 0); }
}

@keyframes scrollLinearReverse {
  0% { transform: translate3d(-50%, 0, 0); }
  100% { transform: translate3d(0, 0, 0); }
}
</style>