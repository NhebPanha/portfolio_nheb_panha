<template>
  <div class="bg-background text-on-background font-body min-h-screen transition-colors duration-500">

    <!-- ================= EXPERIENCE ================= -->
    <section id="experience" class="pt-24 md:pt-32 pb-16 md:pb-24 max-w-7xl mx-auto px-4 md:px-8">

      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 md:gap-12">

        <!-- Left Panel -->
        <div class="lg:col-span-4 sticky top-32 h-fit">

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
        <div class="lg:col-span-8 relative pl-12 md:pl-24">

          <!-- Vertical Line -->
          <div class="absolute left-4 md:left-12 top-0 bottom-0 w-px timeline-line opacity-30"></div>

          <!-- Items -->
          <div v-for="(item, index) in experiences" :key="index" class="relative mb-24 group animate-fadeIn"
            :style="{ animationDelay: `${index * 0.2}s` }">

            <!-- Dot -->
            <div class="absolute -left-10 md:-left-[52px] top-2 w-4 h-4 rounded-full border-4 border-background z-10"
              :class="item.dotColor"></div>

            <!-- Card -->
            <div class="glass-panel p-8 hover:translate-x-2 transition-transform duration-300 cursor-pointer"
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
                  class="bg-surface-container px-3 py-1 text-[10px] uppercase">
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
    <section id="contact" class="pb-16 md:pb-24 max-w-7xl mx-auto px-4 md:px-8">

      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 md:gap-12">

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
          <div class="glass-panel p-10 md:p-16">

            <form @submit.prevent="handleSubmit" class="space-y-10">

              <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
                <input v-model="form.name" placeholder="Your Name" class="input-style" />
                <input v-model="form.email" type="email" placeholder="Email Address" class="input-style" />
              </div>

              <select v-model="form.type" class="input-style">
                <option>Project Inquiry</option>
                <option>Collaboration</option>
                <option>Freelance Work</option>
                <option>General</option>
              </select>

              <textarea v-model="form.message" rows="5" placeholder="Your message..."
                class="input-style resize-none"></textarea>

              <button type="submit" :disabled="isSubmitting" class="bg-black text-white px-8 md:px-12 py-4 uppercase text-xs tracking-widest w-full md:w-auto
                       hover:shadow-lg transition duration-300 disabled:opacity-50 disabled:cursor-not-allowed
                       dark:bg-black dark:text-white dark:border dark:border-gray-800">
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


/* ================= EXPERIENCE ================= */
const experiences = [
  {
    year: "2025 — Present",
    role: "Flutter Developer",
    company: "Mobile App Development",
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
  type: "Project Inquiry",
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
/* Animation */
@keyframes fadeIn {
  0% {
    opacity: 0;
    transform: translateY(20px);
  }

  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fadeIn {
  animation: fadeIn 0.6s forwards;
}

/* Glass */
.glass-panel {
  background: rgba(255, 255, 255, 0.4);
  backdrop-filter: blur(12px);
  border-radius: 12px;
  transition: transform 0.3s;
}

.dark .glass-panel {
  background: rgba(131, 130, 130, 0.144);
}

/* Input */
.input-style {
  width: 100%;
  border-bottom: 2px solid #ccc;
  padding: 10px 0;
  background: transparent;
  outline: none;
  transition: border-color 0.3s;
}

.dark .input-style {
  border-color: #555;
  color: #f5f5f5;
}

.input-style:focus {
  border-color: #811cd9;
}

/* Timeline line */
.timeline-line {
  background: linear-gradient(to bottom, #811cd9, #00fbfb, #ff81f5);
}
</style>