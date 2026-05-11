<template>
  <div class="bg-background text-on-background font-body min-h-screen transition-colors duration-500">

    <!-- ================= EXPERIENCE ================= -->
    <section id="experience" class="pt-24 md:pt-32 pb-16 md:pb-24 max-w-7xl mx-auto px-4 md:px-8" ref="experienceRef">

      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 md:gap-12">

        <!-- Left Panel -->
        <div class="lg:col-span-4 sticky top-32 h-fit transition-all duration-700 ease-out"
             :class="expVisible ? 'opacity-100 translate-x-0' : 'opacity-0 -translate-x-12'">

          <span class="text-xs tracking-[0.2em] text-primary uppercase mb-4 block">
            Professional Journey
          </span>

          <h2 class="text-4xl md:text-5xl font-black leading-none mb-8">
            The <span class="text-secondary-fixed-dim">Development</span><br />
            Timeline
          </h2>

          <p class="text-on-surface-variant text-lg leading-relaxed max-w-xs">
            Building modern mobile and web applications with scalable architecture and clean UI design.
          </p>

        </div>

        <!-- Timeline -->
        <div class="lg:col-span-8 relative pl-12 md:pl-24 transition-all duration-1000 ease-out"
             :class="expVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">

          <!-- Vertical Line -->
          <div class="absolute left-4 md:left-12 top-0 bottom-0 w-px timeline-line opacity-30"></div>

          <!-- Items -->
          <div v-for="(item, index) in experiences" :key="index" class="relative mb-24 group transition-all duration-700 ease-out"
            :class="expVisible ? 'opacity-100 translate-x-0' : 'opacity-0 translate-x-12'"
            :style="{ transitionDelay: expVisible ? `${index * 200}ms` : '0ms' }">

            <!-- Dot/Icon (Small like old) -->
            <div class="absolute -left-11 md:-left-[60px] top-2 w-6 h-6 md:w-6 md:h-6 rounded-full border-[3px] border-background z-10 flex items-center justify-center transition-all duration-300 group-hover:scale-125"
              :class="item.dotColor">
              <span class="material-symbols-outlined text-[10px] text-white">{{ item.icon }}</span>
            </div>

            <!-- Card -->
            <div class="glass-panel p-8 hover:-translate-y-2 hover:shadow-xl transition-all duration-300 cursor-pointer"
              @click="item.showDetails = !item.showDetails">

              <span class="text-[10px] tracking-widest uppercase font-bold block mb-2 text-secondary-dim">
                {{ item.year }}
              </span>

              <h3 class="text-2xl font-bold mb-1">
                {{ item.role }}
              </h3>

              <p class="text-sm mb-4" :class="item.textColor">
                {{ item.company }}
              </p>

              <p v-if="item.showDetails" class="text-sm text-on-surface-variant mb-4">
                {{ item.description }}
              </p>

              <div v-if="item.showDetails" class="flex flex-wrap gap-2 mb-4">
                <span v-for="tech in item.tech" :key="tech"
                  class="bg-surface-container px-3 py-1 text-[10px] uppercase rounded">
                  {{ tech }}
                </span>
              </div>

              <div class="text-xs text-on-surface-variant">
                {{ item.showDetails ? 'Click to collapse' : 'Click to expand' }}
              </div>

            </div>

          </div>

        </div>

      </div>
    </section>

    <!-- ================= CONTACT ================= -->
    <section id="contact" class="pb-16 md:pb-24 max-w-7xl mx-auto px-4 md:px-8" ref="contactRef">

      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 md:gap-12 transition-all duration-700 ease-out"
           :class="contactVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">

        <!-- Info -->
        <div class="lg:col-span-5">
          <h2 class="text-4xl md:text-5xl font-black mb-12">
            Let's <br />
            <span class="text-tertiary">Connect</span>
          </h2>

          <div class="space-y-12">
            <div>
              <span class="text-xs uppercase block mb-2">Email</span>
              <p class="text-2xl font-bold">your.email@example.com</p>
            </div>

            <div>
              <span class="text-xs uppercase block mb-2">Location</span>
              <p class="text-2xl font-bold">Cambodia</p>
            </div>
          </div>
        </div>

        <!-- Form -->
        <div class="lg:col-span-7">
          <div class="glass-panel p-8 md:p-12 hover:shadow-xl transition-shadow duration-300">

            <form @submit.prevent="handleSubmit" class="space-y-6">

              <div class="ios-group shadow-sm">
                <div class="ios-row">
                  <span class="ios-label font-medium">Name</span>
                  <input v-model="form.name" placeholder="John Doe" class="ios-input" />
                </div>
                <div class="ios-row">
                  <span class="ios-label font-medium">Email</span>
                  <input v-model="form.email" type="email" placeholder="john@example.com" class="ios-input" />
                </div>
              </div>

              <div class="ios-group shadow-sm">
                <div class="ios-row items-start pt-4">
                  <textarea v-model="form.message" rows="5" placeholder="Message..."
                    class="ios-input resize-none w-full"></textarea>
                </div>
              </div>

              <button type="submit" :disabled="isSubmitting" class="w-full bg-[#007aff] hover:bg-[#005bb5] text-white font-semibold text-[17px] py-3.5 rounded-xl transition-colors duration-300 disabled:opacity-50 disabled:cursor-not-allowed shadow-md">
                {{ isSubmitting ? 'Sending...' : 'Send Message' }}
              </button>

            </form>

          </div>
        </div>

      </div>

    </section>

  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
const { sectionRef: experienceRef, isVisible: expVisible } = useScrollAnimate(0.1)
const { sectionRef: contactRef, isVisible: contactVisible } = useScrollAnimate(0.1)

/* ================= EXPERIENCE ================= */
const experiences = [
  {
    year: "2025 — Present",
    role: "Flutter Developer",
    company: "Mobile App Development",
    icon: "smartphone",
    description:
      "Building mobile applications such as grocery apps, wallet systems, and delivery tracking apps using Flutter with Supabase and Firebase integration.",
    tech: ["Flutter", "Dart", "Supabase", "Firebase"],
    dotColor: "bg-primary shadow-[0_0_15px_rgba(129,28,217,0.8)]",
    textColor: "text-primary",
    showDetails: false,
  },
  {
    year: "2024 — 2025",
    role: "Frontend Developer",
    company: "Web Applications",
    icon: "web",
    description:
      "Developed responsive web applications using Vue 3 and Nuxt 4 with modern UI design and API integration.",
    tech: ["Vue 3", "Nuxt 4", "Tailwind CSS", "TypeScript"],
    dotColor: "bg-secondary shadow-[0_0_15px_rgba(0,251,251,0.8)]",
    textColor: "text-secondary",
    showDetails: false,
  },
  {
    year: "2023 — 2024",
    role: "Backend Developer",
    company: "API Development",
    icon: "api",
    description:
      "Created RESTful APIs and backend systems using Laravel and Node.js with authentication and database management.",
    tech: ["Laravel", "Node.js", "MySQL", "REST API"],
    dotColor: "bg-tertiary shadow-[0_0_15px_rgba(255,129,245,0.8)]",
    textColor: "text-tertiary",
    showDetails: false,
  },
];

/* ================= CONTACT FORM ================= */
const form = reactive({
  name: "",
  email: "",
  message: "",
});

const isSubmitting = ref(false);

const handleSubmit = async () => {
  if (isSubmitting.value) return;
  isSubmitting.value = true;

  try {
    await $fetch('/api/contact', {
      method: 'POST',
      body: form,
    });
    alert('Message sent successfully! I will get back to you soon.');
    // Clear form
    form.name = '';
    form.email = '';
    form.message = '';
  } catch (error) {
    console.error('Error sending message:', error.data);
    // alert('Failed to send message. Please ensure you have configured your Telegram credentials in the .env file.');
  } finally {
    isSubmitting.value = false;
  }
};
</script>

<style scoped>
/* Glass */
.glass-panel {
  background-color: var(--glass-bg);
  backdrop-filter: blur(16px);
  border: 1px solid var(--glass-border);
  border-radius: 20px;
}

/* iOS Form Styles */
.ios-group {
  background-color: var(--glass-bg);
  border: 1px solid var(--glass-border);
  border-radius: 16px;
  overflow: hidden;
}

.ios-row {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid var(--glass-border);
}

.ios-row:last-child {
  border-bottom: none;
}

.ios-label {
  width: 80px;
  font-size: 17px;
  color: #333;
}

.dark .ios-label {
  color: #ccc;
}

.ios-input {
  flex: 1;
  background: transparent;
  border: none;
  outline: none;
  font-size: 17px;
  color: #000;
}

.dark .ios-input {
  color: #fff;
}

.ios-input::placeholder {
  color: rgba(0, 0, 0, 0.3);
}

.dark .ios-input::placeholder {
  color: rgba(255, 255, 255, 0.3);
}

/* Timeline line */
.timeline-line {
  background: linear-gradient(to bottom, #811cd9, #00fbfb, #ff81f5);
}
</style>