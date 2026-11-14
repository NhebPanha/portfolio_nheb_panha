<template>
  <a href="#about"
     class="sr-only focus:not-sr-only focus:fixed focus:top-3 focus:left-3 focus:z-[200] focus:px-4 focus:py-2 focus:rounded-lg focus:bg-primary focus:text-white focus:text-xs focus:font-bold">
    Skip to content
  </a>
  <Header />
  <div id="main">
    <slot />
  </div>
  <Footer />
  <FloatingChat />
</template>
