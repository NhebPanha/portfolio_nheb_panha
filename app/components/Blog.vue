<template>
  <div id="blog" class="bg-background text-on-background font-body relative overflow-hidden transition-colors duration-500">
    <!-- Ambient Glow Backgrounds -->
    <div class="absolute top-1/3 left-0 w-[550px] h-[550px] bg-primary/10 rounded-full blur-[140px] pointer-events-none"></div>
    <div class="absolute bottom-1/3 right-0 w-[550px] h-[550px] bg-pink-500/10 rounded-full blur-[140px] pointer-events-none"></div>

    <section class="pt-24 md:pt-36 pb-24 md:pb-36 max-w-7xl mx-auto px-4 md:px-8 relative z-10" ref="sectionRef">

      <!-- Header Section -->
      <div class="mb-16 transition-all duration-1000 ease-out"
           :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">
        
        <div class="flex flex-wrap items-center justify-between gap-4 mb-6">
          <span class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 text-pink-400 text-[11px] font-bold tracking-[0.35em] uppercase">
            <span class="w-2 h-2 rounded-full bg-pink-400 animate-pulse"></span>
            Technical Writing & Case Studies
          </span>

          <div class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 text-xs font-mono text-cyan-400">
            <span class="material-symbols-outlined text-sm">article</span>
            <span>Engineering Insights</span>
          </div>
        </div>

        <h2 class="font-headline text-4xl sm:text-6xl md:text-7xl font-black tracking-tighter leading-[0.88] mb-6">
          Engineering <span class="text-transparent bg-clip-text bg-gradient-to-r from-pink-400 via-purple-500 to-cyan-400">Insights</span> & Articles
        </h2>

        <p class="text-on-surface-variant/80 text-base md:text-lg max-w-2xl leading-relaxed">
          Deep-dives into cross-platform mobile architecture, server-side rendering performance, database row-level security, and operational telemetry.
        </p>

        <!-- Search Bar & Filters -->
        <div class="mt-8 flex flex-col md:flex-row items-stretch md:items-center justify-between gap-4">
          
          <!-- Category Filters -->
          <div class="flex flex-wrap gap-2">
            <button v-for="cat in categories" :key="cat"
                    @click="activeCategory = cat"
                    :class="[
                      'px-4 py-2 rounded-xl text-xs font-bold uppercase tracking-wider transition-all duration-300',
                      activeCategory === cat
                        ? 'bg-gradient-to-r from-pink-500 via-purple-600 to-primary text-white shadow-lg shadow-pink-500/20 scale-105'
                        : 'bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 text-on-surface-variant hover:text-pink-400'
                    ]">
              {{ cat }}
            </button>
          </div>

          <!-- Search Input -->
          <div class="relative w-full md:w-72">
            <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-on-surface-variant text-lg">search</span>
            <input v-model="searchQuery"
                   placeholder="Search articles & topics..."
                   class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 text-xs text-on-surface placeholder:text-on-surface-variant/50 focus:outline-none focus:border-pink-400 transition-all" />
          </div>

        </div>
      </div>

      <!-- Articles Grid -->
      <div v-if="filteredPosts.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 md:gap-8">
        <div v-for="(post, index) in filteredPosts" :key="post.id || index"
             @click="openPostModal(post)"
             class="group relative rounded-[2rem] p-7 glass-panel border border-black/5 dark:border-white/10 bg-white/40 dark:bg-white/[0.02] hover:border-pink-500/50 transition-all duration-500 hover:-translate-y-1.5 cursor-pointer flex flex-col justify-between"
             :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'"
             :style="{ transitionDelay: isVisible ? `${index * 100}ms` : '0ms' }">

          <!-- Card Top -->
          <div>
            <!-- Hover Radial Accent -->
            <div class="absolute inset-0 bg-gradient-to-br from-pink-500/5 via-primary/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500 pointer-events-none"></div>

            <!-- Meta Header: Category & Date -->
            <div class="flex items-center justify-between gap-2 mb-6">
              <span class="px-3 py-1 rounded-full text-[10px] font-bold font-mono tracking-wider uppercase bg-pink-500/10 border border-pink-500/30 text-pink-400">
                {{ post.category }}
              </span>

              <div class="flex items-center gap-2 text-[10px] font-mono text-on-surface-variant">
                <span>{{ post.published_at }}</span>
                <span>•</span>
                <span>{{ post.read_time }}</span>
              </div>
            </div>

            <!-- Icon & Title -->
            <div class="flex items-start gap-4 mb-4">
              <div class="w-12 h-12 rounded-2xl bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 flex items-center justify-center shrink-0 group-hover:scale-110 group-hover:border-pink-500/40 transition-all">
                <Icon :name="post.icon" class="text-2xl text-on-surface" />
              </div>
              <h3 class="text-lg font-bold text-on-surface leading-snug group-hover:text-pink-400 transition-colors">
                {{ post.title }}
              </h3>
            </div>

            <!-- Summary -->
            <p class="text-xs text-on-surface-variant/80 leading-relaxed mb-6 line-clamp-3">
              {{ post.summary }}
            </p>
          </div>

          <!-- Card Bottom -->
          <div class="pt-4 border-t border-black/5 dark:border-white/5 flex items-center justify-between gap-2">
            <div class="flex items-center gap-1.5 text-xs text-on-surface font-semibold">
              <span class="w-6 h-6 rounded-full bg-gradient-to-br from-primary to-pink-500 flex items-center justify-center text-[10px] font-black text-white">
                NP
              </span>
              <span class="text-[11px] text-on-surface-variant">{{ post.author }}</span>
            </div>

            <button class="inline-flex items-center gap-1 text-xs font-bold uppercase tracking-wider text-pink-400 group-hover:text-cyan-400 transition-colors">
              <span>Read Article</span>
              <span class="material-symbols-outlined text-sm">arrow_forward</span>
            </button>
          </div>

        </div>
      </div>

      <!-- Article Reader Modal -->
      <Transition name="modal">
        <div v-if="activePost" class="fixed inset-0 z-[100] flex items-center justify-center p-4 sm:p-6">
          <!-- Backdrop -->
          <div class="absolute inset-0 bg-slate-950/85 backdrop-blur-md" @click="activePost = null"></div>

          <!-- Dialog Window -->
          <div class="relative z-10 w-full max-w-3xl bg-slate-900 border border-white/10 rounded-3xl p-6 sm:p-10 shadow-2xl text-white max-h-[90vh] overflow-y-auto custom-scrollbar">
            
            <!-- Modal Header -->
            <div class="flex justify-between items-center mb-6 border-b border-white/10 pb-4">
              <div class="flex items-center gap-3">
                <span class="px-3 py-1 rounded-full bg-pink-500/20 border border-pink-500/40 text-[10px] font-bold tracking-widest uppercase text-pink-400">
                  {{ activePost.category }}
                </span>
                <span class="text-xs font-mono text-slate-400">{{ activePost.published_at }} • {{ activePost.read_time }}</span>
              </div>

              <button @click="activePost = null" class="w-9 h-9 rounded-full bg-white/10 hover:bg-white/20 flex items-center justify-center text-white transition-colors">
                <span class="material-symbols-outlined text-xl">close</span>
              </button>
            </div>

            <!-- Title & Author -->
            <h2 class="text-2xl sm:text-4xl font-black tracking-tight leading-snug mb-4">
              {{ activePost.title }}
            </h2>

            <div class="flex items-center gap-3 mb-8 pb-6 border-b border-white/5 text-xs text-slate-400">
              <div class="w-8 h-8 rounded-full bg-gradient-to-br from-primary to-cyan-400 flex items-center justify-center font-bold text-white">
                NP
              </div>
              <div>
                <span class="font-bold text-white block">{{ activePost.author }}</span>
                <span>Full-Stack & Mobile Architect</span>
              </div>
            </div>

            <!-- Article Content -->
            <div class="prose prose-invert prose-sm max-w-none space-y-6 text-slate-300 leading-relaxed">
              <div v-for="(paragraph, pIdx) in activePost.content.split('\n\n')" :key="pIdx">
                <h3 v-if="paragraph.startsWith('### ')" class="text-lg font-bold text-cyan-400 mt-6 mb-3">
                  {{ paragraph.replace('### ', '') }}
                </h3>
                <p v-else class="text-sm text-slate-300 leading-relaxed">
                  {{ paragraph }}
                </p>
              </div>
            </div>

            <!-- Tags & Footer -->
            <div class="mt-10 pt-6 border-t border-white/10 flex flex-wrap items-center justify-between gap-4">
              <div class="flex flex-wrap gap-2">
                <span v-for="t in activePost.tags" :key="t" class="px-3 py-1 rounded-lg bg-white/5 border border-white/10 text-xs font-mono text-slate-300">
                  #{{ t }}
                </span>
              </div>

              <button @click="activePost = null" class="px-6 py-2.5 rounded-xl bg-pink-500 hover:bg-pink-600 text-white font-bold text-xs uppercase tracking-wider transition-colors">
                Done Reading
              </button>
            </div>

          </div>
        </div>
      </Transition>

    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useScrollAnimate } from '~/composables/useScrollAnimate'
import { useSupabase, type BlogPost } from '~/composables/useSupabase'

const { sectionRef, isVisible } = useScrollAnimate(0.1)
const { fetchBlogPosts } = useSupabase()

const posts = ref<BlogPost[]>([])
const activeCategory = ref('All')
const searchQuery = ref('')
const activePost = ref<BlogPost | null>(null)

const categories = ['All', 'Mobile Architecture', 'Frontend Engineering', 'Backend Systems']

const filteredPosts = computed(() => {
  return posts.value.filter(post => {
    const matchesCat = activeCategory.value === 'All' || post.category === activeCategory.value
    const query = searchQuery.value.toLowerCase().trim()
    if (!query) return matchesCat

    const matchesTitle = post.title.toLowerCase().includes(query)
    const matchesSummary = post.summary.toLowerCase().includes(query)
    const matchesTags = post.tags.some(t => t.toLowerCase().includes(query))
    return matchesCat && (matchesTitle || matchesSummary || matchesTags)
  })
})

const openPostModal = (post: BlogPost) => {
  activePost.value = post
}

onMounted(async () => {
  const res = await fetchBlogPosts()
  posts.value = res.posts
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
  width: 6px;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(255, 129, 245, 0.4);
  border-radius: 10px;
}
</style>
