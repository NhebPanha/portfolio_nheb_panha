<template>
  <section id="skills" class="section">
    <div ref="sectionRef" class="container-page">
      <SectionHeading
        eyebrow="Skills"
        title="Tools and technologies"
        lead="The stack I use day to day, grouped by where it fits in a product."
      />

      <div class="mt-12 grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
        <article
          v-for="(group, i) in groups"
          :key="group.title"
          class="card reveal p-6"
          :class="{ 'reveal-hidden': !isVisible }"
          :style="{ transitionDelay: `${i * 70}ms` }"
        >
          <div class="flex items-center gap-3">
            <span class="material-symbols-outlined text-[22px] text-primary">{{ group.icon }}</span>
            <h3 class="text-base font-semibold text-on-surface">{{ group.title }}</h3>
          </div>
          <ul class="mt-5 space-y-3">
            <li v-for="skill in group.items" :key="skill.name" class="flex items-center gap-3 text-sm">
              <span class="flex h-8 w-8 shrink-0 items-center justify-center rounded-lg border border-line bg-surface">
                <Icon :name="skill.icon" class="text-base" />
              </span>
              <span class="font-medium text-on-surface">{{ skill.name }}</span>
              <span v-if="skill.note" class="ml-auto text-xs text-on-surface-variant">{{ skill.note }}</span>
            </li>
          </ul>
        </article>

        <!-- Practices -->
        <article class="card reveal p-6 sm:col-span-2 lg:col-span-1" :class="{ 'reveal-hidden': !isVisible }" style="transition-delay: 350ms">
          <div class="flex items-center gap-3">
            <span class="material-symbols-outlined text-[22px] text-primary">verified</span>
            <h3 class="text-base font-semibold text-on-surface">How I work</h3>
          </div>
          <ul class="mt-5 space-y-3">
            <li v-for="practice in practices" :key="practice" class="flex gap-3 text-sm leading-relaxed text-on-surface-variant">
              <span class="material-symbols-outlined mt-0.5 text-[16px] text-emerald-600 dark:text-emerald-400">check</span>
              <span>{{ practice }}</span>
            </li>
          </ul>
        </article>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { useScrollAnimate } from '~/composables/useScrollAnimate'

const { sectionRef, isVisible } = useScrollAnimate(0.05)

const groups = [
  {
    title: 'Mobile',
    icon: 'smartphone',
    items: [
      { name: 'Flutter', icon: 'devicon:flutter', note: 'Primary' },
      { name: 'Dart', icon: 'logos:dart' },
      { name: 'BLoC & Riverpod', icon: 'mdi:state-machine' },
      { name: 'Firebase', icon: 'logos:firebase-icon', note: 'Auth, FCM' }
    ]
  },
  {
    title: 'Frontend',
    icon: 'web',
    items: [
      { name: 'Nuxt', icon: 'logos:nuxt-icon', note: 'Primary' },
      { name: 'Vue 3', icon: 'logos:vue' },
      { name: 'TypeScript', icon: 'logos:typescript-icon' },
      { name: 'Tailwind CSS', icon: 'logos:tailwindcss-icon' }
    ]
  },
  {
    title: 'Backend',
    icon: 'dns',
    items: [
      { name: 'Laravel', icon: 'logos:laravel', note: 'REST APIs' },
      { name: 'Node.js & Express', icon: 'logos:nodejs-icon' },
      { name: 'Supabase', icon: 'logos:supabase-icon', note: 'Auth, RLS' },
      { name: 'Telegram Bot API', icon: 'logos:telegram' }
    ]
  },
  {
    title: 'Data',
    icon: 'database',
    items: [
      { name: 'PostgreSQL', icon: 'logos:postgresql' },
      { name: 'MySQL', icon: 'logos:mysql-icon' },
      { name: 'Redis', icon: 'logos:redis' }
    ]
  },
  {
    title: 'Tooling',
    icon: 'build',
    items: [
      { name: 'Git & GitHub Actions', icon: 'logos:git-icon', note: 'CI/CD' },
      { name: 'Docker', icon: 'logos:docker-icon' },
      { name: 'Figma', icon: 'logos:figma', note: 'Design to code' }
    ]
  }
]

const practices = [
  'Clean architecture with clear separation between UI, state and data layers',
  'Strict typing in TypeScript and Dart to catch errors before release',
  'Database-level security with row-level policies',
  'Responsive, accessible interfaces that work on every screen size'
]
</script>
