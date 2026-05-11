<script setup lang="ts">
import Header from '~/components/Header.vue'
import Footer from '~/components/Footer.vue'
import FloatingChat from '~/components/FloatingChat.vue'
</script>
<template>
  <Header />
  <slot />
  <FloatingChat />
  <Footer />
</template>