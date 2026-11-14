<template>
  <div class="fixed bottom-6 right-6 z-[100] flex flex-col items-end pointer-events-none font-body">
    <!-- Chat Window -->
    <Transition name="chat-window">
      <div v-if="isOpen" class="chat-container mb-4 pointer-events-auto shadow-2xl">
        
        <!-- Header -->
        <div class="chat-header flex items-center justify-between border-b border-line px-4 py-3">
          
          
          <div class="flex items-center gap-3">
            <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-primary/10">
              <span class="material-symbols-outlined text-[20px] text-primary">smart_toy</span>
            </div>
            <div>
              <h3 class="text-sm font-semibold text-on-surface">Ask about Panha</h3>
              <div class="flex items-center gap-1.5">
                <span class="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>
                <span class="text-xs text-on-surface-variant">AI assistant · usually instant</span>
              </div>
            </div>
          </div>

          <button @click="isOpen = false" class="flex h-8 w-8 items-center justify-center rounded-lg text-on-surface-variant transition-colors hover:bg-surface hover:text-on-surface" aria-label="Close chat">
            <span class="material-symbols-outlined text-lg">close</span>
          </button>
        </div>

        <!-- Quick Suggestions Bar -->
        <div class="flex gap-1.5 overflow-x-auto border-b border-line px-3 py-2 custom-scrollbar">
          <button v-for="chip in quickChips" :key="chip" @click="sendQuick(chip)"
                  class="whitespace-nowrap rounded-full border border-line px-3 py-1 text-xs font-medium text-on-surface-variant transition-colors hover:border-primary/40 hover:text-on-surface">
            {{ chip }}
          </button>
        </div>

        <!-- Messages Area -->
        <div ref="messageContainer" class="flex-1 overflow-y-auto p-4 space-y-3.5 custom-scrollbar bg-messages">
          <div v-for="(msg, index) in messages" :key="index" 
               :class="['flex flex-col', msg.role === 'user' ? 'items-end' : 'items-start']">
            <span class="bubble-label">
              {{ msg.role === 'user' ? 'You' : 'Assistant' }}
            </span>
            <div :class="[
              'bubble text-xs leading-relaxed shadow-sm',
              msg.role === 'user' ? 'bubble-user' : 'bubble-bot'
            ]">
              {{ msg.content }}
            </div>
          </div>

          <!-- Typing Indicator -->
          <div v-if="isTyping" class="flex flex-col items-start">
            <span class="bubble-label">Assistant</span>
            <div class="bubble bubble-bot flex gap-1.5 shadow-sm">
              <span class="dot-bounce" style="animation-delay: 0s"></span>
              <span class="dot-bounce" style="animation-delay: 0.18s"></span>
              <span class="dot-bounce" style="animation-delay: 0.36s"></span>
            </div>
          </div>
        </div>

        <!-- Input Field -->
        <div class="chat-footer border-t border-line p-3">
          <form @submit.prevent="handleSend" class="relative group">
            <input v-model="input" 
                   type="text" 
                   placeholder="Ask about skills, projects or availability" aria-label="Message" 
                   class="chat-input"
                   :disabled="isTyping" />
            <button type="submit" 
                    class="send-button" aria-label="Send message"
                    :disabled="!input.trim() || isTyping">
              <span class="material-symbols-outlined text-xs">send</span>
            </button>
          </form>
        </div>
      </div>
    </Transition>

    <!-- Floating Trigger FAB -->
    <button @click="isOpen = !isOpen" 
            class="pointer-events-auto relative flex h-14 w-14 items-center justify-center rounded-full bg-primary text-white shadow-lg shadow-black/20 transition-transform hover:scale-105 active:scale-95 dark:text-zinc-950" :aria-label="isOpen ? 'Close chat' : 'Open chat assistant'" :aria-expanded="isOpen">
      
      <span class="material-symbols-outlined text-2xl transition-transform duration-500"
            :class="isOpen ? 'rotate-180 scale-0 opacity-0' : 'rotate-0 scale-100 opacity-100'">
        forum
      </span>
      <span class="material-symbols-outlined text-2xl absolute transition-transform duration-500"
            :class="isOpen ? 'rotate-0 scale-100 opacity-100' : '-rotate-180 scale-0 opacity-0'">
        close
      </span>
    </button>
  </div>
</template>

<script setup>
import { ref, watch, nextTick } from 'vue'

const isOpen = ref(false)
const input = ref('')
const isTyping = ref(false)
const messageContainer = ref(null)

const quickChips = ['Skills', 'Projects', 'Experience', 'Availability']

const messages = ref([
  { role: 'assistant', content: 'Hi! I can answer questions about Panha’s experience, projects and skills.' }
])

const sendQuick = (chip) => {
  const questions = { Skills: 'What are Panha’s main skills?', Projects: 'What projects has Panha built?', Experience: 'What is Panha’s work experience?', Availability: 'Is Panha available for new work?' }
  input.value = questions[chip] || chip
  handleSend()
}

const handleSend = async () => {
  const prompt = input.value.trim()
  if (!prompt) return

  messages.value.push({ role: 'user', content: prompt })
  input.value = ''
  isTyping.value = true
  scrollToBottom()

  try {
    const history = messages.value.slice(0, -1).map(m => ({
      role: m.role === 'user' ? 'user' : 'model',
      parts: [{ text: m.content }]
    }))

    const data = await $fetch('/api/chat', {
      method: 'POST',
      body: { prompt, history }
    })

    messages.value.push({ role: 'assistant', content: data.responseText })
  } catch {
    messages.value.push({ role: 'assistant', content: 'Ready to assist! Ask me anything about Panha’s portfolio.' })
  } finally {
    isTyping.value = false
    scrollToBottom()
  }
}

const scrollToBottom = async () => {
  await nextTick()
  if (messageContainer.value) {
    messageContainer.value.scrollTop = messageContainer.value.scrollHeight
  }
}

watch(isOpen, (newVal) => {
  if (newVal) scrollToBottom()
})
</script>

<style scoped>
.chat-container {
  width: min(360px, calc(100vw - 2rem));
  height: 500px;
  max-height: calc(100vh - 120px);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  border: 1px solid rgb(var(--border-rgb));
  border-radius: 16px;
  background-color: rgb(var(--bg-rgb));
  color: rgb(var(--text-rgb));
}

.bg-messages {
  background-color: rgb(var(--surface-rgb));
}

.bubble {
  max-width: 85%;
  padding: 0.6rem 0.85rem;
  border-radius: 14px;
  font-size: 0.85rem;
  line-height: 1.5;
}

.bubble-user {
  background: rgb(var(--accent-rgb));
  color: #fff;
  border-top-right-radius: 4px;
}
.dark .bubble-user {
  color: #09090b;
}

.bubble-bot {
  background-color: rgb(var(--bg-rgb));
  color: rgb(var(--text-rgb));
  border: 1px solid rgb(var(--border-rgb));
  border-top-left-radius: 4px;
}

.bubble-label {
  margin: 0 6px 3px;
  font-size: 11px;
  font-weight: 500;
  color: rgb(var(--muted-rgb));
}

.chat-input {
  width: 100%;
  padding: 0.65rem 3rem 0.65rem 0.85rem;
  border: 1px solid rgb(var(--border-rgb));
  border-radius: 10px;
  background-color: rgb(var(--bg-rgb));
  color: rgb(var(--text-rgb));
  font-size: 0.875rem;
  outline: none;
}
.chat-input:focus {
  border-color: rgb(var(--accent-rgb));
  box-shadow: 0 0 0 3px rgb(var(--accent-rgb) / 0.2);
}

.send-button {
  position: absolute;
  right: 0.4rem;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  align-items: center;
  justify-content: center;
  width: 2rem;
  height: 2rem;
  border-radius: 8px;
  background-color: rgb(var(--accent-rgb));
  color: #fff;
}
.dark .send-button { color: #09090b; }
.send-button:disabled { opacity: 0.4; cursor: not-allowed; }

.dot-bounce {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: rgb(var(--muted-rgb));
  animation: bounce 0.6s ease-in-out infinite alternate;
}

@keyframes bounce {
  from { transform: translateY(0); }
  to { transform: translateY(-4px); }
}

.chat-window-enter-active,
.chat-window-leave-active {
  transition: opacity 0.2s ease, transform 0.2s ease;
}
.chat-window-enter-from,
.chat-window-leave-to {
  opacity: 0;
  transform: translateY(12px);
}

.custom-scrollbar::-webkit-scrollbar { height: 3px; width: 3px; }
.custom-scrollbar::-webkit-scrollbar-thumb { background: rgb(var(--muted-rgb) / 0.4); border-radius: 10px; }
</style>
