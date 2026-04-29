<template>
  <div class="bg-background text-on-background font-body transition-colors duration-500">

    <section id="skills" class="pt-24 md:pt-32 pb-16 md:pb-24 max-w-7xl mx-auto px-4 md:px-8">

      <!-- Title -->
      <div class="text-center mb-16">
        <span class="text-xs tracking-[0.2em] text-primary uppercase mb-4 block">
          Core Competencies
        </span>
        <h2 class="text-4xl md:text-5xl font-black tracking-tighter leading-none">
          My <span class="text-tertiary">Skills</span>
        </h2>
      </div>

      <!-- Skills -->
      <div class="grid grid-cols-2 md:grid-cols-4 gap-6">

        <div v-for="(skill, index) in skills" :key="index" class="glass-panel p-6 text-center font-semibold flex items-center justify-center 
                 hover:-translate-y-2 hover:shadow-lg transition-all duration-300">
          {{ skill }}
        </div>

      </div>

    </section>

  </div>
</template>

<script setup lang="ts">
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