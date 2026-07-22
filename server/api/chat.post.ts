import { GoogleGenerativeAI } from '@google/generative-ai'
import { createClient } from '@supabase/supabase-js'

const SYSTEM_INSTRUCTION = `
You are the official AI Portfolio Assistant for Nheb Panha.
Panha is a professional Full-Stack Developer & Mobile App Architect based in Phnom Penh, Cambodia (UTC+7).

Key Profile Information about Nheb Panha:
- Specialties: Flutter & Dart cross-platform mobile apps, Nuxt 3 (Vue 3) SSR web apps, Supabase real-time databases, Laravel REST APIs, Tailwind CSS.
- Background: Accounting-Developer background giving him financial precision, clean data modeling capabilities, and strong UI/UX aesthetic design skills.
- Key Projects:
  1. FinTech Wallet & Payment Suite (Flutter, Laravel, PostgreSQL, Biometrics, Real-time Ledger)
  2. Nexus Logistics & Fleet Engine (Nuxt 3, Supabase, Google Maps API, Real-time GPS Telemetry)
  3. Aura E-Commerce Platform (Vue 3, Firebase, Stripe Checkout)
  4. Precision Accounting Suite (Laravel, TypeScript, Tailwind)
  5. Smart HR & Payroll Engine (Nuxt 3, Laravel, MySQL)
  6. AgriTech Monitor IoT (Flutter, Node.js, Supabase)
- Contact Info: Email: samlot.development@gmail.com, Location: Phnom Penh, Cambodia.
- Availability: Available for Freelance Projects and Full-time Software Engineering roles.

Instructions:
Be extremely helpful, polite, professional, concise (under 75 words), and enthusiastic. Highlight Panha's expertise in Flutter, Supabase, Nuxt 3, and Laravel.
`.trim()

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const body = await readBody(event)
  const { prompt, history } = body || {}

  if (!prompt || typeof prompt !== 'string') {
    return { responseText: "Hello! How can I help you explore Nheb Panha's portfolio today?" }
  }

  const lowerPrompt = prompt.toLowerCase()
  let finalResponse = ""

  // 1. Try Live Gemini AI if API Key is configured
  const apiKey = config.geminiApiKey || process.env.NUXT_GEMINI_API_KEY || process.env.GEMINI_API_KEY

  if (apiKey && apiKey.trim() !== '') {
    try {
      const genAI = new GoogleGenerativeAI(apiKey)
      
      // Try models sequentially for maximum resilience
      const candidateModels = ['gemini-1.5-flash', 'gemini-flash-latest', 'gemini-2.5-flash', 'gemini-pro']
      let modelSuccess = false

      for (const modelName of candidateModels) {
        if (modelSuccess) break
        try {
          const model = genAI.getGenerativeModel({
            model: modelName,
            systemInstruction: SYSTEM_INSTRUCTION
          })

          const safeHistory = Array.isArray(history) ? history : []
          const filteredHistory = safeHistory.filter((m: any, idx: number) => {
            if (idx === 0 && m.role === 'model') return false
            return m.role && m.parts && m.parts.length > 0
          })

          const chat = model.startChat({ history: filteredHistory })
          const result = await chat.sendMessage(prompt)
          finalResponse = result.response.text()
          if (finalResponse) {
            modelSuccess = true
          }
        } catch (err: any) {
          console.warn(`Model ${modelName} attempt failed:`, err?.message || err)
        }
      }
    } catch (error: any) {
      console.error('Gemini GenAI Initialization Exception:', error?.message || error)
    }
  }

  // 2. Intelligent AI Context Fallback (if API Key is missing or failed)
  if (!finalResponse) {
    if (lowerPrompt.includes('supabase')) {
      finalResponse = "Nheb Panha leverages Supabase for real-time PostgreSQL databases, authentication, serverless functions, and Row Level Security. Supabase powers this portfolio's dynamic project showcase and contact storage!"
    } else if (lowerPrompt.includes('skill') || lowerPrompt.includes('stack') || lowerPrompt.includes('tech')) {
      finalResponse = "Panha's core technology stack includes Flutter & Dart for cross-platform mobile apps, Nuxt 3 & Vue 3 for web apps, Supabase & PostgreSQL for cloud databases, and Laravel for backend APIs."
    } else if (lowerPrompt.includes('project') || lowerPrompt.includes('work') || lowerPrompt.includes('portfolio')) {
      finalResponse = "Panha has engineered multiple high-precision ecosystems including FinTech Wallet, Nexus Logistics Fleet Engine, Aura E-Commerce, Precision Accounting, Smart HR Payroll, and AgriTech IoT Monitor."
    } else if (lowerPrompt.includes('about') || lowerPrompt.includes('who is') || lowerPrompt.includes('who are')) {
      finalResponse = "Nheb Panha is a Full-Stack Architect & Mobile App Specialist based in Phnom Penh, Cambodia. He combines accounting data precision with modern UI/UX design and clean software architecture."
    } else if (lowerPrompt.includes('contact') || lowerPrompt.includes('email') || lowerPrompt.includes('hire')) {
      finalResponse = "You can contact Nheb Panha directly via email at samlot.development@gmail.com or through the Contact section on this page! He is currently open for freelance & full-time opportunities."
    } else if (lowerPrompt.includes('hello') || lowerPrompt.includes('hi') || lowerPrompt.includes('hey')) {
      finalResponse = "Hello! I am Panha's AI Portfolio Assistant. Ask me about Panha's Flutter apps, Supabase integration, Nuxt 3 projects, or how to contact him!"
    } else {
      finalResponse = "I'm Panha's AI Assistant! I can answer anything about Panha's Flutter mobile apps, Supabase real-time databases, Nuxt 3 web ecosystems, or career experience. What would you like to explore?"
    }
  }

  // 3. Asynchronously store chat telemetry in Supabase chat_logs table if connected
  const supabaseUrl = config.public.supabaseUrl as string
  const supabaseKey = (config.supabaseServiceRoleKey || config.public.supabaseAnonKey) as string

  if (supabaseUrl && supabaseKey && supabaseUrl.startsWith('http')) {
    try {
      const supabase = createClient(supabaseUrl, supabaseKey)
      supabase.from('chat_logs').insert([
        {
          user_prompt: prompt,
          bot_response: finalResponse
        }
      ]).then(({ error }) => {
        if (error) console.warn('Supabase chat_logs insert log:', error.message)
      })
    } catch (e) {
      // ignore telemetry errors
    }
  }

  return { responseText: finalResponse }
})
