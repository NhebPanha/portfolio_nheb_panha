<template>
  <div id="techstack" class="bg-background text-on-background font-body relative overflow-hidden transition-colors duration-500">
    <!-- Ambient Glows -->
    <div class="absolute top-0 right-1/4 w-[600px] h-[600px] bg-cyan-400/5 rounded-full blur-[150px] pointer-events-none"></div>
    <div class="absolute bottom-0 left-1/4 w-[600px] h-[600px] bg-primary/5 rounded-full blur-[150px] pointer-events-none"></div>

    <section class="pt-24 md:pt-36 pb-24 md:pb-36 max-w-7xl mx-auto px-4 md:px-8 relative z-10" ref="sectionRef">

      <!-- Header Section -->
      <div class="mb-16 transition-all duration-1000 ease-out"
           :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">
        
        <div class="flex flex-wrap items-center justify-between gap-4 mb-6">
          <span class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 text-cyan-400 text-[11px] font-bold tracking-[0.35em] uppercase">
            <span class="w-2 h-2 rounded-full bg-cyan-400 animate-pulse"></span>
            Tech Stack Matrix
          </span>

          <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 text-xs font-mono text-pink-400">
            <span class="material-symbols-outlined text-sm">memory</span>
            <span>Production Tooling</span>
          </div>
        </div>

        <h2 class="font-headline text-4xl sm:text-6xl md:text-7xl font-black tracking-tighter leading-[0.88] mb-6">
          Technical <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-purple-500 to-pink-500">Ecosystem</span> & Tooling
        </h2>

        <p class="text-on-surface-variant/80 text-base md:text-lg max-w-2xl leading-relaxed">
          Production-proven mastery across mobile frameworks, cloud data platforms, serverless backends, and UI architectural patterns.
        </p>

        <!-- Search Bar & Category Filter Controls -->
        <div class="mt-8 flex flex-col md:flex-row items-stretch md:items-center justify-between gap-4">
          
          <!-- Category Tabs -->
          <div class="flex flex-wrap gap-2">
            <button v-for="cat in categories" :key="cat.id"
                    @click="activeCategory = cat.id"
                    :class="[
                      'px-4 py-2 rounded-xl text-xs font-bold uppercase tracking-wider transition-all duration-300 flex items-center gap-2',
                      activeCategory === cat.id
                        ? 'bg-gradient-to-r from-cyan-500 via-blue-600 to-primary text-white shadow-lg shadow-cyan-500/20 scale-105'
                        : 'bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 text-on-surface-variant hover:text-cyan-400 hover:bg-black/10 dark:hover:bg-white/10'
                    ]">
              <span class="material-symbols-outlined text-sm">{{ cat.icon }}</span>
              <span>{{ cat.label }}</span>
            </button>
          </div>

          <!-- Search Input Box -->
          <div class="relative w-full md:w-72">
            <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-on-surface-variant text-lg">search</span>
            <input v-model="searchQuery"
                   placeholder="Filter stack (e.g. Flutter, Nuxt)..."
                   class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 text-xs text-on-surface placeholder:text-on-surface-variant/50 focus:outline-none focus:border-cyan-400 transition-all" />
          </div>

        </div>
      </div>

      <!-- Tech Stack Cards Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-20">
        <div v-for="(tech, index) in filteredTechStack" :key="tech.name"
             class="group relative p-7 rounded-[2rem] bg-white/40 dark:bg-white/[0.02] border border-black/5 dark:border-white/10 hover:border-cyan-400/50 transition-all duration-500 flex flex-col justify-between overflow-hidden"
             :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'"
             :style="{ transitionDelay: isVisible ? `${index * 60}ms` : '0ms' }">

          <!-- Hover Ambient Radial Overlay -->
          <div class="absolute inset-0 bg-gradient-to-br from-cyan-400/5 via-primary/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500 pointer-events-none"></div>

          <div>
            <!-- Top Row: Icon & Status Badge -->
            <div class="flex justify-between items-center mb-6 relative z-10">
              <div class="w-14 h-14 rounded-2xl bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 flex items-center justify-center group-hover:scale-110 group-hover:border-cyan-400/40 transition-all duration-500">
                <Icon :name="tech.icon" class="text-3xl text-on-surface" />
              </div>
              
              <span class="text-[10px] font-mono font-bold uppercase tracking-wider px-2.5 py-1 rounded-full bg-cyan-400/10 border border-cyan-400/30 text-cyan-400">
                {{ tech.status }}
              </span>
            </div>

            <!-- Tech Title & Category -->
            <div class="relative z-10 mb-4">
              <h3 class="text-xl font-bold text-on-surface mb-1 group-hover:text-cyan-400 transition-colors">
                {{ tech.name }}
              </h3>
              <p class="text-[11px] font-mono uppercase text-pink-400 font-semibold tracking-wider mb-3">
                {{ tech.categoryName }}
              </p>
              <p class="text-xs text-on-surface-variant/80 leading-relaxed mb-4">
                {{ tech.description }}
              </p>
            </div>
          </div>

          <!-- Bottom Row: Tags & Proficiency Bar -->
          <div class="relative z-10 pt-4 border-t border-black/5 dark:border-white/5 space-y-3">
            <div class="flex flex-wrap gap-1">
              <span v-for="tag in tech.tags" :key="tag"
                    class="px-2 py-0.5 rounded-md text-[9px] font-bold uppercase tracking-wider bg-black/5 dark:bg-white/5 text-on-surface-variant">
                {{ tag }}
              </span>
            </div>

            <div>
              <div class="flex justify-between text-[10px] font-bold uppercase tracking-wider text-on-surface-variant mb-1">
                <span>Mastery</span>
                <span>{{ tech.level }}%</span>
              </div>
              <div class="w-full h-1.5 rounded-full bg-black/5 dark:bg-white/10 overflow-hidden">
                <div class="h-full rounded-full bg-gradient-to-r from-cyan-400 via-purple-500 to-pink-500 transition-all duration-1000"
                     :style="{ width: isVisible ? `${tech.level}%` : '0%' }"></div>
              </div>
            </div>
          </div>

        </div>
      </div>

      <!-- Tech Stack Synergy / Architecture Highlights -->
      <div class="glass-panel p-8 sm:p-10 border border-black/5 dark:border-white/10 relative overflow-hidden">
        <div class="absolute inset-0 bg-gradient-to-r from-primary/5 via-cyan-400/5 to-pink-500/5 pointer-events-none"></div>
        
        <div class="relative z-10">
          <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
            <div>
              <span class="text-[10px] font-mono font-bold text-pink-400 uppercase tracking-widest block mb-1">System Integration</span>
              <h3 class="text-2xl sm:text-3xl font-black text-on-surface">Architectural Stack Synergy</h3>
            </div>
            <span class="px-3.5 py-1.5 rounded-full bg-primary/20 border border-primary/40 text-cyan-400 text-xs font-bold uppercase tracking-wider">
              Battle-Tested Configurations
            </span>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div v-for="arch in architecturePatterns" :key="arch.title"
                 class="p-6 rounded-2xl bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 hover:border-cyan-400/40 transition-all">
              <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-cyan-400 to-primary flex items-center justify-center mb-4 text-white">
                <span class="material-symbols-outlined text-xl">{{ arch.icon }}</span>
              </div>
              <h4 class="text-base font-bold text-on-surface mb-2">{{ arch.title }}</h4>
              <p class="text-xs text-on-surface-variant mb-4 leading-relaxed">{{ arch.description }}</p>
              <div class="text-[11px] font-mono font-bold text-cyan-400 bg-black/10 dark:bg-white/5 p-2 rounded-lg border border-black/5 dark:border-white/10">
                {{ arch.stack }}
              </div>
            </div>
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
const searchQuery = ref('')

const categories = [
  { id: 'all', label: 'All Stack', icon: 'auto_awesome' },
  { id: 'mobile', label: 'Mobile', icon: 'smartphone' },
  { id: 'frontend', label: 'Frontend', icon: 'desktop_windows' },
  { id: 'backend', label: 'Backend', icon: 'dns' },
  { id: 'database', label: 'Database', icon: 'database' },
  { id: 'devops', label: 'DevOps', icon: 'terminal' }
]

const techStackData = [
  {
    name: 'Flutter & Dart',
    category: 'mobile',
    categoryName: 'Mobile Development',
    icon: 'logos:flutter',
    level: 95,
    status: 'Expert',
    description: 'Cross-platform mobile apps with native UI performance, custom BLoC state management, and offline cache engines.',
    tags: ['BLoC', 'Riverpod', 'Offline Caching', 'Custom Animations']
  },
  {
    name: 'Supabase',
    category: 'database',
    categoryName: 'Cloud & Database',
    icon: 'logos:supabase-icon',
    level: 92,
    status: 'Production',
    description: 'Real-time PostgreSQL databases, row level security (RLS), authentication, edge functions, and real-time subscriptions.',
    tags: ['PostgreSQL', 'RLS Security', 'Edge Functions', 'WebSockets']
  },
  {
    name: 'Nuxt 3 & Vue 3',
    category: 'frontend',
    categoryName: 'Frontend Web',
    icon: 'logos:nuxt-icon',
    level: 94,
    status: 'Expert',
    description: 'Server-side rendering (SSR), static site generation, Pinia state stores, auto-imports, and responsive UI components.',
    tags: ['SSR', 'Vue 3', 'Pinia', 'Composition API']
  },
  {
    name: 'Tailwind CSS',
    category: 'frontend',
    categoryName: 'Styling & UI Systems',
    icon: 'logos:tailwindcss-icon',
    level: 96,
    status: 'Master',
    description: 'Utility-first modern responsive layouts, dark/light theme tokens, and cyber-glassmorphism visuals.',
    tags: ['Glassmorphism', 'Dark Mode', 'Design Tokens']
  },
  {
    name: 'Laravel API',
    category: 'backend',
    categoryName: 'Backend & Microservices',
    icon: 'logos:laravel',
    level: 88,
    status: 'Advanced',
    description: 'RESTful API engines, Eloquent ORM relationships, automated database migrations, and queue background jobs.',
    tags: ['REST API', 'Eloquent', 'Sanctum Auth', 'Queues']
  },
  {
    name: 'Node.js & Express',
    category: 'backend',
    categoryName: 'Backend & Serverless',
    icon: 'logos:nodejs-icon',
    level: 90,
    status: 'Advanced',
    description: 'Asynchronous event-driven server runtime, microservices API routing, and HTTP middleware processing.',
    tags: ['Asynchronous', 'Express.js', 'REST API', 'JSON Web Tokens']
  },
  {
    name: 'PostgreSQL & MySQL',
    category: 'database',
    categoryName: 'Relational Database',
    icon: 'logos:postgresql',
    level: 88,
    status: 'Advanced',
    description: 'Database schema modeling, SQL query index optimization, complex joins, and data integrity constraints.',
    tags: ['Indexing', 'SQL Triggers', 'ACID Compliance']
  },
  {
    name: 'Firebase',
    category: 'database',
    categoryName: 'Mobile Cloud Backend',
    icon: 'logos:firebase',
    level: 88,
    status: 'Advanced',
    description: 'Cloud Firestore, Firebase Authentication, Cloud Messaging push alerts, and analytics integrations.',
    tags: ['Firestore', 'Push Notifications', 'FCM', 'Analytics']
  },
  {
    name: 'TypeScript',
    category: 'frontend',
    categoryName: 'Type System',
    icon: 'logos:typescript-icon',
    level: 90,
    status: 'Expert',
    description: 'Strict type safety across Vue/Nuxt components, API payloads, interfaces, and compile-time validation.',
    tags: ['Strict Typing', 'Interfaces', 'Generics']
  },
  {
    name: 'Git & DevOps',
    category: 'devops',
    categoryName: 'CI/CD & Version Control',
    icon: 'logos:git-icon',
    level: 92,
    status: 'Expert',
    description: 'Git flow branching strategies, GitHub Actions automated CI/CD deployment pipelines, and release tags.',
    tags: ['GitHub Actions', 'Branch Strategy', 'CI/CD', 'Releases']
  },
  {
    name: 'Docker',
    category: 'devops',
    categoryName: 'Containerization',
    icon: 'logos:docker-icon',
    level: 84,
    status: 'Proficient',
    description: 'Containerized application environments for repeatable development setup and isolated server deployments.',
    tags: ['Containers', 'Docker Compose', 'Environment Parity']
  },
  {
    name: 'Figma & UI Design',
    category: 'devops',
    categoryName: 'Design to Code',
    icon: 'logos:figma',
    level: 88,
    status: 'Advanced',
    description: 'Translating high-fidelity Figma designs, component wireframes, and design systems into code.',
    tags: ['UI Design', 'Wireframing', 'Design Systems']
  }
]

const filteredTechStack = computed(() => {
  return techStackData.filter(tech => {
    const matchesCategory = activeCategory.value === 'all' || tech.category === activeCategory.value
    const matchesSearch = tech.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                          tech.description.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                          tech.tags.some(t => t.toLowerCase().includes(searchQuery.value.toLowerCase()))
    return matchesCategory && matchesSearch
  })
})

const architecturePatterns = [
  {
    title: 'Mobile Architecture',
    icon: 'phone_iphone',
    description: 'Cross-platform mobile apps with real-time database sync and offline caching.',
    stack: 'Flutter + BLoC + Supabase + Hive'
  },
  {
    title: 'Web SaaS Portal',
    icon: 'laptop_mac',
    description: 'Server-side rendered web app with glass UI design system.',
    stack: 'Nuxt 3 + Vue 3 + Tailwind + Pinia'
  },
  {
    title: 'Cloud Backend API',
    icon: 'cloud',
    description: 'Scalable REST API microservices with automated background queue processing.',
    stack: 'Laravel / Node + PostgreSQL + Redis'
  },
  {
    title: 'Serverless Real-Time',
    icon: 'bolt',
    description: 'Real-time database sync with Row-Level Security and edge functions.',
    stack: 'Supabase + Edge Functions + RLS'
  }
]
</script>
