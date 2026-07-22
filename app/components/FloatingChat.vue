<template>
  <div class="fixed bottom-6 right-6 z-[100] flex flex-col items-end pointer-events-none font-body">
    <!-- Chat Window -->
    <Transition name="chat-window">
      <div v-if="isOpen" class="chat-container mb-4 pointer-events-auto shadow-2xl">
        
        <!-- Header -->
        <div class="chat-header p-4 flex items-center justify-between relative overflow-hidden">
          <div class="absolute inset-0 bg-gradient-to-r from-primary via-purple-600 to-pink-500 z-0"></div>
          
          <div class="flex items-center gap-3 relative z-10">
            <div class="w-9 h-9 rounded-xl bg-white/20 backdrop-blur-md flex items-center justify-center border border-white/30 shadow-md">
              <span class="material-symbols-outlined text-white text-lg">smart_toy</span>
            </div>
            <div>
              <h3 class="text-xs font-black tracking-wider text-white uppercase">Panha AI Assistant</h3>
              <div class="flex items-center gap-1.5">
                <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse shadow-[0_0_8px_rgba(52,211,153,0.8)]"></span>
                <span class="text-[9px] font-bold text-white/90 uppercase tracking-widest">Supabase Active</span>
              </div>
            </div>
          </div>

          <button @click="isOpen = false" class="relative z-10 w-7 h-7 rounded-full flex items-center justify-center text-white/80 hover:text-white hover:bg-white/20 transition-all">
            <span class="material-symbols-outlined text-lg">close</span>
          </button>
        </div>

        <!-- Quick Suggestions Bar -->
        <div class="px-3 py-2 bg-black/5 dark:bg-white/5 border-b border-black/5 dark:border-white/5 flex gap-1.5 overflow-x-auto custom-scrollbar">
          <button v-for="chip in quickChips" :key="chip" @click="sendQuick(chip)"
                  class="px-2.5 py-1 rounded-lg bg-white/60 dark:bg-white/10 text-[10px] font-bold uppercase tracking-wider text-on-surface hover:text-primary whitespace-nowrap border border-black/5 dark:border-white/5">
            {{ chip }}
          </button>
        </div>

        <!-- Messages Area -->
        <div ref="messageContainer" class="flex-1 overflow-y-auto p-4 space-y-3.5 custom-scrollbar bg-messages">
          <div v-for="(msg, index) in messages" :key="index" 
               :class="['flex flex-col', msg.role === 'user' ? 'items-end' : 'items-start']">
            <span class="bubble-label">
              {{ msg.role === 'user' ? 'You' : 'Panha Bot' }}
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
            <span class="bubble-label">Panha Bot</span>
            <div class="bubble bubble-bot flex gap-1.5 shadow-sm">
              <span class="dot-bounce" style="animation-delay: 0s"></span>
              <span class="dot-bounce" style="animation-delay: 0.18s"></span>
              <span class="dot-bounce" style="animation-delay: 0.36s"></span>
            </div>
          </div>
        </div>

        <!-- Input Field -->
        <div class="chat-footer p-3 border-t border-black/5 dark:border-white/5">
          <form @submit.prevent="handleSend" class="relative group">
            <input v-model="input" 
                   type="text" 
                   placeholder="Ask about skills, projects, or Supabase..." 
                   class="chat-input"
                   :disabled="isTyping" />
            <button type="submit" 
                    class="send-button"
                    :disabled="!input.trim() || isTyping">
              <span class="material-symbols-outlined text-xs">send</span>
            </button>
          </form>
        </div>
      </div>
    </Transition>

    <!-- Floating Trigger FAB -->
    <button @click="isOpen = !isOpen" 
            class="pointer-events-auto group relative w-14 h-14 rounded-2xl bg-gradient-to-br from-primary via-purple-600 to-pink-500 flex items-center justify-center shadow-2xl hover:scale-110 active:scale-95 transition-all duration-300">
      <div class="absolute inset-0 rounded-2xl bg-primary animate-ping opacity-25 group-hover:opacity-0 transition-opacity"></div>
      <span class="material-symbols-outlined text-white text-2xl transition-transform duration-500"
            :class="isOpen ? 'rotate-180 scale-0 opacity-0' : 'rotate-0 scale-100 opacity-100'">
        forum
      </span>
      <span class="material-symbols-outlined text-white text-2xl absolute transition-transform duration-500"
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

const quickChips = ['Skills', 'Projects', 'Supabase', 'Hire']

const messages = ref([
  { role: 'assistant', content: 'Hello! I am Panha’s AI assistant. Ask me about Flutter, Supabase, Nuxt, or projects!' }
])

const sendQuick = (chip) => {
  input.value = `Tell me about your ${chip}`
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
  width: 330px;
  height: 480px;
  max-height: calc(100vh - 120px);
  background-color: var(--bg);
  backdrop-filter: blur(24px);
  border: 1px solid var(--glass-border);
  border-radius: 24px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  color: var(--text);
}

.bg-messages {
  background-color: rgba(0, 0, 0, 0.02);
}
.dark .bg-messages {
  background-color: rgba(0, 0, 0, 0.2);
}

.bubble {
  max-width: 85%;
  padding: 0.65rem 0.9rem;
  border-radius: 1.15rem;
}

.bubble-user {
  background: linear-gradient(135deg, #811cd9, #6d16b8);
  color: white !important;
  border-top-right-radius: 4px;
}

.bubble-bot {
  background-color: rgba(0, 0, 0, 0.05);
  color: var(--text) !important;
  border-top-left-radius: 4px;
  border: 1px solid var(--glass-border);
}

.dark .bubble-bot {
  background-color: rgba(255, 255, 255, 0.08);
}

.bubble-label {
  font-size: 9px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  margin-bottom: 3px;
  margin-left: 8px;
  margin-right: 8px;
  opacity: 0.5;
  color: var(--text);
}

.chat-input {
  width: 100%;
  background-color: rgba(0, 0, 0, 0.05);
  border: 1px solid var(--glass-border);
  border-radius: 12px;
  padding: 0.65rem 3rem 0.65rem 0.85rem;
  font-size: 0.8rem;
  color: var(--text);
  outline: none;
}

.dark .chat-input {
  background-color: rgba(255, 255, 255, 0.05);
}

.send-button {
  position: absolute;
  right: 0.4rem;
  top: 50%;
  transform: translateY(-50%);
  width: 1.85rem;
  height: 1.85rem;
  background-color: var(--primary);
  color: white;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.dot-bounce {
  width: 5px;
  height: 5px;
  background: #00fbfb;
  border-radius: 50%;
  animation: bounce 0.6s ease-in-out infinite alternate;
}

@keyframes bounce {
  from { transform: translateY(0); }
  to { transform: translateY(-4px); }
}

.chat-window-enter-active,
.chat-window-leave-active {
  transition: all 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
.chat-window-enter-from, .chat-window-leave-to {
  opacity: 0;
  transform: translateY(20px) scale(0.9);
}

.custom-scrollbar::-webkit-scrollbar { height: 3px; width: 3px; }
.custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(129, 28, 217, 0.4); border-radius: 10px; }
</style>
