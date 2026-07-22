<template>
  <div class="bg-background text-on-background font-body transition-colors duration-500 overflow-hidden relative">
    <!-- Ambient Glows -->
    <div class="absolute top-0 right-0 w-[500px] h-[500px] bg-primary/5 rounded-full blur-[120px] pointer-events-none"></div>
    <div class="absolute bottom-0 left-0 w-[500px] h-[500px] bg-secondary/5 rounded-full blur-[120px] pointer-events-none"></div>

    <section id="skills" class="pt-24 md:pt-36 pb-20 md:pb-32 max-w-7xl mx-auto px-4 md:px-8 relative z-10" ref="sectionRef">

      <!-- Header -->
      <div class="mb-16 transition-all duration-1000 ease-out"
           :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">
        <span class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 text-primary text-[10px] font-bold tracking-[0.35em] uppercase mb-6">
            <span class="w-1.5 h-1.5 rounded-full bg-primary animate-pulse"></span>
            Technical Expertise
        </span>
        <h2 class="font-headline text-4xl sm:text-6xl md:text-7xl font-black tracking-tighter leading-[0.85] mb-6">
          Core Technical <br/>
          <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-blue-500 to-pink-500">Specialization</span>
        </h2>
        <p class="text-on-surface-variant/80 text-base md:text-lg max-w-2xl leading-relaxed">
          Production-proven mastery across mobile frameworks, cloud data platforms, serverless backends, and UI architectural patterns.
        </p>
      </div>

      <!-- Skills Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <div v-for="(skill, index) in skillList" :key="index" 
             class="group relative p-7 rounded-[2rem] bg-white/40 dark:bg-white/[0.02] border border-black/5 dark:border-white/10 hover:border-primary/40 transition-all duration-500 overflow-hidden flex flex-col justify-between"
             :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'"
             :style="{ transitionDelay: isVisible ? `${index * 70}ms` : '0ms' }">
          
          <!-- Card Top -->
          <div>
            <!-- Hover Glow Overlay -->
            <div class="absolute inset-0 bg-gradient-to-br from-primary/5 via-cyan-400/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500 pointer-events-none"></div>

            <!-- Icon & Category -->
            <div class="flex justify-between items-center mb-6 relative z-10">
              <div class="w-14 h-14 rounded-2xl bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 flex items-center justify-center group-hover:scale-110 group-hover:bg-primary/10 group-hover:border-primary/30 transition-all duration-500">
                <Icon :name="skill.icon" class="text-3xl text-on-surface" />
              </div>
              <span class="text-[10px] font-mono font-bold text-cyan-400 uppercase tracking-wider px-2.5 py-1 rounded-full bg-cyan-400/10 border border-cyan-400/20">
                {{ skill.level }}%
              </span>
            </div>

            <!-- Title & Description -->
            <div class="relative z-10 mb-6">
              <h3 class="text-xl font-bold text-on-surface mb-2 group-hover:text-primary transition-colors duration-300">
                {{ skill.name }}
              </h3>
              <p class="text-xs text-on-surface-variant/80 leading-relaxed">
                {{ skill.desc }}
              </p>
            </div>
          </div>

          <!-- Card Bottom: Proficiency Meter -->
          <div class="relative z-10 pt-4 border-t border-black/5 dark:border-white/5">
            <div class="flex justify-between text-[10px] font-bold uppercase tracking-wider text-on-surface-variant mb-1.5">
              <span>Proficiency</span>
              <span>{{ skill.level >= 90 ? 'Master' : 'Advanced' }}</span>
            </div>
            <div class="w-full h-2 rounded-full bg-black/5 dark:bg-white/10 overflow-hidden">
              <div class="h-full rounded-full bg-gradient-to-r from-primary via-cyan-400 to-pink-400 transition-all duration-1000"
                   :style="{ width: isVisible ? `${skill.level}%` : '0%' }"></div>
            </div>
          </div>

        </div>
      </div>

    </section>
  </div>
</template>

<script setup lang="ts">
import { useScrollAnimate } from '~/composables/useScrollAnimate'

const skillList = [
  { name: 'Flutter & Dart', icon: 'logos:flutter', level: 95, desc: 'Cross-platform mobile apps with native performance, custom BLoC/Riverpod state, and offline caching.' },
  { name: 'Supabase', icon: 'logos:supabase-icon', level: 90, desc: 'Real-time PostgreSQL databases, authentication, serverless functions, and Row Level Security.' },
  { name: 'Nuxt.js & Vue 3', icon: 'logos:nuxt-icon', level: 92, desc: 'Modern web apps with SSR, static generation, Pinia state, and dynamic routing.' },
  { name: 'Laravel API', icon: 'logos:laravel', level: 88, desc: 'Secure backend microservices, RESTful APIs, Eloquent ORM, and queue management.' },
  { name: 'Tailwind CSS', icon: 'logos:tailwindcss-icon', level: 96, desc: 'Utility-first modern styling, dark mode glassmorphism, and responsive layout grids.' },
  { name: 'PostgreSQL & MySQL', icon: 'logos:postgresql', level: 86, desc: 'Relational database schema modeling, indexing optimization, and SQL analytics queries.' },
  { name: 'Firebase', icon: 'logos:firebase', level: 88, desc: 'Cloud Firestore, Auth, Push Notifications, Cloud Messaging, and hosting workflows.' },
  { name: 'Git & DevOps', icon: 'logos:git-icon', level: 90, desc: 'Version control, GitHub Actions CI/CD pipelines, automated deployments, and release tags.' }
]

const { sectionRef, isVisible } = useScrollAnimate(0.1)
</script>