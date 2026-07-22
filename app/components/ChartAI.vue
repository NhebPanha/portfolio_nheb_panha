<template>
  <section id="chart-ai" class="py-24 md:py-36 bg-background text-on-background relative overflow-hidden" ref="sectionRef">
    <!-- Ambient Glow Background -->
    <div class="absolute top-0 left-0 w-full h-full pointer-events-none transition-opacity duration-1000"
      :class="isVisible ? 'opacity-100' : 'opacity-0'">
      <div class="absolute top-[-15%] left-[-10%] w-[45%] h-[45%] bg-primary/10 rounded-full blur-[140px]"></div>
      <div class="absolute bottom-[-15%] right-[-10%] w-[45%] h-[45%] bg-secondary/10 rounded-full blur-[140px]"></div>
      <div class="absolute top-[40%] left-[30%] w-[30%] h-[30%] bg-cyan-400/5 rounded-full blur-[100px]"></div>
    </div>

    <div class="max-w-7xl mx-auto px-4 md:px-8 relative z-10">
      <!-- Header -->
      <div class="text-center mb-12 transition-all duration-700 ease-out"
        :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 -translate-y-8'">
        <span class="text-xs tracking-[0.3em] text-primary uppercase mb-3 block font-bold">Interactive Analytics</span>
        <h2 class="text-4xl sm:text-5xl font-black tracking-tighter leading-none mb-4">
          Neural <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 to-pink-500">AI Assistant</span>
        </h2>
        <p class="text-on-surface-variant font-light max-w-2xl mx-auto text-sm md:text-base">
          Query my technical journey in real time. Ask about my <button @click="sendPrompt('Tell me about your skills')" class="text-primary font-semibold underline underline-offset-2 hover:text-cyan-400">skills</button>, <button @click="sendPrompt('Show project statistics')" class="text-secondary font-semibold underline underline-offset-2 hover:text-pink-400">projects</button>, or <button @click="sendPrompt('Tell me about your Supabase experience')" class="text-emerald-400 font-semibold underline underline-offset-2 hover:text-emerald-300">Supabase</button> integration.
        </p>
      </div>

      <!-- Quick Prompt Chips -->
      <div class="flex flex-wrap justify-center gap-2 mb-8">
        <button v-for="chip in promptChips" :key="chip" @click="sendPrompt(chip)"
                class="px-3.5 py-1.5 rounded-full bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10 hover:border-primary/50 text-xs font-semibold text-on-surface-variant hover:text-cyan-400 transition-all active:scale-95">
          ✨ {{ chip }}
        </button>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">

        <!-- Chat Panel -->
        <div class="lg:col-span-5 chat-panel flex flex-col h-[600px] transition-all duration-700 ease-out delay-100"
          :class="isVisible ? 'opacity-100 translate-x-0' : 'opacity-0 -translate-x-12'">

          <!-- Bot Header -->
          <div class="flex items-center justify-between mb-5 pb-4 border-b border-black/10 dark:border-white/10">
            <div class="flex items-center gap-3">
              <div class="bot-avatar">
                <span class="material-symbols-outlined text-white text-xl">smart_toy</span>
              </div>
              <div>
                <h3 class="font-black text-xs tracking-wider uppercase text-on-background">Panha AI Intelligence</h3>
                <span class="text-[10px] text-emerald-600 dark:text-emerald-400 flex items-center gap-1.5 font-bold">
                  <span class="status-dot"></span>
                  Gemini + Supabase Sync
                </span>
              </div>
            </div>
            
            <button @click="clearChat" class="text-xs text-on-surface-variant/60 hover:text-on-surface p-1">
              <span class="material-symbols-outlined text-sm">delete_sweep</span>
            </button>
          </div>

          <!-- Messages Area -->
          <div ref="chatContainer" class="flex-1 overflow-y-auto mb-4 space-y-4 pr-1 custom-scrollbar">
            <div v-for="(msg, index) in messages" :key="index"
              :class="['flex flex-col', msg.role === 'user' ? 'items-end' : 'items-start']">
              <span class="text-[9px] uppercase tracking-widest opacity-40 mb-1 mx-1 text-on-background font-bold">
                {{ msg.role === 'user' ? 'You' : 'Panha Bot' }}
              </span>
              <div :class="[
                'max-w-[88%] px-4 py-3 rounded-2xl text-xs sm:text-sm leading-relaxed shadow-sm transition-all',
                msg.role === 'user'
                  ? 'user-bubble'
                  : 'bot-bubble'
              ]">
                {{ msg.content }}
              </div>
            </div>

            <!-- Typing indicator -->
            <div v-if="isTyping" class="flex flex-col items-start">
              <span class="text-[9px] uppercase tracking-widest opacity-40 mb-1 mx-1 text-on-background font-bold">Panha Bot</span>
              <div class="bot-bubble px-4 py-3 rounded-2xl flex gap-1.5">
                <span class="dot-bounce" style="animation-delay: 0s"></span>
                <span class="dot-bounce" style="animation-delay: 0.18s"></span>
                <span class="dot-bounce" style="animation-delay: 0.36s"></span>
              </div>
            </div>
          </div>

          <!-- Input Form -->
          <form @submit.prevent="handleSendMessage" class="relative input-wrap">
            <input v-model="userInput" type="text" placeholder="Ask about skills, projects, or Supabase..." class="chat-input"
              :disabled="isTyping" />
            <button type="submit" class="send-btn" :disabled="!userInput.trim() || isTyping">
              <span class="material-symbols-outlined text-sm">send</span>
            </button>
          </form>
        </div>

        <!-- Chart Visualization -->
        <div class="lg:col-span-7 chart-panel min-h-[600px] flex flex-col items-center justify-center relative overflow-hidden transition-all duration-700 ease-out delay-300"
          :class="isVisible ? 'opacity-100 translate-x-0' : 'opacity-0 translate-x-12'">
          
          <div class="chart-grid-bg"></div>

          <!-- Empty State -->
          <div v-if="!currentChart" class="text-center relative z-10 p-6">
            <div class="icon-ring">
              <div class="icon-glow"></div>
              <span class="material-symbols-outlined text-5xl text-cyan-400 animate-float">query_stats</span>
            </div>
            <h4 class="text-2xl font-black tracking-tight mt-6 mb-2">Neural Data Engine</h4>
            <p class="text-on-surface-variant text-xs sm:text-sm font-light max-w-xs mx-auto mb-6">
              Select a prompt chip or ask about <span class="text-primary font-bold">skills</span>, <span class="text-pink-400 font-bold">projects</span>, or <span class="text-emerald-400 font-bold">productivity</span> to generate chart visualizations.
            </p>
            
            <div class="flex flex-wrap justify-center gap-2">
              <button @click="renderChart('skills')" class="px-3.5 py-1.5 rounded-xl bg-primary/20 border border-primary/40 text-xs font-bold text-cyan-400 hover:bg-primary/30 transition-colors">
                Render Skills Radar
              </button>
              <button @click="renderChart('projects')" class="px-3.5 py-1.5 rounded-xl bg-pink-500/20 border border-pink-500/40 text-xs font-bold text-pink-400 hover:bg-pink-500/30 transition-colors">
                Render Projects Bar
              </button>
            </div>
          </div>

          <!-- Active Chart View -->
          <div v-show="currentChart" class="w-full h-full flex flex-col relative z-10 chart-reveal">
            <div class="mb-4 flex justify-between items-end px-2">
              <div>
                <span class="text-[10px] uppercase tracking-[0.3em] text-primary mb-1 block font-bold">Visual Telemetry</span>
                <h3 class="text-2xl font-black tracking-tight text-on-background">{{ currentChartTitle }}</h3>
              </div>
              <button @click="resetChart" class="clear-btn">
                <span class="material-symbols-outlined text-sm">close</span>
                Clear
              </button>
            </div>
            <div class="relative flex-1 min-h-[420px] chart-canvas-wrap">
              <canvas ref="chartCanvas"></canvas>
            </div>
          </div>

        </div>

      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, nextTick } from 'vue'
import { Chart, registerables } from 'chart.js'
import { useScrollAnimate } from '~/composables/useScrollAnimate'

Chart.register(...registerables)

const { sectionRef, isVisible } = useScrollAnimate(0.1)

const chatContainer = ref<HTMLElement | null>(null)
const chartCanvas = ref<HTMLCanvasElement | null>(null)
let chartInstance: Chart | null = null

const userInput = ref('')
const isTyping = ref(false)
const currentChart = ref<string | null>(null)
const currentChartTitle = ref('')

const promptChips = [
  'What are your core skills?',
  'Show project statistics',
  'Tell me about your Supabase experience',
  'What is your productivity workflow?'
]

const messages = ref([
  { role: 'assistant', content: 'Hello! I am Panha’s AI assistant connected to Supabase. Ask me anything about skills, projects, or architecture!' }
])

const chartDataModels = {
  skills: {
    title: 'Technical Proficiency Radar',
    type: 'radar',
    labels: ['Flutter & Dart', 'Supabase DB', 'Nuxt & Vue 3', 'Laravel API', 'UI/UX Design', 'DevOps & Git'],
    data: [95, 90, 92, 88, 90, 86],
    label: 'Proficiency %',
    colors: { bg: 'rgba(0, 251, 251, 0.2)', border: '#00fbfb' }
  },
  projects: {
    title: 'Project Ecosystem Breakdown',
    type: 'bar',
    labels: ['FinTech Wallet', 'Logistics App', 'E-Commerce', 'Accounting Suite', 'HR & Payroll', 'AgriTech IoT'],
    data: [98, 95, 90, 85, 88, 82],
    label: 'Completion SLA %',
    colors: { bg: 'rgba(255, 129, 245, 0.4)', border: '#ff81f5' }
  },
  productivity: {
    title: 'Weekly Engineering Activity',
    type: 'line',
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    data: [8, 10, 9, 11, 10, 5, 4],
    label: 'Deep Work Hours',
    colors: { bg: 'rgba(0, 251, 251, 0.15)', border: '#00fbfb' }
  }
}

const scrollToBottom = async () => {
  await nextTick()
  if (chatContainer.value) {
    chatContainer.value.scrollTo({ top: chatContainer.value.scrollHeight, behavior: 'smooth' })
  }
}

const sendPrompt = (text: string) => {
  userInput.value = text
  handleSendMessage()
}

const handleSendMessage = async () => {
  const prompt = userInput.value.trim()
  if (!prompt) return

  messages.value.push({ role: 'user', content: prompt })
  userInput.value = ''
  isTyping.value = true
  scrollToBottom()

  try {
    const history = messages.value.slice(0, -1).map(m => ({
      role: m.role === 'user' ? 'user' : 'model',
      parts: [{ text: m.content }]
    }))

    const data: any = await $fetch('/api/chat', {
      method: 'POST',
      body: { prompt, history }
    })

    messages.value.push({ role: 'assistant', content: data.responseText })

    const context = (prompt + ' ' + data.responseText).toLowerCase()
    if (context.includes('skill')) renderChart('skills')
    else if (context.includes('project')) renderChart('projects')
    else if (context.includes('productivity') || context.includes('hour') || context.includes('activity')) renderChart('productivity')

  } catch {
    messages.value.push({ role: 'assistant', content: "I am ready to help! Ask me about Panha's skills, projects, or Supabase experience." })
  } finally {
    isTyping.value = false
    scrollToBottom()
  }
}

const renderChart = (type: keyof typeof chartDataModels) => {
  currentChart.value = type
  const model = chartDataModels[type]
  currentChartTitle.value = model.title

  nextTick(() => {
    if (!chartCanvas.value) return
    if (chartInstance) chartInstance.destroy()

    chartInstance = new Chart(chartCanvas.value, {
      type: model.type as any,
      data: {
        labels: model.labels,
        datasets: [{
          label: model.label,
          data: model.data,
          backgroundColor: model.colors.bg,
          borderColor: model.colors.border,
          borderWidth: 2,
          pointBackgroundColor: model.colors.border,
          pointRadius: 5,
          tension: 0.4,
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { labels: { color: '#94a3b8', font: { size: 11 } } }
        },
        scales: model.type !== 'radar' ? {
          y: {
            ticks: { color: '#94a3b8', font: { size: 11 } },
            grid: { color: 'rgba(255,255,255,0.05)' }
          },
          x: {
            ticks: { color: '#94a3b8', font: { size: 11 } },
            grid: { display: false }
          }
        } : {
          r: {
            angleLines: { color: 'rgba(255,255,255,0.08)' },
            grid: { color: 'rgba(255,255,255,0.08)' },
            pointLabels: { color: '#94a3b8', font: { size: 11, weight: 'bold' } },
            ticks: { display: false }
          }
        }
      }
    })
  })
}

const resetChart = () => {
  if (chartInstance) chartInstance.destroy()
  currentChart.value = null
}

const clearChat = () => {
  messages.value = [
    { role: 'assistant', content: 'Chat history cleared. How can I assist you with Panha’s portfolio?' }
  ]
}
</script>

<style scoped>
.chat-panel, .chart-panel {
  background-color: var(--glass-bg);
  backdrop-filter: blur(24px);
  border: 1px solid var(--glass-border);
  border-radius: 28px;
  padding: 1.5rem;
}

.bot-avatar {
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 12px;
  background: linear-gradient(135deg, #811cd9, #00fbfb);
  display: flex;
  align-items: center;
  justify-content: center;
}

.status-dot {
  display: inline-block;
  width: 6px;
  height: 6px;
  background: #10b981;
  border-radius: 50%;
  box-shadow: 0 0 8px #10b981;
  animation: pulse 2s infinite;
}

.user-bubble {
  background: linear-gradient(135deg, rgba(129, 28, 217, 0.8), rgba(129, 28, 217, 0.6));
  color: #fff;
  border-top-right-radius: 4px;
}

.bot-bubble {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid var(--glass-border);
  border-top-left-radius: 4px;
  color: var(--text);
}

.dot-bounce {
  width: 6px;
  height: 6px;
  background: #00fbfb;
  border-radius: 50%;
  animation: bounce 0.6s ease-in-out infinite alternate;
}

.input-wrap {
  position: relative;
}

.chat-input {
  width: 100%;
  background: rgba(0, 0, 0, 0.1);
  border: 1px solid var(--glass-border);
  border-radius: 16px;
  padding: 0.75rem 3.5rem 0.75rem 1.25rem;
  font-size: 0.875rem;
  color: var(--text);
  outline: none;
}

.send-btn {
  position: absolute;
  right: 0.5rem;
  top: 50%;
  transform: translateY(-50%);
  width: 2.25rem;
  height: 2.25rem;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #811cd9, #00fbfb);
  border-radius: 10px;
  color: #fff;
  border: none;
}

.icon-ring {
  position: relative;
  width: 90px;
  height: 90px;
  border-radius: 24px;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.08);
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto;
}

.chart-canvas-wrap {
  background: rgba(0, 0, 0, 0.15);
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 20px;
  padding: 1rem;
}

.clear-btn {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.35rem 0.75rem;
  font-size: 0.7rem;
  font-weight: 700;
  text-transform: uppercase;
  color: var(--text-muted);
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid var(--glass-border);
  border-radius: 8px;
}

@keyframes bounce {
  from { transform: translateY(0); }
  to { transform: translateY(-5px); }
}
</style>