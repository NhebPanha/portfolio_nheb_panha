<template>
  <section id="chart-ai" class="py-24 bg-background text-on-background relative overflow-hidden">
    <div class="absolute top-0 left-0 w-full h-full opacity-5 pointer-events-none">
      <div class="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-primary rounded-full blur-[120px]"></div>
      <div class="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-secondary rounded-full blur-[120px]"></div>
    </div>

    <div class="max-w-7xl mx-auto px-4 md:px-8 relative z-10">
      <div class="text-center mb-12">
        <span class="text-xs tracking-[0.2em] text-primary uppercase mb-4 block">Interactive Analytics</span>
        <h2 class="text-4xl md:text-5xl font-black tracking-tighter leading-none mb-4">
          <span class="text-secondary">AI</span> Assistant
        </h2>
        <p class="text-on-surface-variant font-light max-w-2xl mx-auto mb-4">
          Explore my professional journey through data. Ask the AI about my "skills", "projects", or "weekly activity".
        </p>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        <div class="lg:col-span-4 glass-panel p-6 flex flex-col h-[600px]">
          <div class="flex items-center justify-between mb-6 pb-4 border-b border-white/10">
            <div class="flex items-center gap-3">
              <div
                class="w-10 h-10 rounded-full bg-gradient-to-br from-primary to-secondary flex items-center justify-center">
                <span class="material-symbols-outlined text-white text-sm">smart_toy</span>
              </div>
              <div>
                <h3 class="font-bold text-sm">Analyst Bot</h3>
                <span class="text-[10px] text-green-400 flex items-center gap-1">
                  <span class="w-1.5 h-1.5 bg-green-400 rounded-full animate-pulse"></span>
                  Gemini Live
                </span>
              </div>
            </div>
          </div>

          <div ref="chatContainer" class="flex-1 overflow-y-auto mb-4 space-y-4 pr-2 custom-scrollbar">
            <div v-for="(msg, index) in messages" :key="index"
              :class="['flex', msg.role === 'user' ? 'justify-end' : 'justify-start']">
              <div :class="[
                'max-w-[85%] p-3 rounded-2xl text-sm leading-relaxed transition-all',
                msg.role === 'user'
                  ? 'bg-primary/20 border border-primary/30 text-on-background rounded-tr-none'
                  : 'bg-white/5 border border-white/10 text-on-surface-variant rounded-tl-none'
              ]">
                {{ msg.content }}
              </div>
            </div>
            <div v-if="isTyping" class="flex justify-start">
              <div class="bg-white/5 border border-white/10 p-3 rounded-2xl rounded-tl-none flex gap-1">
                <span class="w-1.5 h-1.5 bg-secondary rounded-full animate-bounce"></span>
                <span class="w-1.5 h-1.5 bg-secondary rounded-full animate-bounce [animation-delay:0.2s]"></span>
                <span class="w-1.5 h-1.5 bg-secondary rounded-full animate-bounce [animation-delay:0.4s]"></span>
              </div>
            </div>
          </div>

          <form @submit.prevent="handleSendMessage" class="relative">
            <input v-model="userInput" type="text" placeholder="Ask about my stats..."
              class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm focus:ring-1 focus:ring-primary/50 outline-none text-white transition-all"
              :disabled="isTyping" />
            <button type="submit"
              class="absolute right-2 top-1.5 p-1.5 text-primary hover:text-secondary disabled:opacity-50"
              :disabled="!userInput.trim() || isTyping">
              <span class="material-symbols-outlined">send</span>
            </button>
          </form>
        </div>

        <div class="lg:col-span-8 glass-panel p-8 min-h-[500px] flex flex-col items-center justify-center relative">
          <div v-if="!currentChart" class="text-center opacity-40">
            <span class="material-symbols-outlined text-6xl mb-4">monitoring</span>
            <p class="text-lg font-medium">Ready for Data Query</p>
            <p class="text-sm mt-2">Try: "Show me your backend vs frontend skills"</p>
          </div>

          <div v-show="currentChart" class="w-full h-full flex flex-col">
            <div class="mb-6 flex justify-between items-center">
              <h3 class="text-xl font-bold text-primary">{{ currentChartTitle }}</h3>
              <button @click="resetChart"
                class="text-xs text-on-surface-variant hover:text-white flex items-center gap-1 bg-white/5 px-3 py-1 rounded-full border border-white/10">
                <span class="material-symbols-outlined text-sm">close</span> Clear Chart
              </button>
            </div>
            <div class="relative flex-1">
              <canvas ref="chartCanvas"></canvas>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue'
import { Chart, registerables } from 'chart.js'

Chart.register(...registerables)

// State Refs
const chatContainer = ref<HTMLElement | null>(null)
const chartCanvas = ref<HTMLCanvasElement | null>(null)
let chartInstance: Chart | null = null

const userInput = ref('')
const isTyping = ref(false)
const currentChart = ref<string | null>(null)
const currentChartTitle = ref('')

const messages = ref([
  { role: 'assistant', content: 'Hello! I am your personal data analyst. I can generate charts for your skills, project distribution, and weekly productivity. What would you like to see?' }
])

// Hardcoded data models for the AI to trigger
const chartDataModels = {
  skills: {
    title: 'Technical Proficiency',
    type: 'radar',
    labels: ['Frontend', 'Backend', 'UI/UX', 'DevOps', 'Mobile', 'Database'],
    data: [95, 85, 78, 82, 70, 88],
    label: 'Skill Level %',
    colors: { bg: 'rgba(0, 251, 251, 0.2)', border: '#00fbfb' }
  },
  projects: {
    title: 'Project Category Distribution',
    type: 'bar',
    labels: ['Web Apps', 'Automation', 'Mobile', 'Open Source', 'UI Kits'],
    data: [12, 8, 4, 15, 6],
    label: 'Count',
    colors: { bg: 'rgba(255, 129, 245, 0.5)', border: '#ff81f5' }
  },
  productivity: {
    title: 'Weekly Deep Work Hours',
    type: 'line',
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    data: [7, 9, 6, 8, 10, 4, 3],
    label: 'Hours Coding',
    colors: { bg: 'rgba(0, 251, 251, 0.1)', border: '#00fbfb' }
  }
}

const scrollToBottom = async () => {
  await nextTick()
  if (chatContainer.value) {
    chatContainer.value.scrollTop = chatContainer.value.scrollHeight
  }
}

const handleSendMessage = async () => {
  const prompt = userInput.value.trim()
  if (!prompt) return

  // User Message
  messages.value.push({ role: 'user', content: prompt })
  userInput.value = ''
  isTyping.value = true
  scrollToBottom()

  try {
    const history = messages.value.slice(0, -1).map(m => ({
      role: m.role === 'user' ? 'user' : 'model',
      parts: [{ text: m.content }],
    }))

    const data = await $fetch('/api/chat', {
      method: 'POST',
      body: {
        prompt,
        history
      }
    })

    const responseText = data.responseText

    // AI Response
    messages.value.push({ role: 'assistant', content: responseText })

    // Chart Trigger Logic
    const fullContext = (prompt + " " + responseText).toLowerCase()

    if (fullContext.includes('skill')) renderChart('skills')
    else if (fullContext.includes('project')) renderChart('projects')
    else if (fullContext.includes('productivity') || fullContext.includes('hour') || fullContext.includes('activity')) renderChart('productivity')

  } catch (error: any) {
    console.error("Gemini Error:", error)
    messages.value.push({ role: 'assistant', content: "Connection error. Please try again later." })
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
          tension: 0.4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { labels: { color: '#ffffff', font: { weight: 'bold' } } }
        },
        scales: model.type !== 'radar' ? {
          y: { grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: 'rgba(255,255,255,0.7)' } },
          x: { grid: { display: false }, ticks: { color: 'rgba(255,255,255,0.7)' } }
        } : {
          r: {
            grid: { color: 'rgba(255,255,255,0.1)' },
            angleLines: { color: 'rgba(255,255,255,0.1)' },
            pointLabels: { color: '#ffffff', font: { size: 11 } },
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

onMounted(() => {
  scrollToBottom()
})
</script>

<style scoped>
.glass-panel {
  background: rgba(255, 255, 255, 0.02);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  border: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
}

.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
}

canvas {
  width: 100% !important;
  height: 100% !important;
}
</style>
