<template>
  <section id="portfolio" class="text-on-background py-24 md:py-36 px-4 md:px-8 max-w-7xl mx-auto relative overflow-hidden" ref="sectionRef">

    <div class="relative z-10 transition-all duration-1000 ease-out"
         :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">
        
      <!-- Header & Supabase Source Indicator -->
      <div class="flex flex-col md:flex-row md:items-end justify-between mb-12 gap-6">
        <div>
          <div class="flex items-center gap-3 mb-4">
            <span class="font-label text-xs tracking-[0.3em] text-primary font-bold uppercase block">
              Featured Work
            </span>

            <!-- Supabase Data Source Badge -->
            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[10px] font-bold tracking-wider uppercase border backdrop-blur-md"
                  :class="dataSource === 'supabase' ? 'bg-emerald-500/10 border-emerald-500/30 text-emerald-400' : 'bg-cyan-500/10 border-cyan-500/30 text-cyan-400'">
              <span class="w-1.5 h-1.5 rounded-full" :class="dataSource === 'supabase' ? 'bg-emerald-400 animate-pulse' : 'bg-cyan-400'"></span>
              {{ dataSource === 'supabase' ? 'Supabase DB Live' : 'Supabase Ready' }}
            </span>
          </div>

          <h2 class="font-headline text-4xl sm:text-6xl md:text-7xl font-black tracking-tighter leading-none">
            Selected <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-blue-500 to-pink-500">Ecosystems</span>
          </h2>
        </div>

        <p class="text-on-surface-variant text-base md:text-lg max-w-md leading-relaxed">
          High-performance cross-platform applications engineered with Flutter, Nuxt 3, Laravel, and Supabase cloud infrastructure.
        </p>
      </div>

      <!-- Controls Bar: Search & Category Chips -->
      <div class="flex flex-col lg:flex-row gap-4 justify-between items-stretch lg:items-center mb-12 p-2 rounded-2xl bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 backdrop-blur-xl">
        
        <!-- Search Input -->
        <div class="relative flex-1 max-w-md">
          <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-on-surface-variant/60 text-lg">search</span>
          <input v-model="searchQuery" 
                 type="text" 
                 placeholder="Search by title, tech stack (Flutter, Supabase...)..." 
                 class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-white/40 dark:bg-black/20 border border-black/5 dark:border-white/10 text-xs text-on-surface placeholder:text-on-surface-variant/50 focus:outline-none focus:border-cyan-400 transition-all" />
          <button v-if="searchQuery" @click="searchQuery = ''" class="absolute right-3 top-1/2 -translate-y-1/2 text-on-surface-variant/50 hover:text-on-surface">
            <span class="material-symbols-outlined text-sm">close</span>
          </button>
        </div>

        <!-- Category Chips -->
        <div class="flex flex-wrap gap-1.5 overflow-x-auto pb-1 lg:pb-0 custom-scrollbar">
          <button v-for="cat in categories" :key="cat" @click="selectedCategory = cat"
                  :class="[
                    'px-4 py-2 rounded-xl text-xs font-bold uppercase tracking-wider transition-all duration-300 whitespace-nowrap',
                    selectedCategory === cat
                      ? 'bg-gradient-to-r from-primary to-purple-600 text-white shadow-md'
                      : 'text-on-surface-variant hover:text-cyan-400 hover:bg-black/5 dark:hover:bg-white/5'
                  ]">
            {{ cat }}
          </button>
        </div>

      </div>

      <!-- Projects Grid -->
      <div v-if="filteredProjects.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 md:gap-8">
        <div v-for="(project, index) in filteredProjects" :key="project.id || index" 
             @click="openModal(project)"
             class="group relative rounded-[2rem] overflow-hidden glass-panel border border-black/5 dark:border-white/10 bg-white/40 dark:bg-white/[0.02] transition-all duration-500 hover:border-primary/50 hover:-translate-y-1.5 cursor-pointer">
            
          <!-- Card Header / Visual Pattern -->
          <div class="aspect-[16/10] overflow-hidden relative bg-gradient-to-br from-primary/10 via-purple-600/10 to-cyan-400/10 p-6 flex flex-col justify-between">
            <div class="absolute inset-0 bg-grid-pattern opacity-30"></div>
            <div class="absolute inset-0 bg-gradient-to-t from-slate-950/80 via-transparent to-transparent opacity-80 group-hover:opacity-40 transition-opacity"></div>
            
            <!-- Category Tag & Status Badge -->
          <div class="relative z-10 flex justify-between items-center">
            <span class="px-3.5 py-1 rounded-full bg-black/60 backdrop-blur-md border border-white/10 text-[10px] font-bold tracking-widest uppercase text-white">
              {{ project.category }}
            </span>

            <div class="flex items-center gap-2">
              <span class="px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider backdrop-blur-md border"
                    :class="project.status === 'Released' ? 'bg-emerald-500/20 border-emerald-500/40 text-emerald-300' : 'bg-cyan-500/20 border-cyan-500/40 text-cyan-300'">
                {{ project.status === 'Released' ? '🚀 Released' : '⚡ Production' }}
              </span>

              <div class="w-8 h-8 rounded-full bg-white/10 backdrop-blur-md border border-white/20 flex items-center justify-center text-white group-hover:bg-primary group-hover:scale-110 transition-all">
                <span class="material-symbols-outlined text-sm">visibility</span>
              </div>
            </div>
          </div>

          <!-- Central Icon Graphic -->
          <div class="relative z-10 my-auto flex justify-center items-center">
            <div class="w-16 h-16 rounded-2xl bg-white/10 backdrop-blur-xl border border-white/20 flex items-center justify-center shadow-2xl group-hover:scale-110 transition-transform duration-500">
              <Icon :name="project.icon" class="text-3xl text-white" />
            </div>
          </div>
        </div>

        <!-- Project Content -->
        <div class="p-6 md:p-8">
          <div class="flex flex-col mb-3">
            <h3 class="text-xl font-black tracking-tight text-on-surface group-hover:text-cyan-400 transition-colors">
              {{ project.title }}
            </h3>
            <span v-if="project.metrics" class="text-[10px] font-mono text-cyan-400 font-bold uppercase tracking-wider mt-1">
              Metric: {{ project.metrics }}
            </span>
          </div>

          <p class="text-xs md:text-sm text-on-surface-variant/80 leading-relaxed mb-6 line-clamp-2">
            {{ project.description }}
          </p>
          
          <!-- Tech Stack Pills -->
          <div class="flex flex-wrap gap-1.5">
            <span v-for="tech in project.tags" :key="tech.name" 
                  class="inline-flex items-center gap-1 px-2.5 py-1 rounded-lg bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/5 text-[10px] font-semibold text-on-surface-variant">
              <Icon :name="tech.icon" class="text-xs" />
              {{ tech.name }}
            </span>
          </div>
        </div>

      </div>
    </div>

    <!-- Empty Filter Result -->
    <div v-else class="text-center py-16 p-8 glass-panel rounded-3xl">
      <span class="material-symbols-outlined text-5xl text-on-surface-variant/40 mb-3">search_off</span>
      <h4 class="text-xl font-bold mb-2">No Ecosystems Found</h4>
      <p class="text-xs text-on-surface-variant mb-6">No projects matched your active search query or category filter.</p>
      <button @click="resetFilters" class="px-6 py-2.5 rounded-xl bg-primary text-white font-bold text-xs uppercase tracking-wider">
        Reset Filters
      </button>
    </div>

    </div>

    <!-- Project Detail Modal Dialog -->
    <Transition name="modal">
      <div v-if="activeModalProject" class="fixed inset-0 z-[100] flex items-center justify-center p-4 sm:p-6">
        <!-- Backdrop -->
        <div class="absolute inset-0 bg-slate-950/80 backdrop-blur-md" @click="activeModalProject = null"></div>

        <!-- Dialog Box -->
        <div class="relative z-10 w-full max-w-2xl bg-slate-900 border border-white/10 rounded-3xl p-6 sm:p-8 shadow-2xl overflow-hidden text-white max-h-[90vh] overflow-y-auto custom-scrollbar">
          
          <!-- Header Actions -->
          <div class="flex justify-between items-center mb-6">
            <div class="flex items-center gap-2">
              <span class="px-3 py-1 rounded-full bg-primary/20 border border-primary/40 text-[10px] font-bold tracking-widest uppercase text-cyan-400">
                {{ activeModalProject.category }}
              </span>
              <span class="px-2.5 py-1 rounded-full bg-emerald-500/20 border border-emerald-500/30 text-[10px] font-bold uppercase text-emerald-400 flex items-center gap-1">
                <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
                {{ activeModalProject.status || 'Released & Production Ready' }}
              </span>
            </div>

            <button @click="activeModalProject = null" class="w-9 h-9 rounded-full bg-white/10 hover:bg-white/20 flex items-center justify-center text-white transition-colors">
              <span class="material-symbols-outlined text-xl">close</span>
            </button>
          </div>

          <!-- Project Title & Icon -->
          <div class="flex items-center gap-4 mb-6">
            <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-primary to-cyan-400 p-[1px]">
              <div class="w-full h-full bg-slate-950 rounded-[15px] flex items-center justify-center">
                <Icon :name="activeModalProject.icon" class="text-3xl" />
              </div>
            </div>
            <div>
              <h3 class="text-2xl sm:text-3xl font-black tracking-tight">{{ activeModalProject.title }}</h3>
              <p v-if="activeModalProject.metrics" class="text-xs text-cyan-400 font-mono font-bold mt-0.5">
                Benchmark: {{ activeModalProject.metrics }}
              </p>
            </div>
          </div>

          <!-- Detailed Description -->
          <div class="space-y-4 mb-8 text-sm text-slate-300 leading-relaxed">
            <p>{{ activeModalProject.description }}</p>
            <div class="p-4 rounded-2xl bg-slate-950/60 border border-white/5 space-y-2">
              <div class="text-xs font-bold uppercase tracking-wider text-cyan-400">Key Features & Architecture:</div>
              <ul class="text-xs space-y-1.5 text-slate-300">
                <li class="flex items-center gap-2">
                  <span class="w-1.5 h-1.5 rounded-full bg-primary"></span>
                  Real-time database integration with security Row Level Policies
                </li>
                <li class="flex items-center gap-2">
                  <span class="w-1.5 h-1.5 rounded-full bg-cyan-400"></span>
                  Responsive cross-platform UI optimized for mobile and web
                </li>
                <li class="flex items-center gap-2">
                  <span class="w-1.5 h-1.5 rounded-full bg-pink-400"></span>
                  Clean architecture layer separation and strict type checking
                </li>
              </ul>
            </div>
          </div>

          <!-- Tech Stack Section -->
          <div class="mb-8">
            <h4 class="text-xs font-bold uppercase tracking-wider text-slate-400 mb-3">Technologies Employed:</h4>
            <div class="flex flex-wrap gap-2">
              <div v-for="tech in activeModalProject.tags" :key="tech.name"
                   class="inline-flex items-center gap-2 px-3.5 py-2 rounded-xl bg-white/5 border border-white/10 text-xs font-semibold">
                <Icon :name="tech.icon" class="text-base" />
                <span>{{ tech.name }}</span>
              </div>
            </div>
          </div>

          <!-- Modal Actions -->
          <div class="flex flex-wrap items-center gap-3 pt-4 border-t border-white/10">
            <a :href="activeModalProject.demo_url || activeModalProject.github_url || 'https://github.com/nhebpanha'" target="_blank"
               class="flex-1 py-3 px-5 rounded-xl bg-gradient-to-r from-cyan-400 via-blue-600 to-primary text-white font-bold text-xs uppercase tracking-widest text-center hover:shadow-[0_0_20px_rgba(0,251,251,0.4)] transition-all flex items-center justify-center gap-2">
              <span class="material-symbols-outlined text-sm">open_in_new</span>
              <span>Live Preview / Demo</span>
            </a>

            <a :href="activeModalProject.github_url || 'https://github.com/nhebpanha'" target="_blank"
               class="py-3 px-5 rounded-xl bg-white/10 hover:bg-white/20 text-white font-bold text-xs uppercase tracking-widest text-center transition-all flex items-center justify-center gap-2">
              <Icon name="logos:github-icon" class="text-base" />
              <span>GitHub Source</span>
            </a>

            <button @click="activeModalProject = null"
                    class="py-3 px-5 rounded-xl bg-white/5 hover:bg-white/10 text-slate-400 font-bold text-xs uppercase tracking-widest transition-colors">
              Close
            </button>
          </div>

        </div>
      </div>
    </Transition>

  </section>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useScrollAnimate } from '~/composables/useScrollAnimate'
import { useSupabase, type ProjectItem } from '~/composables/useSupabase'

const { sectionRef, isVisible } = useScrollAnimate(0.1)
const { fetchProjects } = useSupabase()

const projectsList = ref<ProjectItem[]>([])
const dataSource = ref<'supabase' | 'fallback'>('fallback')

const searchQuery = ref('')
const selectedCategory = ref('All')

const activeModalProject = ref<ProjectItem | null>(null)

const categories = computed(() => {
  const cats = new Set(projectsList.value.map(p => p.category))
  return ['All', ...Array.from(cats)]
})

const filteredProjects = computed(() => {
  return projectsList.value.filter(project => {
    const matchesCategory = selectedCategory.value === 'All' || project.category === selectedCategory.value
    const query = searchQuery.value.toLowerCase().trim()
    if (!query) return matchesCategory

    const matchesTitle = project.title.toLowerCase().includes(query)
    const matchesCat = project.category.toLowerCase().includes(query)
    const matchesDesc = project.description.toLowerCase().includes(query)
    const matchesTech = project.tags.some(t => t.name.toLowerCase().includes(query))

    return matchesCategory && (matchesTitle || matchesCat || matchesDesc || matchesTech)
  })
})

const openModal = (project: ProjectItem) => {
  activeModalProject.value = project
}

const resetFilters = () => {
  searchQuery.value = ''
  selectedCategory.value = 'All'
}

onMounted(async () => {
  const res = await fetchProjects()
  projectsList.value = res.projects
  dataSource.value = res.source
})
</script>

<style scoped>
.modal-enter-active,
.modal-leave-active {
  transition: all 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
  transform: scale(0.95);
}

.custom-scrollbar::-webkit-scrollbar {
  height: 4px;
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(129, 28, 217, 0.4);
  border-radius: 10px;
}
</style>
