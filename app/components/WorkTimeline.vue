<template>
  <section id="timeline" class="section">
    <div ref="sectionRef" class="container-page">
      <SectionHeading
        eyebrow="Experience"
        title="Where I've worked"
        lead="Roles across mobile, web and backend development, most recent first."
      />

      <ol class="relative mt-14 border-l border-line md:ml-[11rem]">
        <li
          v-for="(item, index) in timelineData"
          :key="item.id"
          class="reveal relative pb-12 pl-8 last:pb-0 md:pl-10"
          :class="{ 'reveal-hidden': !isVisible }"
          :style="{ transitionDelay: `${index * 90}ms` }"
        >
          <!-- Marker -->
          <span
            aria-hidden="true"
            class="absolute -left-[7px] top-1.5 h-3.5 w-3.5 rounded-full border-2 border-background"
            :class="index === 0 ? 'bg-primary' : 'bg-line'"
          ></span>

          <!-- Period (sits left of the line on desktop) -->
          <p class="mb-2 font-mono text-xs text-on-surface-variant md:absolute md:-left-[11rem] md:top-1 md:mb-0 md:w-36 md:text-right">
            {{ item.period }}
          </p>

          <div class="flex flex-wrap items-baseline gap-x-3 gap-y-1">
            <h3 class="text-lg font-semibold text-on-surface">{{ item.role }}</h3>
            <span class="chip !py-0.5">{{ item.type }}</span>
          </div>
          <p class="mt-1 text-sm text-on-surface-variant">
            <span class="font-medium text-on-surface">{{ item.company }}</span>
            <span class="mx-1.5">·</span>{{ item.location }}
          </p>

          <p class="mt-4 max-w-3xl text-[15px] leading-relaxed text-on-surface-variant">{{ item.summary }}</p>

          <ul class="mt-4 max-w-3xl space-y-2">
            <li v-for="(highlight, hIdx) in item.highlights" :key="hIdx" class="flex gap-3 text-sm leading-relaxed text-on-surface-variant">
              <span aria-hidden="true" class="mt-2 h-1 w-1 shrink-0 rounded-full bg-on-surface-variant"></span>
              <span>{{ highlight }}</span>
            </li>
          </ul>

          <div class="mt-5 flex flex-wrap gap-1.5">
            <span v-for="t in item.techStack" :key="t" class="chip">{{ t }}</span>
          </div>
        </li>
      </ol>
    </div>
  </section>
</template>

<script setup lang="ts">
import { useScrollAnimate } from '~/composables/useScrollAnimate'

const { sectionRef, isVisible } = useScrollAnimate(0.05)

// TODO: replace the company names and figures below with your real roles.
const timelineData = [
  {
    id: 1,
    period: '2025 — Present',
    role: 'Senior Flutter & Supabase Developer',
    company: 'Cross-Platform Mobile Ecosystems',
    location: 'Phnom Penh / Remote',
    type: 'Full-time',
    summary: 'Building high-performance Flutter mobile applications with real-time Supabase PostgreSQL synchronisation, biometric security, BLoC state isolation and offline caching.',
    highlights: [
      'Engineered a FinTech mobile wallet handling real-time WebSocket transaction feeds.',
      'Designed row-level security (RLS) policies for Supabase PostgreSQL schemas.',
      'Optimised local Hive/Isar caching, reducing initial launch time by 38%.'
    ],
    techStack: ['Flutter', 'Dart', 'Supabase', 'PostgreSQL', 'Firebase', 'BLoC']
  },
  {
    id: 2,
    period: '2024 — 2025',
    role: 'Full-Stack Nuxt & Vue Engineer',
    company: 'Enterprise SaaS Solutions',
    location: 'Phnom Penh',
    type: 'Full-time',
    summary: 'Developed modular server-rendered web applications in Nuxt 3 and Vue 3, with a custom design system and payment gateway integrations.',
    highlights: [
      'Built responsive web portals serving over 50,000 monthly sessions with sub-second page loads.',
      'Integrated Pinia state management with persisted storage for reliable session retention.',
      'Created reusable design tokens and a dark/light theme system.'
    ],
    techStack: ['Nuxt 3', 'Vue 3', 'TypeScript', 'Tailwind CSS', 'Pinia', 'REST API']
  },
  {
    id: 3,
    period: '2023 — 2024',
    role: 'Backend & Database Developer',
    company: 'Cloud Infrastructure & API Services',
    location: 'Phnom Penh',
    type: 'Full-time',
    summary: 'Built REST APIs in Laravel and Node.js with database indexing, background queue jobs and automated Telegram alerting.',
    highlights: [
      'Built financial accounting API endpoints processing daily transactions within atomic database transactions.',
      'Optimised SQL queries and compound indexes, cutting database response latency by 40%.',
      'Integrated Telegram bot alerts for immediate production error reporting.'
    ],
    techStack: ['Laravel', 'Node.js', 'MySQL', 'PostgreSQL', 'Redis', 'Telegram API']
  },
  {
    id: 4,
    period: '2022 — 2023',
    role: 'Junior Mobile & Web Developer',
    company: 'Digital Product Innovation Lab',
    location: 'Phnom Penh',
    type: 'Full-time',
    summary: 'Created cross-platform UI components from high-fidelity Figma designs and set up continuous integration with GitHub Actions.',
    highlights: [
      'Built 15+ reusable Flutter UI widget packages following a shared design system.',
      'Automated multi-platform builds using GitHub Actions CI/CD pipelines.'
    ],
    techStack: ['Flutter', 'JavaScript', 'HTML/CSS', 'Git', 'GitHub Actions', 'Figma']
  }
]
</script>
