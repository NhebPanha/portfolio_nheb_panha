<template>
  <div class="bg-background text-on-background font-body transition-colors duration-500 overflow-hidden relative">
    <!-- Ambient Glows -->
    <div class="absolute top-0 right-0 w-[500px] h-[500px] bg-primary/5 rounded-full blur-[120px] pointer-events-none"></div>
    <div class="absolute bottom-0 left-0 w-[500px] h-[500px] bg-secondary/5 rounded-full blur-[120px] pointer-events-none"></div>

    <section id="skills" class="pt-24 md:pt-40 pb-16 md:pb-32 max-w-7xl mx-auto px-4 md:px-8 relative z-10" ref="sectionRef">

      <!-- Title -->
      <div class="mb-20 transition-all duration-1000 ease-out"
           :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">
        <span class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white/5 border border-white/10 text-primary text-[10px] font-bold tracking-[0.35em] uppercase mb-8">
            <span class="w-1.5 h-1.5 rounded-full bg-primary animate-pulse"></span>
            Specialization
        </span>
        <h2 class="font-headline text-5xl md:text-7xl font-black tracking-tighter leading-[0.85] mb-6">
          Core Technical <br/>
          <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-blue-500 to-pink-500">Ecosystem</span>
        </h2>
        <p class="text-on-surface-variant/70 text-lg max-w-2xl leading-relaxed">
          A curated stack of modern technologies I use to build high-performance, scalable, and user-centric digital solutions.
        </p>
      </div>

      <!-- Skills Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-6">
        <div v-for="(skill, index) in skillList" :key="index" 
             class="group relative p-8 rounded-[2rem] bg-white/[0.02] border border-white/5 hover:border-primary/30 transition-all duration-500 overflow-hidden"
             :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'"
             :style="{ transitionDelay: isVisible ? `${index * 80}ms` : '0ms' }">
          
          <!-- Hover Background -->
          <div class="absolute inset-0 bg-gradient-to-br from-primary/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>

          <!-- Icon Container -->
          <div class="relative z-10 w-14 h-14 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center mb-6 group-hover:scale-110 group-hover:bg-primary/10 group-hover:border-primary/20 transition-all duration-500">
            <Icon :name="skill.icon" class="text-3xl" />
          </div>

          <!-- Content -->
          <div class="relative z-10">
            <h3 class="text-xl font-bold text-on-surface mb-2 group-hover:text-primary transition-colors duration-300">
              {{ skill.name }}
            </h3>
            <p class="text-sm text-on-surface-variant/60 leading-relaxed">
              {{ skill.desc }}
            </p>
          </div>

          <!-- Decorative Glow -->
          <div class="absolute -bottom-4 -right-4 w-16 h-16 bg-primary/10 rounded-full blur-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
        </div>
      </div>

    </section>
  </div>
</template>

<script setup lang="ts">
const skillList = [
  { name: 'Flutter & Dart', icon: 'logos:flutter', desc: 'Cross-platform mobile apps with native performance.' },
  { name: 'Vue.js & Nuxt', icon: 'logos:nuxt-icon', desc: 'Modern web apps with SSR and reactive architecture.' },
  { name: 'Laravel', icon: 'logos:laravel', desc: 'Secure and scalable backend systems and RESTful APIs.' },
  { name: 'Supabase', icon: 'logos:supabase-icon', desc: 'Real-time databases, authentication, and cloud functions.' },
  { name: 'Firebase', icon: 'logos:firebase', desc: 'Cloud infrastructure, hosting, and serverless functions.' },
  { name: 'Tailwind CSS', icon: 'logos:tailwindcss-icon', desc: 'Utility-first styling for fast, responsive UI development.' },
  { name: 'PostgreSQL', icon: 'logos:postgresql', desc: 'Relational database for complex data structures.' },
  { name: 'Git & GitHub', icon: 'logos:git-icon', desc: 'Version control, CI/CD, and deployment workflows.' }
]

const { sectionRef, isVisible } = useScrollAnimate(0.1)
</script>