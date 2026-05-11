<template>
  <section id="chart-ai" class="py-24 bg-background text-on-background relative overflow-hidden" ref="sectionRef">
    <!-- Ambient Glow Background -->
    <div class="absolute top-0 left-0 w-full h-full pointer-events-none transition-opacity duration-1000"
      :class="isVisible ? 'opacity-100' : 'opacity-0'">
      <div class="absolute top-[-15%] left-[-10%] w-[45%] h-[45%] bg-primary/10 rounded-full blur-[140px]"></div>
      <div class="absolute bottom-[-15%] right-[-10%] w-[45%] h-[45%] bg-secondary/10 rounded-full blur-[140px]"></div>
      <div class="absolute top-[40%] left-[30%] w-[30%] h-[30%] bg-primary/5 rounded-full blur-[100px]"></div>
    </div>

    <div class="max-w-7xl mx-auto px-4 md:px-8 relative z-10">
      <!-- Header -->
      <div class="text-center mb-14 transition-all duration-700 ease-out"
        :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 -translate-y-8'">
        <span class="text-xs tracking-[0.3em] text-primary uppercase mb-4 block font-bold">Interactive Analytics</span>
        <h2 class="text-4xl md:text-5xl font-black tracking-tighter leading-none mb-4">
          <span class="text-secondary">AI</span> Assistant
        </h2>
        <p class="text-on-surface-variant font-light max-w-2xl mx-auto">
          Explore my journey through data. Ask about my <span class="text-primary font-medium">skills</span>, <span
            class="text-secondary font-medium">projects</span>, or <span
            class="text-white/70 font-medium">productivity</span>.
        </p>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">

        <!-- ─── Chat Interface ─────────────────────────────────────────── -->
        <div class="lg:col-span-4 chat-panel flex flex-col h-[620px] transition-all duration-700 ease-out delay-100"
          :class="isVisible ? 'opacity-100 translate-x-0' : 'opacity-0 -translate-x-12'">

          <!-- Bot Header -->
          <div class="flex items-center justify-between mb-6 pb-4 border-b border-black/10 dark:border-white/5">
            <div class="flex items-center gap-3">
              <div class="bot-avatar">
                <span class="material-symbols-outlined text-white text-xl">smart_toy</span>
              </div>
              <div>
                <h3 class="font-black text-sm tracking-wider uppercase text-on-background">Analyst Bot</h3>
                <span
                  class="text-[10px] text-emerald-600 dark:text-emerald-400 flex items-center gap-1.5 font-semibold">
                  <span class="status-dot"></span>
                  Gemini Flash 1.5
                </span>
              </div>
            </div>
            <div class="flex gap-1.5">
              <div class="w-2 h-2 rounded-full bg-black/10 dark:bg-white/10"></div>
              <div class="w-2 h-2 rounded-full bg-black/10 dark:bg-white/10"></div>
              <div class="w-2 h-2 rounded-full bg-black/10 dark:bg-white/10"></div>
            </div>
          </div>

          <!-- Messages -->
          <div ref="chatContainer" class="flex-1 overflow-y-auto mb-5 space-y-5 pr-2 custom-scrollbar">
            <div v-for="(msg, index) in messages" :key="index"
              :class="['flex flex-col', msg.role === 'user' ? 'items-end' : 'items-start']">
              <span class="text-[10px] uppercase tracking-widest opacity-40 mb-1 mx-1 text-on-background">
                {{ msg.role === 'user' ? 'You' : 'Bot' }}
              </span>
              <div :class="[
                'max-w-[88%] px-4 py-3 rounded-2xl text-sm leading-relaxed transition-transform duration-200 hover:scale-[1.02]',
                msg.role === 'user'
                  ? 'user-bubble'
                  : 'bot-bubble'
              ]">
                {{ msg.content }}
              </div>
            </div>

            <!-- Typing indicator -->
            <div v-if="isTyping" class="flex flex-col items-start typing-entry">
              <span class="text-[10px] uppercase tracking-widest opacity-40 mb-1 mx-1 text-on-background">Bot</span>
              <div class="bot-bubble px-4 py-3 rounded-2xl flex gap-1.5">
                <span class="dot-bounce" style="animation-delay: 0s"></span>
                <span class="dot-bounce" style="animation-delay: 0.18s"></span>
                <span class="dot-bounce" style="animation-delay: 0.36s"></span>
              </div>
            </div>
          </div>

          <!-- Input Form -->
          <form @submit.prevent="handleSendMessage" class="relative input-wrap">
            <input v-model="userInput" type="text" placeholder="Ask about my stats..." class="chat-input"
              :disabled="isTyping" />
            <button type="submit" class="send-btn" :disabled="!userInput.trim() || isTyping">
              <span class="material-symbols-outlined">send</span>
            </button>
          </form>
        </div>

        <!-- ─── Chart Visualization ────────────────────────────────────── -->
        <div
          class="lg:col-span-8 chart-panel min-h-[620px] flex flex-col items-center justify-center relative overflow-hidden transition-all duration-700 ease-out delay-300"
          :class="isVisible ? 'opacity-100 translate-x-0' : 'opacity-0 translate-x-12'">
          <!-- Grid overlay -->
          <div class="chart-grid-bg"></div>

          <!-- Empty state -->
          <div v-if="!currentChart" class="text-center relative z-10 empty-state">
            <div class="icon-ring">
              <div class="icon-glow"></div>
              <span class="material-symbols-outlined text-5xl text-primary animate-float">monitoring</span>
            </div>
            <h4 class="text-2xl font-black tracking-tight mt-6 mb-2">Neural Analysis Engine</h4>
            <p class="text-on-surface-variant text-sm font-light max-w-xs mx-auto">
              Ask about <span class="text-primary font-semibold">skills</span>,
              <span class="text-secondary font-semibold">projects</span>, or
              <span class="text-white/60 font-semibold">productivity</span> to generate a chart.
            </p>
          </div>

          <!-- Chart area -->
          <div v-show="currentChart" class="w-full h-full flex flex-col relative z-10 chart-reveal">
            <div class="mb-6 flex justify-between items-end px-2">
              <div>
                <span class="text-[10px] uppercase tracking-[0.3em] text-primary mb-1 block font-bold">Data
                  Visualization</span>
                <h3 class="text-2xl font-black tracking-tighter text-on-background">{{ currentChartTitle }}</h3>
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

const messages = ref([
  { role: 'assistant', content: 'Hello! I can visualize your skills, projects, and productivity. Ask me something like "What are your core skills?"' }
])

const chartDataModels = {
  skills: {
    title: 'Technical Proficiency',
    type: 'radar',
    labels: ['Frontend', 'Backend', 'UI/UX', 'DevOps', 'Mobile', 'Database'],
    data: [95, 85, 78, 82, 70, 88],
    label: 'Proficiency %',
    colors: { bg: 'rgba(0, 251, 251, 0.15)', border: '#00fbfb' }
  },
  projects: {
    title: 'Project Ecosystem',
    type: 'bar',
    labels: ['Web Apps', 'Automation', 'Mobile', 'Open Source', 'UI Kits'],
    data: [12, 8, 4, 15, 6],
    label: 'Completed',
    colors: { bg: 'rgba(255, 129, 245, 0.4)', border: '#ff81f5' }
  },
  productivity: {
    title: 'Weekly Coding Activity',
    type: 'line',
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    data: [7, 9, 6, 8, 10, 4, 3],
    label: 'Deep Work Hours',
    colors: { bg: 'rgba(0, 251, 251, 0.1)', border: '#00fbfb' }
  }
}

const scrollToBottom = async () => {
  await nextTick()
  if (chatContainer.value) {
    chatContainer.value.scrollTo({ top: chatContainer.value.scrollHeight, behavior: 'smooth' })
  }
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
    messages.value.push({ role: 'assistant', content: "I'm having trouble connecting to my brain. Try again?" })
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
          pointHoverRadius: 8,
          tension: 0.4,
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { labels: { color: '#888', font: { size: 11 } } },
          tooltip: {
            backgroundColor: 'rgba(10,10,20,0.9)',
            borderColor: model.colors.border,
            borderWidth: 1,
            titleColor: '#fff',
            bodyColor: 'rgba(255,255,255,0.7)',
            padding: 12,
            cornerRadius: 10
          }
        },
        scales: model.type !== 'radar' ? {
          y: {
            ticks: { color: '#888', font: { size: 11 } },
            grid: { color: 'rgba(128,128,128,0.1)' },
            border: { color: 'rgba(128,128,128,0.1)' }
          },
          x: {
            ticks: { color: '#888', font: { size: 11 } },
            grid: { display: false },
            border: { color: 'rgba(128,128,128,0.1)' }
          }
        } : {
          r: {
            angleLines: { color: 'rgba(128,128,128,0.1)' },
            grid: { color: 'rgba(128,128,128,0.1)' },
            pointLabels: { color: '#888', font: { size: 12, weight: 'bold' } },
            ticks: { display: false, backdropColor: 'transparent' }
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
</script>

<style scoped>
/* ── Panels ──────────────────────────────────────────────────────── */
.chat-panel {
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
  border: 1px solid rgba(0, 0, 0, 0.08);
  border-radius: 28px;
  padding: 1.75rem;
  box-shadow:
    0 0 0 1px rgba(0, 0, 0, 0.04) inset,
    0 8px 32px rgba(0, 0, 0, 0.1),
    0 32px 80px rgba(0, 0, 0, 0.05);
}

.dark .chat-panel {
  background: rgba(10, 10, 20, 0.6);
  border: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow:
    0 0 0 1px rgba(255, 255, 255, 0.04) inset,
    0 8px 32px rgba(0, 0, 0, 0.5),
    0 32px 80px rgba(0, 0, 0, 0.4),
    0 0 60px rgba(0, 251, 251, 0.04);
}

.chart-panel {
  background: rgba(255, 255, 255, 0.5);
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
  border: 1px solid rgba(0, 0, 0, 0.07);
  border-radius: 28px;
  padding: 2rem;
  box-shadow:
    0 0 0 1px rgba(0, 0, 0, 0.03) inset,
    0 8px 40px rgba(0, 0, 0, 0.1),
    0 40px 100px rgba(0, 0, 0, 0.05);
}

.dark .chart-panel {
  background: rgba(10, 10, 20, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.07);
  box-shadow:
    0 0 0 1px rgba(255, 255, 255, 0.03) inset,
    0 8px 40px rgba(0, 0, 0, 0.55),
    0 40px 100px rgba(0, 0, 0, 0.45),
    0 0 80px rgba(129, 28, 217, 0.06);
}

/* ── Grid overlay ────────────────────────────────────────────────── */
.chart-grid-bg {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(0, 0, 0, 0.05) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0, 0, 0, 0.05) 1px, transparent 1px);
  background-size: 32px 32px;
  border-radius: 28px;
  pointer-events: none;
}

.dark .chart-grid-bg {
  background-image:
    linear-gradient(rgba(255, 255, 255, 0.025) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255, 255, 255, 0.025) 1px, transparent 1px);
}

/* ── Bot avatar ──────────────────────────────────────────────────── */
.bot-avatar {
  width: 2.75rem;
  height: 2.75rem;
  border-radius: 14px;
  background: linear-gradient(135deg, #811cd9, #00fbfb);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow:
    0 4px 16px rgba(129, 28, 217, 0.4),
    0 0 30px rgba(0, 251, 251, 0.15);
  flex-shrink: 0;
}

/* ── Status dot ──────────────────────────────────────────────────── */
.status-dot {
  display: inline-block;
  width: 6px;
  height: 6px;
  background: #34d399;
  border-radius: 50%;
  box-shadow: 0 0 8px rgba(52, 211, 153, 0.8);
  animation: pulse 2s ease-in-out infinite;
}

/* ── Chat bubbles ────────────────────────────────────────────────── */
.user-bubble {
  background: linear-gradient(135deg, rgba(129, 28, 217, 0.15), rgba(129, 28, 217, 0.05));
  border: 1px solid rgba(129, 28, 217, 0.2);
  border-top-right-radius: 4px;
  color: #333;
  box-shadow:
    0 2px 12px rgba(129, 28, 217, 0.1),
    0 4px 20px rgba(0, 0, 0, 0.05);
}

.dark .user-bubble {
  background: linear-gradient(135deg, rgba(129, 28, 217, 0.25), rgba(129, 28, 217, 0.1));
  border: 1px solid rgba(129, 28, 217, 0.3);
  color: #f0f0f0;
  box-shadow:
    0 2px 12px rgba(129, 28, 217, 0.2),
    0 4px 20px rgba(0, 0, 0, 0.3);
}

.bot-bubble {
  background: linear-gradient(135deg, rgba(0, 0, 0, 0.05), rgba(0, 0, 0, 0.02));
  border: 1px solid rgba(0, 0, 0, 0.05);
  border-top-left-radius: 4px;
  color: #333;
  box-shadow:
    0 2px 12px rgba(0, 0, 0, 0.05),
    0 4px 20px rgba(0, 0, 0, 0.02);
}

.dark .bot-bubble {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.07), rgba(255, 255, 255, 0.03));
  border: 1px solid rgba(255, 255, 255, 0.08);
  color: rgba(255, 255, 255, 0.75);
  box-shadow:
    0 2px 12px rgba(0, 0, 0, 0.3),
    0 4px 20px rgba(0, 0, 0, 0.2);
}

/* ── Typing dots ─────────────────────────────────────────────────── */
.dot-bounce {
  display: inline-block;
  width: 8px;
  height: 8px;
  background: #00fbfb;
  border-radius: 50%;
  box-shadow: 0 0 8px rgba(0, 251, 251, 0.6);
  animation: bounce 0.6s ease-in-out infinite alternate;
}

/* ── Input wrap ──────────────────────────────────────────────────── */
.input-wrap {
  position: relative;
}

.input-wrap::before {
  content: '';
  position: absolute;
  inset: -1px;
  border-radius: 18px;
  background: linear-gradient(135deg, rgba(129, 28, 217, 0.3), rgba(0, 251, 251, 0.3));
  opacity: 0;
  transition: opacity 0.3s ease;
  z-index: 0;
  pointer-events: none;
}

.input-wrap:focus-within::before {
  opacity: 1;
}

.chat-input {
  position: relative;
  z-index: 1;
  width: 100%;
  background: rgba(255, 255, 255, 0.5);
  border: 1px solid rgba(0, 0, 0, 0.1);
  border-radius: 16px;
  padding: 0.85rem 3.5rem 0.85rem 1.25rem;
  font-size: 0.875rem;
  color: #333;
  outline: none;
  transition: border-color 0.3s ease, box-shadow 0.3s ease;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05) inset;
}

.dark .chat-input {
  background: rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.08);
  color: #fff;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3) inset;
}

.chat-input::placeholder {
  color: rgba(0, 0, 0, 0.5);
}

.dark .chat-input::placeholder {
  color: rgba(255, 255, 255, 0.2);
}

.chat-input:focus {
  border-color: rgba(129, 28, 217, 0.4);
  box-shadow:
    0 2px 12px rgba(0, 0, 0, 0.05) inset,
    0 0 20px rgba(129, 28, 217, 0.15);
}

.dark .chat-input:focus {
  box-shadow:
    0 2px 12px rgba(0, 0, 0, 0.3) inset,
    0 0 20px rgba(129, 28, 217, 0.15);
}

.chat-input:disabled {
  opacity: 0.5;
}

.send-btn {
  position: absolute;
  right: 0.6rem;
  top: 50%;
  transform: translateY(-50%);
  z-index: 1;
  width: 2.25rem;
  height: 2.25rem;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #811cd9, #00fbfb);
  border-radius: 10px;
  color: #fff;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow:
    0 4px 14px rgba(129, 28, 217, 0.4),
    0 0 20px rgba(0, 251, 251, 0.15);
}

.send-btn:hover:not(:disabled) {
  transform: translateY(-50%) scale(1.08);
  box-shadow:
    0 6px 20px rgba(129, 28, 217, 0.5),
    0 0 30px rgba(0, 251, 251, 0.2);
}

.send-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

/* ── Empty state icon ────────────────────────────────────────────── */
.icon-ring {
  position: relative;
  width: 100px;
  height: 100px;
  border-radius: 24px;
  background: rgba(0, 0, 0, 0.03);
  border: 1px solid rgba(0, 0, 0, 0.08);
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto;
  box-shadow:
    0 8px 32px rgba(0, 0, 0, 0.05),
    0 0 60px rgba(0, 251, 251, 0.08);
}

.dark .icon-ring {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow:
    0 8px 32px rgba(0, 0, 0, 0.4),
    0 0 60px rgba(0, 251, 251, 0.08);
}

.icon-glow {
  position: absolute;
  inset: 0;
  background: rgba(0, 251, 251, 0.12);
  border-radius: 24px;
  filter: blur(16px);
  animation: pulse 3s ease-in-out infinite;
}

/* ── Chart canvas wrapper ────────────────────────────────────────── */
.chart-canvas-wrap {
  background: rgba(255, 255, 255, 0.5);
  border: 1px solid rgba(0, 0, 0, 0.05);
  border-radius: 20px;
  padding: 1.25rem;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.05) inset;
}

.dark .chart-canvas-wrap {
  background: rgba(0, 0, 0, 0.15);
  border: 1px solid rgba(255, 255, 255, 0.05);
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.3) inset;
}

/* ── Clear button ────────────────────────────────────────────────── */
.clear-btn {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0.45rem 1rem;
  font-size: 0.7rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: rgba(0, 0, 0, 0.5);
  background: rgba(0, 0, 0, 0.04);
  border: 1px solid rgba(0, 0, 0, 0.08);
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.25s ease;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.dark .clear-btn {
  color: rgba(255, 255, 255, 0.4);
  background: rgba(255, 255, 255, 0.04);
  border: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.25);
}

.clear-btn:hover {
  color: #000;
  background: rgba(0, 0, 0, 0.08);
  border-color: rgba(0, 0, 0, 0.14);
}

.dark .clear-btn:hover {
  color: #fff;
  background: rgba(255, 255, 255, 0.08);
  border-color: rgba(255, 255, 255, 0.14);
  box-shadow:
    0 4px 16px rgba(0, 0, 0, 0.3),
    0 0 20px rgba(129, 28, 217, 0.1);
}

/* ── Scrollbar ───────────────────────────────────────────────────── */
.custom-scrollbar::-webkit-scrollbar {
  width: 3px;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(0, 0, 0, 0.1);
  border-radius: 10px;
}

.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.1);
}

.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: rgba(129, 28, 217, 0.4);
}

/* ── Animations ──────────────────────────────────────────────────── */
@keyframes float {

  0%,
  100% {
    transform: translateY(0);
  }

  50% {
    transform: translateY(-10px);
  }
}

@keyframes pulse {

  0%,
  100% {
    opacity: 1;
  }

  50% {
    opacity: 0.4;
  }
}

@keyframes bounce {
  from {
    transform: translateY(0);
  }

  to {
    transform: translateY(-6px);
  }
}

@keyframes chartReveal {
  from {
    opacity: 0;
    transform: scale(0.97) translateY(8px);
  }

  to {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

@keyframes typingIn {
  from {
    opacity: 0;
    transform: translateY(6px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-float {
  animation: float 4s ease-in-out infinite;
}

.chart-reveal {
  animation: chartReveal 0.45s ease-out both;
}

.typing-entry {
  animation: typingIn 0.3s ease-out both;
}
</style>