<template>
  <header :class="['max-w-3xl', center ? 'mx-auto text-center' : '']">
    <span class="eyebrow">{{ eyebrow }}</span>
    <h2 class="section-title">{{ title }}</h2>
    <p v-if="lead" :class="['section-lead', center ? 'mx-auto' : '']">{{ lead }}</p>
  </header>
</template>

<script setup lang="ts">
defineProps<{
  eyebrow: string
  title: string
  lead?: string
  center?: boolean
}>()
</script>
