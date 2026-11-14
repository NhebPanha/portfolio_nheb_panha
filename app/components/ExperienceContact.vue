<template>
  <section id="contact" class="section">
    <div ref="contactRef" class="container-page grid gap-12 lg:grid-cols-12">
      <!-- Info -->
      <div class="reveal lg:col-span-5" :class="{ 'reveal-hidden': !contactVisible }">
        <SectionHeading
          eyebrow="Contact"
          title="Let's work together"
          lead="Have a mobile app, web platform or backend project in mind? Send me a message and I'll get back to you within one or two working days."
        />

        <ul class="mt-10 space-y-3">
          <li class="card flex items-center justify-between gap-4 p-4">
            <div class="flex min-w-0 items-center gap-3">
              <span class="material-symbols-outlined text-[20px] text-on-surface-variant">mail</span>
              <a :href="`mailto:${email}`" class="truncate text-sm font-medium text-on-surface hover:text-primary">{{ email }}</a>
            </div>
            <button class="btn-secondary !px-3 !py-1.5 text-xs" :aria-label="copied ? 'Email copied' : 'Copy email address'" @click="copyEmail">
              <span class="material-symbols-outlined text-[16px]">{{ copied ? 'check' : 'content_copy' }}</span>
              {{ copied ? 'Copied' : 'Copy' }}
            </button>
          </li>
          <li class="card flex items-center gap-3 p-4">
            <span class="material-symbols-outlined text-[20px] text-on-surface-variant">send</span>
            <a href="https://t.me/nhebpanha" target="_blank" rel="noopener noreferrer" class="text-sm font-medium text-on-surface hover:text-primary">
              Telegram: @nhebpanha
            </a>
          </li>
          <li class="card flex items-center gap-3 p-4">
            <span class="material-symbols-outlined text-[20px] text-on-surface-variant">location_on</span>
            <span class="text-sm font-medium text-on-surface">Phnom Penh, Cambodia <span class="font-normal text-on-surface-variant">(UTC+7)</span></span>
          </li>
        </ul>
      </div>

      <!-- Form -->
      <div class="reveal lg:col-span-7" :class="{ 'reveal-hidden': !contactVisible }" style="transition-delay: 120ms">
        <form class="card space-y-5 p-6 sm:p-8" novalidate @submit.prevent="handleSubmit">
          <div class="grid gap-5 sm:grid-cols-2">
            <div>
              <label for="c-name" class="label">Name</label>
              <input id="c-name" v-model="form.name" required autocomplete="name" maxlength="120" class="input" />
            </div>
            <div>
              <label for="c-email" class="label">Email</label>
              <input id="c-email" v-model="form.email" type="email" required autocomplete="email" maxlength="200" class="input" />
            </div>
          </div>

          <div>
            <label for="c-type" class="label">What can I help with?</label>
            <select id="c-type" v-model="form.type" class="input">
              <option value="Mobile App Development">Mobile app (Flutter)</option>
              <option value="Full-Stack Web Development">Web application (Nuxt / Vue)</option>
              <option value="Backend / API">Backend or API</option>
              <option value="Full-time Role">Full-time role</option>
              <option value="General Inquiry">Something else</option>
            </select>
          </div>

          <div>
            <label for="c-message" class="label">Message</label>
            <textarea id="c-message" v-model="form.message" required rows="5" maxlength="5000"
                      placeholder="A few lines about the project, timeline and budget."
                      class="input resize-y"></textarea>
          </div>

          <p v-if="statusMessage" role="status"
             class="flex items-start gap-2 rounded-lg border px-4 py-3 text-sm"
             :class="isSuccess
               ? 'border-emerald-500/30 bg-emerald-500/10 text-emerald-700 dark:text-emerald-300'
               : 'border-rose-500/30 bg-rose-500/10 text-rose-700 dark:text-rose-300'">
            <span class="material-symbols-outlined text-[18px]">{{ isSuccess ? 'check_circle' : 'error' }}</span>
            {{ statusMessage }}
          </p>

          <button type="submit" :disabled="isSubmitting" class="btn-primary w-full sm:w-auto">
            <span v-if="isSubmitting" class="h-4 w-4 animate-spin rounded-full border-2 border-current border-t-transparent"></span>
            {{ isSubmitting ? 'Sending…' : 'Send message' }}
          </button>
        </form>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useScrollAnimate } from '~/composables/useScrollAnimate'

const { sectionRef: contactRef, isVisible: contactVisible } = useScrollAnimate(0.1)

const email = 'nhebpanha78@gmail.com'

const form = reactive({
  name: '',
  email: '',
  type: 'Mobile App Development',
  message: ''
})

const isSubmitting = ref(false)
const statusMessage = ref('')
const isSuccess = ref(true)
const copied = ref(false)

const copyEmail = async () => {
  try {
    await navigator.clipboard.writeText(email)
    copied.value = true
    setTimeout(() => { copied.value = false }, 2000)
  } catch {
    window.location.href = `mailto:${email}`
  }
}

const handleSubmit = async () => {
  if (isSubmitting.value) return
  if (!form.name.trim() || !form.email.trim() || !form.message.trim()) {
    isSuccess.value = false
    statusMessage.value = 'Please fill in your name, email and message.'
    return
  }

  isSubmitting.value = true
  statusMessage.value = ''
  try {
    await $fetch('/api/contact', { method: 'POST', body: form })
    isSuccess.value = true
    statusMessage.value = "Thanks! Your message has been sent. I'll reply soon."
    form.name = ''
    form.email = ''
    form.message = ''
  } catch (error: any) {
    isSuccess.value = false
    statusMessage.value = error?.data?.statusMessage || error?.statusMessage
      || `Something went wrong. Please email me at ${email}.`
  } finally {
    isSubmitting.value = false
  }
}
</script>
