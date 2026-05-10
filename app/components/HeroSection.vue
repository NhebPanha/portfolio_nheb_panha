<template>
  <div id="hero" class="bg-background text-on-background font-body min-h-screen transition-colors duration-500">
    <!-- Hero Section -->
    <main class="relative min-h-screen flex items-center overflow-hidden bg-grid-pattern pt-20" ref="sectionRef">
      <!-- ✅ Animated Background Layers -->
      <div class="absolute inset-0 overflow-hidden">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
      </div>
      <div class="particles"></div>
      <!-- Content -->
      <div class="max-w-7xl mx-auto px-4 md:px-8 w-full grid grid-cols-1 lg:grid-cols-12 gap-8 md:gap-12 items-center">

        <!-- Hero Content -->
        <div class="lg:col-span-7 z-10 transition-all duration-1000 ease-out"
             :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">
          <div
            class="inline-block bg-tertiary-container text-on-tertiary-container px-3 py-1 text-[10px] tracking-[0.2em] uppercase mb-6">
            Digital Craftsman // v2.0
          </div>

          <h1 class="text-5xl md:text-7xl lg:text-8xl font-black leading-[0.9] mb-8 mt-4 md:mt-0">
            NHEB
            <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-blue-500 to-pink-500">
              Panha
            </span>
          </h1>

          <div class="flex items-center gap-4 mb-8">
            <div class="h-[1px] w-12 bg-outline-variant/30"></div>
            <p class="text-xl uppercase">
              Flutter Developer <span class="text-secondary mx-2">/</span> Full Stack Architect
            </p>
          </div>

          <p class="text-lg max-w-lg mb-12 leading-relaxed text-on-surface-variant">
            Architecting seamless mobile experiences and robust backends with high-fidelity precision.
          </p>

          <div class="flex flex-wrap gap-6">
            <button class="btn-primary hover:-translate-y-1 hover:shadow-[0_0_20px_rgba(129,28,217,0.6)] transition-all">
              View My Work
            </button>

            <button class="btn-outline hover:-translate-y-1 hover:bg-cyan-400/10 transition-all">
              Contact Me
            </button>
          </div>
        </div>
        <!-- Profile Image -->
        <div class="lg:col-span-5 relative flex justify-center lg:justify-end mt-12 lg:mt-0 transition-all duration-1000 ease-out delay-300"
             :class="isVisible ? 'opacity-100 translate-x-0' : 'opacity-0 translate-x-12'">
          <div class="relative w-64 h-64 sm:w-80 sm:h-80 lg:w-96 lg:h-96 hover:scale-105 transition-transform duration-500">

            <div class="ring ring-1"></div>
            <div class="ring ring-2"></div>

            <!-- Floating Tags -->
            <div class="tag left-tag">Dart Specialist</div>
            <div class="tag right-tag">Cloud Architect</div>

            <div class="profile-img">
              <img src="/image/panha_profile.png" class="object-cover" />
            </div>

          </div>
        </div>

      </div>

      <!-- Infinite Skill Marquee -->
      <div class="absolute bottom-0 left-0 w-full overflow-hidden bg-background/40 backdrop-blur-md border-t border-white/5 py-4 z-20">
        <div class="marquee-container flex whitespace-nowrap">
          <div class="marquee-content flex gap-8 md:gap-16 items-center px-8">
            <span v-for="skill in skills" :key="skill" class="text-xs md:text-sm font-black tracking-[0.2em] uppercase text-on-surface-variant opacity-70 flex items-center gap-3">
              <span class="w-1.5 h-1.5 rounded-full bg-secondary shadow-[0_0_8px_rgba(0,251,251,0.8)]"></span>
              {{ skill }}
            </span>
          </div>
          <!-- Duplicate for seamless loop -->
          <div class="marquee-content flex gap-8 md:gap-16 items-center px-8" aria-hidden="true">
            <span v-for="skill in skills" :key="skill + '-dup'" class="text-xs md:text-sm font-black tracking-[0.2em] uppercase text-on-surface-variant opacity-70 flex items-center gap-3">
              <span class="w-1.5 h-1.5 rounded-full bg-secondary shadow-[0_0_8px_rgba(0,251,251,0.8)]"></span>
              {{ skill }}
            </span>
          </div>
        </div>
      </div>

      <!-- Scroll Indicator -->
      <div class="scroll-indicator transition-opacity duration-1000 delay-700 z-10"
           :class="isVisible ? 'opacity-50' : 'opacity-0'">
        <span>Initiate Scroll</span>
        <div></div>
      </div>

    </main>
  </div>
</template>

<!-- Light and Dark Theme Toggle -->
<script setup>
import { ref, onMounted } from 'vue'

const { sectionRef, isVisible } = useScrollAnimate(0.1)

const isDark = ref(false)

const skills = [
  'Flutter', 'Vue.js', 'Nuxt.js', 'Laravel', 'Tailwind CSS', 'Supabase', 'Firebase', 'Dart', 'MySQL', 'PostgreSQL', 'TypeScript', 'Node.js'
]

const toggleDark = () => {
  isDark.value = !isDark.value
  document.documentElement.classList.toggle('dark')

  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

onMounted(() => {
  const savedTheme = localStorage.getItem('theme')

  if (savedTheme === 'dark') {
    isDark.value = true
    document.documentElement.classList.add('dark')
  }
})
</script>

<style scoped>
/* ================= BACKGROUND ================= */
/* LIGHT MODE (default) */
.bg-grid-pattern {
  background-image:
    linear-gradient(to right, rgba(0, 0, 0, 0.06) 1px, transparent 1px),
    linear-gradient(to bottom, rgba(0, 0, 0, 0.06) 1px, transparent 1px);
  background-size: 40px 40px;
  animation: moveGrid 20s linear infinite;
}

/* DARK MODE */
.dark .bg-grid-pattern {
  background-image:
    linear-gradient(to right, rgba(255, 255, 255, 0.15) 1px, transparent 1px),
    linear-gradient(to bottom, rgba(255, 255, 255, 0.15) 1px, transparent 1px);
}

@keyframes moveGrid {
  from {
    background-position: 0 0;
  }

  to {
    background-position: 40px 40px;
  }
}

/* ================= BLOBS ================= */
.blob {
  position: absolute;
  width: 400px;
  height: 400px;
  border-radius: 50%;
  filter: blur(120px);
  opacity: 0.4;
  animation: floatBlob 12s infinite ease-in-out alternate;
}

.blob-1 {
  background: #811cd9;
  top: -10%;
  right: -5%;
}

.blob-2 {
  background: #00fbfb;
  bottom: -10%;
  left: -5%;
  animation-delay: 4s;
}

@keyframes floatBlob {
  0% {
    transform: translate(0, 0) scale(1);
  }

  100% {
    transform: translate(-60px, 60px) scale(1.2);
  }
}

/* ================= PARTICLES ================= */

.particles {
  position: absolute;
  inset: 0;
  background-image: radial-gradient(circle, rgba(0, 251, 251, 0.4) 1px, transparent 1px);
  background-size: 60px 60px;
  animation: particleMove 30s linear infinite;
  opacity: 0.2;
}

@keyframes particleMove {
  from {
    transform: translateY(0);
  }

  to {
    transform: translateY(-200px);
  }
}

/* ================= PROFILE ================= */

.profile-img {
  border-radius: 50%;
  overflow: hidden;
  border: 4px solid #111;
  position: relative;
  z-index: 10;
}

.dark .profile-img {
  border-color: #f5f5f5;
}

.ring {
  position: absolute;
  inset: -20px;
  border-radius: 50%;
  border: 1px solid rgba(129, 28, 217, 0.2);
  animation: pulse 3s infinite;
}

.ring-2 {
  inset: -40px;
  border-color: rgba(0, 251, 251, 0.2);
  animation-delay: 1s;
}

@keyframes pulse {

  0%,
  100% {
    transform: scale(1);
    opacity: 0.6;
  }

  50% {
    transform: scale(1.05);
    opacity: 1;
  }
}

/* ================= TAGS ================= */

.tag {
  position: absolute;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  padding: 8px 12px;
  font-size: 10px;
  text-transform: uppercase;
}

.left-tag {
  top: 0;
  left: -20px;
  border-left: 4px solid #811cd9;
}

.right-tag {
  bottom: -5px;
  right: -20px;
  border-left: 4px solid #00fbfb;
}

/* ================= BUTTONS ================= */

.btn-primary {
  background: #811cd9;
  padding: 16px 28px;
  text-transform: uppercase;
  font-weight: bold;
  transition: 0.3s;
}

.btn-primary:hover {
  box-shadow: 0 0 20px rgba(129, 28, 217, 0.6);
}

.btn-outline {
  border: 1px solid #00fbfb;
  padding: 16px 28px;
  color: #00fbfb;
}

.btn-outline:hover {
  background: rgba(0, 251, 251, 0.1);
}

/* ================= SCROLL ================= */

.scroll-indicator {
  position: absolute;
  bottom: 40px;
  left: 50%;
  transform: translateX(-50%);
  text-align: center;
  font-size: 10px;
  opacity: 0.5;
}

.scroll-indicator div {
  width: 1px;
  height: 40px;
  background: linear-gradient(#811cd9, transparent);
  margin: auto;
}

/* ================= HOVER EFFECT ================= */

main:hover .blob {
  filter: blur(150px);
  opacity: 0.6;
}

/* ================= MARQUEE ================= */
.marquee-container {
  display: flex;
  width: max-content;
  animation: scrollMarquee 30s linear infinite;
}

.marquee-container:hover {
  animation-play-state: paused;
}

@keyframes scrollMarquee {
  0% { transform: translateX(0); }
  100% { transform: translateX(-50%); }
}
</style>