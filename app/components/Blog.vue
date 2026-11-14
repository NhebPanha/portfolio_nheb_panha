<template>
  <section id="blog" class="section section-alt">
    <div ref="sectionRef" class="container-page">
      <SectionHeading
        eyebrow="Writing"
        title="Notes and articles"
        lead="Short write-ups on mobile architecture, frontend performance and backend systems."
      />

      <div class="mt-12 grid gap-5 md:grid-cols-2 lg:grid-cols-3">
        <article
          v-for="(post, index) in posts"
          :key="post.id || index"
          class="card card-hover reveal group relative flex flex-col p-6"
          :class="{ 'reveal-hidden': !isVisible }"
          :style="{ transitionDelay: `${index * 80}ms` }"
        >
          <div class="flex items-center gap-2 text-xs text-on-surface-variant">
            <span class="font-semibold uppercase tracking-wider text-primary">{{ post.category }}</span>
            <span aria-hidden="true">·</span>
            <time>{{ post.published_at }}</time>
          </div>

          <h3 class="mt-3 text-lg font-semibold leading-snug text-on-surface">
            <button class="text-left after:absolute after:inset-0 focus:outline-none" @click="activePost = post">
              {{ post.title }}
            </button>
          </h3>
          <p class="mt-3 line-clamp-3 text-sm leading-relaxed text-on-surface-variant">{{ post.summary }}</p>

          <div class="mt-auto flex items-center justify-between pt-6 text-sm">
            <span class="text-on-surface-variant">{{ post.read_time }}</span>
            <span class="inline-flex items-center gap-1 font-medium text-primary">
              Read
              <span class="material-symbols-outlined text-[16px] transition-transform group-hover:translate-x-0.5">arrow_forward</span>
            </span>
          </div>
        </article>
      </div>
    </div>

    <!-- Reader -->
    <Teleport to="body">
      <Transition name="modal">
        <div v-if="activePost" class="fixed inset-0 z-[100] flex items-center justify-center p-4">
          <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" @click="activePost = null"></div>

          <article
            role="dialog"
            aria-modal="true"
            :aria-label="activePost.title"
            class="card relative z-10 max-h-[90vh] w-full max-w-2xl overflow-y-auto p-6 shadow-2xl sm:p-10"
          >
            <button
              class="absolute right-4 top-4 flex h-9 w-9 items-center justify-center rounded-lg text-on-surface-variant hover:bg-surface hover:text-on-surface"
              aria-label="Close"
              @click="activePost = null"
            >
              <span class="material-symbols-outlined text-[20px]">close</span>
            </button>

            <div class="flex items-center gap-2 pr-10 text-xs text-on-surface-variant">
              <span class="font-semibold uppercase tracking-wider text-primary">{{ activePost.category }}</span>
              <span aria-hidden="true">·</span>
              <span>{{ activePost.published_at }}</span>
              <span aria-hidden="true">·</span>
              <span>{{ activePost.read_time }}</span>
            </div>

            <h2 class="mt-3 text-2xl font-semibold leading-tight text-on-surface sm:text-3xl">{{ activePost.title }}</h2>
            <p class="mt-2 text-sm text-on-surface-variant">By {{ activePost.author }}</p>

            <div class="mt-8 space-y-4 border-t border-line pt-8">
              <template v-for="(paragraph, pIdx) in activePost.content.split('\n\n')" :key="pIdx">
                <h3 v-if="paragraph.startsWith('### ')" class="pt-2 text-lg font-semibold text-on-surface">
                  {{ paragraph.replace('### ', '') }}
                </h3>
                <p v-else class="text-[15px] leading-7 text-on-surface-variant">{{ paragraph }}</p>
              </template>
            </div>

            <div class="mt-8 flex flex-wrap gap-2 border-t border-line pt-6">
              <span v-for="t in activePost.tags" :key="t" class="chip">{{ t }}</span>
            </div>
          </article>
        </div>
      </Transition>
    </Teleport>
  </section>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, onBeforeUnmount } from 'vue'
import { useScrollAnimate } from '~/composables/useScrollAnimate'
import { useSupabase, type BlogPost } from '~/composables/useSupabase'

const { sectionRef, isVisible } = useScrollAnimate(0.05)
const { fetchBlogPosts } = useSupabase()

const posts = ref<BlogPost[]>([])
const activePost = ref<BlogPost | null>(null)

const onKeydown = (e: KeyboardEvent) => {
  if (e.key === 'Escape') activePost.value = null
}
watch(activePost, (open) => {
  document.body.style.overflow = open ? 'hidden' : ''
})
onBeforeUnmount(() => {
  window.removeEventListener('keydown', onKeydown)
  document.body.style.overflow = ''
})

onMounted(async () => {
  window.addEventListener('keydown', onKeydown)
  const res = await fetchBlogPosts()
  posts.value = res.posts
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
