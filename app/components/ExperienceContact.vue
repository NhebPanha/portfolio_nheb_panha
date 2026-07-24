<template>
  <div class="bg-background text-on-background font-body min-h-screen transition-colors duration-500 relative overflow-hidden">

    <!-- ================= CONTACT SECTION ================= -->
    <section id="contact" class="pt-24 md:pt-36 pb-24 md:pb-36 max-w-7xl mx-auto px-4 md:px-8 relative z-10" ref="contactRef">

      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 md:gap-12 transition-all duration-700 ease-out"
           :class="contactVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">

        <!-- Left Info -->
        <div class="lg:col-span-5">
          <span class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 text-secondary text-[10px] font-bold tracking-[0.3em] uppercase mb-6">
            <span class="w-1.5 h-1.5 rounded-full bg-secondary animate-pulse"></span>
            Direct Inquiry
          </span>

          <h2 class="text-4xl sm:text-6xl font-black tracking-tighter leading-tight mb-8">
            Let's Build <br />
            Something <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-blue-500 to-pink-500">Extraordinary</span>
          </h2>

          <p class="text-on-surface-variant text-base leading-relaxed mb-10">
            Have a product vision, mobile application requirement, or full-stack software project? Send a direct message below. Your inquiry is recorded into Supabase and notified instantly.
          </p>

          <div class="space-y-6">
            <!-- Email Item -->
            <div class="p-5 rounded-2xl bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 backdrop-blur-md flex justify-between items-center group">
              <div>
                <span class="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant block mb-1">Direct Email</span>
                <p class="text-base sm:text-lg font-bold text-on-surface font-mono">samlot.development@gmail.com</p>
              </div>

              <button @click="copyEmail" class="p-2.5 rounded-xl bg-primary/10 hover:bg-primary text-cyan-400 hover:text-white transition-all" title="Copy Email">
                <span class="material-symbols-outlined text-lg">{{ copied ? 'check' : 'content_copy' }}</span>
              </button>
            </div>

            <!-- Location Item -->
            <div class="p-5 rounded-2xl bg-black/5 dark:bg-white/5 border border-black/5 dark:border-white/10 backdrop-blur-md flex justify-between items-center">
              <div>
                <span class="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant block mb-1">Location & Timezone</span>
                <p class="text-base sm:text-lg font-bold text-on-surface">Phnom Penh, Cambodia (UTC+7)</p>
              </div>
              <span class="material-symbols-outlined text-2xl text-emerald-400">public</span>
            </div>
          </div>
        </div>

        <!-- Right Form Panel -->
        <div class="lg:col-span-7">
          <div class="glass-panel p-8 md:p-10 relative overflow-hidden">
            <div class="absolute inset-0 bg-gradient-to-br from-primary/5 to-cyan-400/5 pointer-events-none"></div>

            <div class="relative z-10">
              <h3 class="text-2xl font-black mb-2 text-on-surface">Send Message</h3>
              <p class="text-xs text-on-surface-variant mb-6">Recorded live via Supabase DB Engine & Telegram Notification</p>

              <!-- Toast Notification Alert -->
              <div v-if="statusMessage" class="mb-6 p-4 rounded-xl text-xs font-bold border flex items-center gap-3 backdrop-blur-md"
                   :class="isSuccess ? 'bg-emerald-500/10 border-emerald-500/30 text-emerald-400' : 'bg-rose-500/10 border-rose-500/30 text-rose-400'">
                <span class="material-symbols-outlined text-lg">{{ isSuccess ? 'check_circle' : 'error' }}</span>
                <span>{{ statusMessage }}</span>
              </div>

              <form @submit.prevent="handleSubmit" class="space-y-5">

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                  <div>
                    <label class="block text-xs font-bold uppercase tracking-wider text-on-surface-variant mb-2">Your Name</label>
                    <input v-model="form.name" required placeholder="John Doe" 
                           class="w-full px-4 py-3 rounded-xl bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 text-sm text-on-surface placeholder:text-on-surface-variant/40 focus:outline-none focus:border-cyan-400 transition-all" />
                  </div>

                  <div>
                    <label class="block text-xs font-bold uppercase tracking-wider text-on-surface-variant mb-2">Email Address</label>
                    <input v-model="form.email" type="email" required placeholder="john@example.com" 
                           class="w-full px-4 py-3 rounded-xl bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 text-sm text-on-surface placeholder:text-on-surface-variant/40 focus:outline-none focus:border-cyan-400 transition-all" />
                  </div>
                </div>

                <div>
                  <label class="block text-xs font-bold uppercase tracking-wider text-on-surface-variant mb-2">Inquiry Type</label>
                  <select v-model="form.type" 
                          class="w-full px-4 py-3 rounded-xl bg-black/5 dark:bg-slate-900 border border-black/10 dark:border-white/10 text-sm text-on-surface focus:outline-none focus:border-cyan-400 transition-all">
                    <option value="Mobile App Development">Mobile App Development (Flutter)</option>
                    <option value="Full-Stack Web Development">Full-Stack Web Development (Nuxt 3)</option>
                    <option value="Supabase / Cloud Integration">Supabase / Cloud Database Integration</option>
                    <option value="General Inquiry">General Collaboration / Hire</option>
                  </select>
                </div>

                <div>
                  <label class="block text-xs font-bold uppercase tracking-wider text-on-surface-variant mb-2">Message</label>
                  <textarea v-model="form.message" required rows="4" placeholder="Describe your project, timeline, or inquiry..."
                            class="w-full px-4 py-3 rounded-xl bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 text-sm text-on-surface placeholder:text-on-surface-variant/40 focus:outline-none focus:border-cyan-400 transition-all resize-none"></textarea>
                </div>

                <button type="submit" :disabled="isSubmitting" 
                        class="w-full py-4 rounded-xl bg-gradient-to-r from-primary via-purple-600 to-pink-500 text-white font-bold text-xs uppercase tracking-widest shadow-lg hover:shadow-[0_0_25px_rgba(129,28,217,0.5)] hover:scale-[1.01] active:scale-[0.99] transition-all disabled:opacity-50 flex items-center justify-center gap-2">
                  <span v-if="isSubmitting" class="w-4 h-4 rounded-full border-2 border-white border-t-transparent animate-spin"></span>
                  <span>{{ isSubmitting ? 'Transmitting to Supabase...' : 'Submit Inquiry' }}</span>
                  <span v-if="!isSubmitting" class="material-symbols-outlined text-sm">send</span>
                </button>

              </form>
            </div>
          </div>
        </div>

      </div>

    </section>

  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import { useScrollAnimate } from '~/composables/useScrollAnimate'

const { sectionRef: contactRef, isVisible: contactVisible } = useScrollAnimate(0.1)

const scrollTo = (href, e) => {
  e.preventDefault()
  const target = document.querySelector(href)
  if (target) {
    const yOffset = -90
    const y = target.getBoundingClientRect().top + window.pageYOffset + yOffset
    window.scrollTo({ top: y, behavior: 'smooth' })
  }
}

const form = reactive({
  name: "",
  email: "",
  type: "Mobile App Development",
  message: ""
})

const isSubmitting = ref(false)
const statusMessage = ref("")
const isSuccess = ref(true)

const copied = ref(false)
const copyEmail = () => {
  navigator.clipboard.writeText('samlot.development@gmail.com')
  copied.value = true
  setTimeout(() => { copied.value = false }, 2500)
}

const handleSubmit = async () => {
  if (isSubmitting.value) return
  isSubmitting.value = true
  statusMessage.value = ""

  try {
    const res = await $fetch('/api/contact', {
      method: 'POST',
      body: form
    })
    
    isSuccess.value = true
    statusMessage.value = res.supabaseSaved 
      ? 'Inquiry successfully saved to Supabase DB & notified!' 
      : 'Inquiry transmitted successfully!'
    
    form.name = ''
    form.email = ''
    form.message = ''
  } catch (error) {
    isSuccess.value = false
    statusMessage.value = 'Failed to process inquiry. Please try again.'
  } finally {
    isSubmitting.value = false
  }
}
</script>