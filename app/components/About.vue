<template>
  <section id="about" class="section section-alt">
    <div ref="sectionRef" class="container-page grid gap-12 lg:grid-cols-12">
      <!-- Story -->
      <div class="reveal lg:col-span-5" :class="{ 'reveal-hidden': !isVisible }">
        <SectionHeading eyebrow="About" title="Developer with an eye for detail and data" />
        <div class="mt-6 space-y-4 text-base leading-relaxed text-on-surface-variant">
          <p>
            I'm a full-stack developer based in Phnom Penh who specialises in cross-platform mobile
            apps with Flutter and modern web applications with Nuxt and Vue.
          </p>
          <p>
            Before software, I trained in accounting. That shapes how I work: careful data modelling,
            predictable state, and interfaces that make complex information easy to read.
          </p>
          <p>
            I care about clean architecture, strict typing and shipping things that hold up in
            production, and I enjoy owning a feature from database schema to final pixel.
          </p>
        </div>

        <div class="mt-8 flex flex-wrap gap-2">
          <span v-for="tech in coreStack" :key="tech.name" class="chip">
            <Icon :name="tech.icon" class="text-sm" />
            {{ tech.name }}
          </span>
        </div>
      </div>

      <!-- Services -->
      <div class="lg:col-span-7">
        <div class="grid gap-4 sm:grid-cols-2">
          <article
            v-for="(item, i) in services"
            :key="item.title"
            class="card card-hover reveal p-6"
            :class="{ 'reveal-hidden': !isVisible }"
            :style="{ transitionDelay: `${i * 80}ms` }"
          >
            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
              <span class="material-symbols-outlined text-[22px]">{{ item.icon }}</span>
            </div>
            <h3 class="mt-4 text-base font-semibold text-on-surface">{{ item.title }}</h3>
            <p class="mt-2 text-sm leading-relaxed text-on-surface-variant">{{ item.body }}</p>
          </article>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { useScrollAnimate } from '~/composables/useScrollAnimate'

const { sectionRef, isVisible } = useScrollAnimate(0.1)

const coreStack = [
  { name: 'Flutter', icon: 'devicon:flutter' },
  { name: 'Dart', icon: 'logos:dart' },
  { name: 'Nuxt', icon: 'logos:nuxt-icon' },
  { name: 'Vue', icon: 'logos:vue' },
  { name: 'Laravel', icon: 'logos:laravel' },
  { name: 'Supabase', icon: 'logos:supabase-icon' },
  { name: 'PostgreSQL', icon: 'logos:postgresql' },
  { name: 'TypeScript', icon: 'logos:typescript-icon' }
]

const services = [
  {
    icon: 'smartphone',
    title: 'Mobile apps',
    body: 'Cross-platform Flutter apps for iOS and Android with clean state management (BLoC, Riverpod) and offline support.'
  },
  {
    icon: 'web',
    title: 'Web applications',
    body: 'Fast, responsive Nuxt and Vue apps with TypeScript, accessible UI and a maintainable component structure.'
  },
  {
    icon: 'dns',
    title: 'Backends & APIs',
    body: 'REST APIs in Laravel and Node.js, authentication, background jobs and integrations such as payments and Telegram.'
  },
  {
    icon: 'database',
    title: 'Data & databases',
    body: 'PostgreSQL and MySQL schema design, Supabase with row-level security, and reporting for finance-style data.'
  }
]
</script>
