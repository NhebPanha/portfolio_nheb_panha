<template>
  <div id="timeline" ref="timelineContainer" class="bg-background text-on-background font-body relative overflow-hidden transition-colors duration-500">
    <div id="experience" class="absolute -top-24"></div>
    <!-- Ambient Glow Backgrounds -->
    <div class="absolute top-1/4 right-0 w-[550px] h-[550px] bg-primary/10 rounded-full blur-[140px] pointer-events-none"></div>
    <div class="absolute bottom-1/4 left-0 w-[550px] h-[550px] bg-cyan-400/10 rounded-full blur-[140px] pointer-events-none"></div>

    <section class="pt-24 md:pt-36 pb-24 md:pb-36 max-w-7xl mx-auto px-4 md:px-8 relative z-10" ref="sectionRef">

      <!-- Header Section -->
      <div class="mb-16 transition-all duration-1000 ease-out"
           :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">
        
        <div class="flex flex-wrap items-center justify-between gap-4 mb-6">
          <span class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 text-primary text-[11px] font-bold tracking-[0.35em] uppercase">
            <span class="w-2 h-2 rounded-full bg-primary animate-pulse"></span>
            Career & Engineering Trajectory
          </span>

          <div class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 text-xs font-mono text-cyan-400">
            <span class="material-symbols-outlined text-sm">timeline</span>
            <span>2022 — Present Chronology</span>
          </div>
        </div>

        <h2 class="font-headline text-4xl sm:text-6xl md:text-7xl font-black tracking-tighter leading-[0.88] mb-6">
          Work <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-purple-500 to-pink-500">Timeline</span> & Milestones
        </h2>

        <p class="text-on-surface-variant/80 text-base md:text-lg max-w-2xl leading-relaxed">
          A chronological breakdown of full-stack engineering roles, production deliveries, architectural achievements, and cross-platform mobile ecosystem developments.
        </p>

        <!-- Category Filters -->
        <div class="flex flex-wrap gap-2.5 mt-8">
          <button v-for="cat in categories" :key="cat.id"
                  @click="activeCategory = cat.id"
                  :class="[
                    'px-4 py-2 rounded-xl text-xs font-bold uppercase tracking-wider transition-all duration-300 flex items-center gap-2',
                    activeCategory === cat.id
                      ? 'bg-gradient-to-r from-primary to-purple-600 text-white shadow-lg shadow-purple-500/20 scale-105'
                      : 'bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 text-on-surface-variant hover:text-cyan-400 hover:bg-black/10 dark:hover:bg-white/10'
                  ]">
            <span class="material-symbols-outlined text-sm">{{ cat.icon }}</span>
            <span>{{ cat.label }}</span>
            <span class="px-2 py-0.5 rounded-md text-[10px] bg-black/10 dark:bg-white/10">{{ getCategoryCount(cat.id) }}</span>
          </button>
        </div>
      </div>

      <!-- Main Timeline Container -->
      <div class="relative">

        <!-- Central Timeline Track Line -->
        <div class="absolute left-4 md:left-1/2 top-0 bottom-0 w-[3px] bg-gradient-to-b from-primary via-cyan-400 to-pink-500 -translate-x-1/2 rounded-full opacity-40"></div>

        <!-- Timeline Items List -->
        <div class="space-y-12 relative">
          <div v-for="(item, index) in filteredTimeline" :key="item.id"
               class="relative flex flex-col md:flex-row items-center transition-all duration-700 ease-out group"
               :class="[
                 isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12',
                 index % 2 === 0 ? 'md:flex-row-reverse' : ''
               ]"
               :style="{ transitionDelay: isVisible ? `${index * 120}ms` : '0ms' }">

            <!-- Node Indicator Bullet -->
            <div class="absolute left-4 md:left-1/2 -translate-x-1/2 top-6 w-9 h-9 rounded-2xl bg-slate-900 border-2 border-cyan-400 z-20 flex items-center justify-center shadow-lg shadow-cyan-400/20 group-hover:scale-125 transition-transform duration-300">
              <span class="material-symbols-outlined text-sm text-cyan-400">{{ item.icon }}</span>
            </div>

            <!-- Content Card (Left or Right) -->
            <div class="w-full md:w-[calc(50%-2.5rem)] pl-12 md:pl-0">
              <div class="glass-panel p-6 sm:p-8 hover:border-cyan-400/50 transition-all duration-500 relative overflow-hidden">
                
                <!-- Glow accent on hover -->
                <div class="absolute -right-12 -top-12 w-32 h-32 bg-primary/10 rounded-full blur-2xl group-hover:bg-cyan-400/20 transition-all duration-500 pointer-events-none"></div>

                <!-- Top Row: Date & Type -->
                <div class="flex flex-wrap items-center justify-between gap-2 mb-4">
                  <div class="flex items-center gap-2">
                    <span class="px-3 py-1 rounded-full text-[11px] font-mono font-bold tracking-wider uppercase bg-primary/10 border border-primary/30 text-cyan-400">
                      {{ item.period }}
                    </span>
                    <span class="px-2.5 py-0.5 rounded-md text-[10px] font-bold uppercase tracking-wider bg-black/5 dark:bg-white/5 text-on-surface-variant">
                      {{ item.type }}
                    </span>
                  </div>

                  <span v-if="item.metric" class="px-2.5 py-1 rounded-lg bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-[10px] font-bold tracking-wider uppercase flex items-center gap-1">
                    <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-ping"></span>
                    {{ item.metric }}
                  </span>
                </div>

                <!-- Role & Company -->
                <h3 class="text-xl sm:text-2xl font-black text-on-surface mb-1 group-hover:text-primary transition-colors">
                  {{ item.role }}
                </h3>

                <div class="flex items-center gap-2 mb-4 text-xs font-bold text-cyan-400">
                  <span class="material-symbols-outlined text-base">business</span>
                  <span>{{ item.company }}</span>
                  <span class="opacity-40">•</span>
                  <span class="text-on-surface-variant font-normal">{{ item.location }}</span>
                </div>

                <!-- Description -->
                <p class="text-xs sm:text-sm text-on-surface-variant/90 leading-relaxed mb-5">
                  {{ item.summary }}
                </p>

                <!-- Expandable Details -->
                <div v-if="expandedItems.includes(item.id)" class="mb-5 p-4 rounded-2xl bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 space-y-3 text-xs">
                  <div class="font-bold text-pink-400 uppercase tracking-widest text-[10px] flex items-center gap-1.5">
                    <span class="material-symbols-outlined text-sm">verified</span>
                    Key Deliverables & Architectural Highlights
                  </div>
                  <ul class="space-y-2">
                    <li v-for="(highlight, hIdx) in item.highlights" :key="hIdx" class="flex items-start gap-2 text-on-surface-variant">
                      <span class="material-symbols-outlined text-xs text-cyan-400 mt-0.5">arrow_right</span>
                      <span>{{ highlight }}</span>
                    </li>
                  </ul>
                </div>

                <!-- Footer: Tech Stack Chips & Expand Toggle -->
                <div class="pt-4 border-t border-black/5 dark:border-white/5 flex flex-wrap items-center justify-between gap-3">
                  <div class="flex flex-wrap gap-1.5">
                    <span v-for="t in item.techStack" :key="t"
                          class="px-2 py-0.5 rounded-md text-[10px] font-bold font-mono uppercase bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 text-on-surface-variant">
                      {{ t }}
                    </span>
                  </div>

                  <button @click="toggleExpand(item.id)"
                          class="inline-flex items-center gap-1 text-[11px] font-bold uppercase tracking-wider text-cyan-400 hover:text-pink-400 transition-colors ml-auto">
                    <span>{{ expandedItems.includes(item.id) ? 'Collapse' : 'Details' }}</span>
                    <span class="material-symbols-outlined text-sm">{{ expandedItems.includes(item.id) ? 'expand_less' : 'expand_more' }}</span>
                  </button>
                </div>

              </div>
            </div>

          </div>
        </div>

      </div>

      <!-- Bottom Milestones Summary Metrics -->
      <div class="mt-20 grid grid-cols-2 md:grid-cols-4 gap-4 sm:gap-6">
        <div v-for="stat in summaryStats" :key="stat.label"
             class="glass-panel p-6 text-center border border-black/5 dark:border-white/10 hover:border-primary/40 transition-all">
          <span class="material-symbols-outlined text-3xl text-cyan-400 mb-2 block">{{ stat.icon }}</span>
          <div class="text-3xl sm:text-4xl font-black text-on-surface mb-1 font-headline">
            {{ stat.value }}
          </div>
          <div class="text-[11px] font-bold uppercase tracking-wider text-on-surface-variant">
            {{ stat.label }}
          </div>
        </div>
      </div>

    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useScrollAnimate } from '~/composables/useScrollAnimate'

const { sectionRef, isVisible } = useScrollAnimate(0.1)

const activeCategory = ref('all')
const expandedItems = ref<number[]>([1]) // Default first item expanded

const toggleExpand = (id: number) => {
  if (expandedItems.value.includes(id)) {
    expandedItems.value = expandedItems.value.filter(i => i !== id)
  } else {
    expandedItems.value.push(id)
  }
}

const categories = [
  { id: 'all', label: 'All Milestones', icon: 'apps' },
  { id: 'mobile', label: 'Mobile & FinTech', icon: 'smartphone' },
  { id: 'web', label: 'Full-Stack Web', icon: 'web' },
  { id: 'backend', label: 'Backend & Cloud', icon: 'dns' }
]

const timelineData = [
  {
    id: 1,
    period: '2025 — Present',
    role: 'Senior Flutter & Supabase Architect',
    company: 'Cross-Platform Mobile Ecosystems',
    location: 'Phnom Penh / Remote',
    type: 'Lead Role',
    category: 'mobile',
    icon: 'smartphone',
    metric: '99.9% Uptime',
    summary: 'Architecting high-performance Flutter mobile applications with real-time Supabase PostgreSQL synchronization, biometric security, BLoC state isolation, and offline cache engines.',
    highlights: [
      'Engineered FinTech mobile wallet application handling real-time WebSocket transaction feeds.',
      'Designed row-level security (RLS) policies in Supabase PostgreSQL database schemas.',
      'Optimized local Hive/Isar caching, reducing initial splash boot time by 38%.'
    ],
    techStack: ['Flutter', 'Dart', 'Supabase', 'PostgreSQL', 'Firebase', 'BLoC']
  },
  {
    id: 2,
    period: '2024 — 2025',
    role: 'Full-Stack Nuxt 3 & Vue Applications Engineer',
    company: 'Enterprise SaaS Solutions',
    location: 'Phnom Penh',
    type: 'Full-Stack',
    category: 'web',
    icon: 'web',
    metric: '98/100 Lighthouse',
    summary: 'Developed modular server-side rendered (SSR) web applications in Nuxt 3 and Vue 3, styling with custom glassmorphism design tokens and integrating payment gateways.',
    highlights: [
      'Constructed responsive SSR web portals serving over 50,000 monthly sessions with sub-second page loads.',
      'Integrated Pinia state management with persisted local storage for seamless user session retention.',
      'Created custom glass CSS design tokens and dark/light dynamic theme engine.'
    ],
    techStack: ['Nuxt 3', 'Vue 3', 'TypeScript', 'Tailwind CSS', 'Pinia', 'REST API']
  },
  {
    id: 3,
    period: '2023 — 2024',
    role: 'Backend Microservices & Database Specialist',
    company: 'Cloud Infrastructure & API Services',
    location: 'Phnom Penh',
    type: 'Backend',
    category: 'backend',
    icon: 'dns',
    metric: '-40% DB Latency',
    summary: 'Engineered RESTful API backend engines in Laravel and Node.js with database indexing, background queue jobs, and real-time automated Telegram alert telemetry.',
    highlights: [
      'Built financial accounting API endpoints processing high daily transaction volume securely within atomic transactions.',
      'Optimized complex SQL queries and compound indexing strategies, cutting DB response latency by 40%.',
      'Integrated automated Telegram bot triggers for immediate production error alerting.'
    ],
    techStack: ['Laravel', 'Node.js', 'MySQL', 'PostgreSQL', 'Redis', 'Telegram API']
  },
  {
    id: 4,
    period: '2022 — 2023',
    role: 'Junior Mobile & Web Developer',
    company: 'Digital Product Innovation Lab',
    location: 'Phnom Penh',
    type: 'Developer',
    category: 'mobile',
    icon: 'code',
    metric: 'CI/CD Pipeline',
    summary: 'Created cross-platform UI components matching high-fidelity Figma mockups and established continuous integration GitHub Actions workflows.',
    highlights: [
      'Built 15+ reusable mobile UI widget packages following strict material & glass design patterns.',
      'Automated multi-platform builds using GitHub Actions CI/CD pipelines.'
    ],
    techStack: ['Flutter', 'JavaScript', 'HTML5/CSS3', 'Git', 'GitHub Actions', 'Figma']
  }
]

const getCategoryCount = (catId: string) => {
  if (catId === 'all') return timelineData.length
  return timelineData.filter(item => item.category === catId).length
}

const filteredTimeline = computed(() => {
  if (activeCategory.value === 'all') return timelineData
  return timelineData.filter(item => item.category === activeCategory.value)
})

const summaryStats = [
  { label: 'Years Experience', value: '02+', icon: 'schedule' },
  { label: 'Apps & Systems', value: '08+', icon: 'apps' },
  { label: 'DB Query Latency', value: '<50ms', icon: 'speed' },
  { label: 'Code Quality', value: '99.8%', icon: 'verified' }
]
</script>
