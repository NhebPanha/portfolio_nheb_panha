<template>
  <section id="portfolio" class="section section-alt">
    <div ref="sectionRef" class="container-page">
      <div class="flex flex-col gap-8 md:flex-row md:items-end md:justify-between">
        <SectionHeading
          eyebrow="Projects"
          title="Selected work"
          lead="Mobile apps, web platforms and business tools I've designed and built."
        />

        <label class="relative block w-full md:w-72">
          <span class="sr-only">Search projects</span>
          <span class="material-symbols-outlined pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-[18px] text-on-surface-variant">search</span>
          <input v-model="searchQuery" type="search" placeholder="Search by name or technology" class="input !pl-10" />
        </label>
      </div>

      <!-- Category filters -->
      <div class="mt-10 flex flex-wrap gap-2" role="group" aria-label="Filter by category">
        <button
          v-for="cat in categories"
          :key="cat"
          class="filter-btn"
          :class="selectedCategory === cat ? 'filter-btn-active' : 'filter-btn-idle'"
          :aria-pressed="selectedCategory === cat"
          @click="selectedCategory = cat"
        >
          {{ cat }}
        </button>
      </div>

      <!-- Grid -->
      <div v-if="filteredProjects.length" class="mt-8 grid gap-5 md:grid-cols-2 lg:grid-cols-3">
        <article
          v-for="(project, index) in filteredProjects"
          :key="project.id || index"
          class="card card-hover reveal group flex flex-col overflow-hidden"
          :class="{ 'reveal-hidden': !isVisible }"
          :style="{ transitionDelay: `${Math.min(index, 5) * 70}ms` }"
        >
          <div class="flex items-center justify-between border-b border-line bg-surface px-6 py-5">
            <div class="flex h-12 w-12 items-center justify-center rounded-xl border border-line bg-background">
              <Icon :name="project.icon" class="text-2xl" />
            </div>
            <span v-if="project.status" class="text-xs font-medium text-on-surface-variant">
              {{ project.status }}
            </span>
          </div>

          <div class="flex flex-1 flex-col p-6">
            <p class="text-xs font-semibold uppercase tracking-wider text-primary">{{ project.category }}</p>
            <h3 class="mt-2 text-lg font-semibold text-on-surface">{{ project.title }}</h3>
            <p class="mt-2 line-clamp-3 text-sm leading-relaxed text-on-surface-variant">{{ project.description }}</p>

            <div class="mt-5 flex flex-wrap gap-1.5">
              <span v-for="tech in project.tags" :key="tech.name" class="chip">
                <Icon :name="tech.icon" class="text-xs" />
                {{ tech.name }}
              </span>
            </div>

            <button
              class="mt-auto inline-flex items-center gap-1 self-start pt-6 text-sm font-medium text-primary hover:underline"
              @click="activeModalProject = project"
            >
              View details
              <span class="material-symbols-outlined text-[16px] transition-transform group-hover:translate-x-0.5">arrow_forward</span>
            </button>
          </div>
        </article>
      </div>

      <!-- Empty state -->
      <div v-else class="card mt-8 flex flex-col items-center px-6 py-14 text-center">
        <span class="material-symbols-outlined text-4xl text-on-surface-variant">search_off</span>
        <h3 class="mt-3 text-base font-semibold text-on-surface">No projects found</h3>
        <p class="mt-1 text-sm text-on-surface-variant">Try a different search or category.</p>
        <button class="btn-secondary mt-6" @click="resetFilters">Clear filters</button>
      </div>
    </div>

    <!-- Details dialog -->
    <Teleport to="body">
      <Transition name="modal">
        <div v-if="activeModalProject" class="fixed inset-0 z-[100] flex items-center justify-center p-4">
          <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" @click="activeModalProject = null"></div>

          <div
            role="dialog"
            aria-modal="true"
            :aria-label="activeModalProject.title"
            class="card relative z-10 max-h-[90vh] w-full max-w-xl overflow-y-auto p-6 shadow-2xl sm:p-8"
          >
            <button
              class="absolute right-4 top-4 flex h-9 w-9 items-center justify-center rounded-lg text-on-surface-variant hover:bg-surface hover:text-on-surface"
              aria-label="Close"
              @click="activeModalProject = null"
            >
              <span class="material-symbols-outlined text-[20px]">close</span>
            </button>

            <div class="flex items-center gap-4 pr-10">
              <div class="flex h-14 w-14 shrink-0 items-center justify-center rounded-xl border border-line bg-surface">
                <Icon :name="activeModalProject.icon" class="text-3xl" />
              </div>
              <div>
                <p class="text-xs font-semibold uppercase tracking-wider text-primary">{{ activeModalProject.category }}</p>
                <h3 class="mt-1 text-xl font-semibold text-on-surface">{{ activeModalProject.title }}</h3>
              </div>
            </div>

            <p class="mt-6 text-[15px] leading-relaxed text-on-surface-variant">{{ activeModalProject.description }}</p>

            <h4 class="mt-6 text-sm font-semibold text-on-surface">Built with</h4>
            <div class="mt-3 flex flex-wrap gap-2">
              <span v-for="tech in activeModalProject.tags" :key="tech.name" class="chip !text-sm">
                <Icon :name="tech.icon" class="text-base" />
                {{ tech.name }}
              </span>
            </div>

            <div class="mt-8 flex flex-wrap gap-3 border-t border-line pt-6">
              <a v-if="isRealLink(activeModalProject.demo_url) && activeModalProject.demo_url !== activeModalProject.github_url"
                 :href="activeModalProject.demo_url" target="_blank" rel="noopener noreferrer" class="btn-primary">
                <span class="material-symbols-outlined text-[18px]">open_in_new</span>
                Live demo
              </a>
              <a v-if="isRealLink(activeModalProject.github_url)"
                 :href="activeModalProject.github_url" target="_blank" rel="noopener noreferrer" class="btn-secondary">
                <Icon name="mdi:github" class="text-lg" />
                Source code
              </a>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>
  </section>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onBeforeUnmount } from 'vue'
import { useScrollAnimate } from '~/composables/useScrollAnimate'
import { useSupabase, type ProjectItem } from '~/composables/useSupabase'

const { sectionRef, isVisible } = useScrollAnimate(0.05)
const { fetchProjects } = useSupabase()

const projectsList = ref<ProjectItem[]>([])
const searchQuery = ref('')
const selectedCategory = ref('All')
const activeModalProject = ref<ProjectItem | null>(null)

const isRealLink = (url?: string) => Boolean(url && url !== '#' && url.startsWith('http'))

const categories = computed(() => ['All', ...new Set(projectsList.value.map(p => p.category))])

const filteredProjects = computed(() => {
  const query = searchQuery.value.toLowerCase().trim()
  return projectsList.value.filter(project => {
    if (selectedCategory.value !== 'All' && project.category !== selectedCategory.value) return false
    if (!query) return true
    return [project.title, project.category, project.description, ...project.tags.map(t => t.name)]
      .some(text => text.toLowerCase().includes(query))
  })
})

const resetFilters = () => {
  searchQuery.value = ''
  selectedCategory.value = 'All'
}

// Close with Escape and lock page scroll while the dialog is open.
const onKeydown = (e: KeyboardEvent) => {
  if (e.key === 'Escape') activeModalProject.value = null
}
watch(activeModalProject, (open) => {
  document.body.style.overflow = open ? 'hidden' : ''
})
onBeforeUnmount(() => {
  window.removeEventListener('keydown', onKeydown)
  document.body.style.overflow = ''
})

onMounted(async () => {
  window.addEventListener('keydown', onKeydown)
  const res = await fetchProjects()
  projectsList.value = res.projects
})
</script>

<style scoped>
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.2s ease;
}
.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}
</style>
