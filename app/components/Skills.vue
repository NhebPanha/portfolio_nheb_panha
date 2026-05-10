<template>
  <div class="bg-background text-on-background font-body transition-colors duration-500">

    <section id="skills" class="pt-24 md:pt-32 pb-16 md:pb-24 max-w-7xl mx-auto px-4 md:px-8" ref="sectionRef">

      <!-- Title -->
      <div class="text-center mb-16 transition-all duration-700 ease-out"
           :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'">
        <span class="text-xs tracking-[0.2em] text-primary uppercase mb-4 block">
          Core Competencies
        </span>
        <h2 class="text-4xl md:text-5xl font-black tracking-tighter leading-none">
          My <span class="text-tertiary">Skills</span>
        </h2>
      </div>

      <!-- Skills -->
      <div class="grid grid-cols-2 md:grid-cols-4 gap-6">

        <div v-for="(skill, index) in skills" :key="index" 
             class="glass-panel p-6 text-center font-semibold flex items-center justify-center 
                    hover:-translate-y-2 hover:shadow-xl hover:shadow-primary/20 hover:text-primary
                    transition-all duration-500 ease-out cursor-pointer"
             :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'"
             :style="{ transitionDelay: isVisible ? `${index * 100}ms` : '0ms' }">
          {{ skill }}
        </div>

      </div>

    </section>

  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'

const skills = [
  'Flutter & Dart',
  'Vue.js 3 / Nuxt 4',
  'Laravel (API Development)',
  'Supabase (Auth & DB)',
  'RESTful API Integration',
  'Firebase',
  'Tailwind CSS',
  'Git & GitHub'
]

const { sectionRef, isVisible } = useScrollAnimate(0.1)
</script>

<style scoped>
.glass-panel {
  background: rgba(255, 255, 255, 0.4);
  backdrop-filter: blur(12px);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.15);
}

.dark .glass-panel {
  background: rgba(131, 130, 130, 0.144);
  border: 1px solid rgba(255, 255, 255, 0.05);
}
</style>