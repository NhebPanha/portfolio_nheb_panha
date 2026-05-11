<template>
    <div class="fixed bottom-6 right-6 z-[100] flex flex-col items-end pointer-events-none">
        <!-- Chat Window -->
        <Transition name="chat-window">
            <div v-if="isOpen" class="chat-container mb-4 pointer-events-auto">
                <!-- Header -->
                <div class="chat-header p-5 flex items-center justify-between shadow-lg relative overflow-hidden">
                    <!-- Solid Gradient Background for Header (Always Dark) -->
                    <div class="absolute inset-0 bg-gradient-to-br from-[#811cd9] to-[#ff81f5] z-0"></div>
                    
                    <div class="flex items-center gap-3 relative z-10">
                        <div class="w-10 h-10 rounded-xl bg-white/20 backdrop-blur-md flex items-center justify-center border border-white/30">
                            <span class="material-symbols-outlined text-white text-xl">smart_toy</span>
                        </div>
                        <div>
                            <h3 class="text-sm font-black tracking-tight text-white uppercase">Assistant Bot</h3>
                            <div class="flex items-center gap-1.5">
                                <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse shadow-[0_0_8px_rgba(52,211,153,0.8)]"></span>
                                <span class="text-[10px] font-bold text-white/90 uppercase tracking-widest">Active Now</span>
                            </div>
                        </div>
                    </div>
                    <button @click="isOpen = false" class="relative z-10 w-8 h-8 rounded-full flex items-center justify-center text-white/60 hover:text-white hover:bg-white/10 transition-all">
                        <span class="material-symbols-outlined text-xl">close</span>
                    </button>
                </div>

                <!-- Messages Area -->
                <div ref="messageContainer" class="flex-1 overflow-y-auto p-4 space-y-4 custom-scrollbar bg-messages">
                    <div v-for="(msg, index) in messages" :key="index" 
                         :class="['flex flex-col', msg.role === 'user' ? 'items-end' : 'items-start']">
                        <span class="bubble-label">
                            {{ msg.role === 'user' ? 'You' : 'Bot' }}
                        </span>
                        <div :class="[
                            'bubble shadow-sm',
                            msg.role === 'user' ? 'bubble-user' : 'bubble-bot'
                        ]">
                            {{ msg.content }}
                        </div>
                    </div>
                    <!-- Typing Indicator -->
                    <div v-if="isTyping" class="flex flex-col items-start">
                        <span class="bubble-label">Bot</span>
                        <div class="bubble bubble-bot flex gap-1.5 shadow-sm">
                            <span class="dot-bounce" style="animation-delay: 0s"></span>
                            <span class="dot-bounce" style="animation-delay: 0.18s"></span>
                            <span class="dot-bounce" style="animation-delay: 0.36s"></span>
                        </div>
                    </div>
                </div>

                <!-- Input Field -->
                <div class="chat-footer p-4 border-t border-black/5 dark:border-white/5">
                    <form @submit.prevent="handleSend" class="relative group">
                        <input v-model="input" 
                               type="text" 
                               placeholder="Ask me anything..." 
                               class="chat-input"
                               :disabled="isTyping" />
                        <button type="submit" 
                                class="send-button"
                                :disabled="!input.trim() || isTyping">
                            <span class="material-symbols-outlined text-sm">send</span>
                        </button>
                    </form>
                </div>
            </div>
        </Transition>

        <!-- Floating Action Button -->
        <button @click="isOpen = !isOpen" 
                class="pointer-events-auto group relative w-14 h-14 md:w-16 md:h-16 rounded-2xl bg-gradient-to-br from-[#811cd9] to-[#ff81f5] flex items-center justify-center shadow-2xl shadow-primary/40 hover:scale-110 active:scale-95 transition-all duration-300">
            <div class="absolute inset-0 rounded-2xl bg-[#811cd9] animate-ping opacity-20 group-hover:opacity-0 transition-opacity"></div>
            <span class="material-symbols-outlined text-white text-3xl transition-transform duration-500"
                  :class="isOpen ? 'rotate-180 scale-0 opacity-0' : 'rotate-0 scale-100 opacity-100'">
                forum
            </span>
            <span class="material-symbols-outlined text-white text-3xl absolute transition-transform duration-500"
                  :class="isOpen ? 'rotate-0 scale-100 opacity-100' : '-rotate-180 scale-0 opacity-0'">
                close
            </span>
        </button>
    </div>
</template>

<script setup>
const isOpen = ref(false)
const input = ref('')
const isTyping = ref(false)
const messageContainer = ref(null)

const messages = ref([
    { role: 'assistant', content: 'Hello! I am your AI assistant. How can I help you today?' }
])

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
        messages.value.push({ role: 'assistant', content: 'Connection lost. Please try again.' })
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
    width: 340px;
    height: 520px;
    max-height: calc(100vh - 120px);
    background-color: var(--bg); /* Reacts to theme */
    backdrop-filter: blur(20px);
    border: 1px solid var(--glass-border);
    border-radius: 28px;
    display: flex;
    flex-direction: column;
    overflow: hidden;
    box-shadow: 0 24px 64px -12px rgba(0, 0, 0, 0.15);
    color: var(--text); /* Forces correct text color */
}

.dark .chat-container {
    box-shadow: 0 30px 80px -12px rgba(0, 0, 0, 0.6);
}

.bg-messages {
    background-color: rgba(0, 0, 0, 0.02);
}
.dark .bg-messages {
    background-color: rgba(0, 0, 0, 0.3);
}

.chat-footer {
    background-color: rgba(255, 255, 255, 0.5);
    backdrop-blur: 10px;
}
.dark .chat-footer {
    background-color: rgba(0, 0, 0, 0.4);
}

.bubble {
    max-width: 85%;
    padding: 0.65rem 1rem;
    border-radius: 1.25rem;
    font-size: 0.875rem;
    line-height: 1.5;
    transition: all 0.3s ease;
}

.bubble-user {
    background-color: var(--primary);
    color: white !important; /* Always white on primary */
    border-top-right-radius: 4px;
}

.bubble-bot {
    background-color: #f0f0f0; /* Light gray in light mode (visible on white) */
    color: #111 !important; /* Dark text in light mode */
    border-top-left-radius: 4px;
    border: 1px solid rgba(0, 0, 0, 0.05);
}

.dark .bubble-bot {
    background-color: rgba(255, 255, 255, 0.08);
    color: #f5f5f5 !important;
    border-color: rgba(255, 255, 255, 0.1);
}

.bubble-label {
    font-size: 9px;
    text-transform: uppercase;
    letter-spacing: 0.1em;
    margin-bottom: 4px;
    margin-left: 8px;
    margin-right: 8px;
    opacity: 0.5;
    color: var(--text);
}

.chat-input {
    width: 100%;
    background-color: white;
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 12px;
    padding: 0.75rem 3.5rem 0.75rem 1rem;
    font-size: 0.875rem;
    color: #111;
    outline: none;
    transition: all 0.3s ease;
}

.dark .chat-input {
    background-color: rgba(255, 255, 255, 0.05);
    border-color: rgba(255, 255, 255, 0.1);
    color: white;
}

.send-button {
    position: absolute;
    right: 0.5rem;
    top: 50%;
    transform: translateY(-50%);
    width: 2rem;
    height: 2rem;
    background-color: var(--primary);
    color: white;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s ease;
}

.send-button:hover:not(:disabled) {
    transform: translateY(-50%) scale(1.1);
}

.dot-bounce {
    width: 6px;
    height: 6px;
    background: var(--primary);
    border-radius: 50%;
    animation: bounce 0.6s ease-in-out infinite alternate;
}

@keyframes bounce {
    from { transform: translateY(0); }
    to { transform: translateY(-4px); }
}

/* Transitions */
.chat-window-enter-active,
.chat-window-leave-active {
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
.chat-window-enter-from, .chat-window-leave-to {
    opacity: 0;
    transform: translateY(20px) scale(0.9);
}

.custom-scrollbar::-webkit-scrollbar { width: 4px; }
.custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(0, 0, 0, 0.1); border-radius: 10px; }
.dark .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(255, 255, 255, 0.1); }
</style>
