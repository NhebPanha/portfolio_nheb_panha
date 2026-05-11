import { GoogleGenerativeAI } from '@google/generative-ai'

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const body = await readBody(event)
  const { prompt, history } = body

  const lowerPrompt = prompt.toLowerCase()

  // --- AI RESPONSES / PORTFOLIO ASSISTANT ---
  const fakeResponses: Record<string, string> = {
    'about':
      "Nheb Panha is an innovative Accounting-Developer passionate about combining technology, business, and modern UI/UX design. He specializes in Flutter, Vue.js, Nuxt, Laravel, and Supabase, building smart digital solutions with clean architecture and user-focused experiences.",

    'who are you':
      "I'm the AI assistant for Nheb Panha's portfolio. I help visitors explore Panha's technical skills, projects, experience, and productivity through interactive conversations and visual insights.",

    'who is panha':
      "Nheb Panha is a full-stack developer and designer with experience in mobile app development, web applications, and business systems. He enjoys creating modern, scalable, and visually engaging digital products.",

    'tell me about yourself':
      "I'm Nheb Panha, a passionate developer focused on Flutter, Vue/Nuxt, Laravel APIs, UI/UX design, and AI-powered applications. I love building creative solutions that combine performance, clean code, and great user experiences.",

    'introduce yourself':
      "Hello! I'm Nheb Panha — an Accounting-Developer and full-stack creator who enjoys transforming ideas into real applications. My expertise includes Flutter, Vue.js, Nuxt 3, Laravel, Supabase, and modern frontend technologies.",

    'skill':
      "Panha has strong experience in Flutter, Dart, Vue.js, Nuxt 3, Laravel, Supabase, Firebase, REST APIs, UI/UX Design, and responsive frontend development. He also works with AI integrations and data visualization.",

    'skills':
      "Panha's technical stack includes Flutter, Vue.js, Nuxt, Laravel, Supabase, Firebase, Tailwind CSS, Bootstrap, REST APIs, and modern UI/UX design principles.",

    'project':
      "Panha has developed multiple real-world projects including food delivery apps, wallet systems, grocery apps, AI dashboards, delivery tracking systems, attendance management systems, and e-commerce platforms.",

    'projects':
      "Panha's portfolio includes mobile apps, admin dashboards, business systems, and AI-powered web applications built using Flutter, Vue/Nuxt, Laravel, and Supabase.",

    'experience':
      "Panha has experience building scalable frontend and backend systems, designing modern interfaces, integrating APIs, and creating smooth user experiences across mobile and web platforms.",

    'productivity':
      "Panha maintains strong productivity through consistent development, UI experimentation, problem-solving, and continuous learning in both frontend and backend technologies.",

    'stats':
      "I can show insights about Panha's skills, projects, technologies, coding activity, and development journey. What would you like to explore?",

    'contact':
      "You can connect with Nheb Panha for collaborations, freelance projects, or development opportunities through the portfolio contact section.",

    'hello':
      "Hello! Welcome to Nheb Panha's AI-powered portfolio. Ask me about skills, projects, technologies, or development experience.",

    'hi':
      "Hi there! I'm here to help you explore Nheb Panha's portfolio, projects, and technical journey.",

    'default':
      "I'm here to help you learn more about Nheb Panha's portfolio, skills, projects, and development experience. Try asking about 'skills', 'projects', or 'about'."
  }

  // Intercept "About Me" specifically
  if (lowerPrompt.includes('about') || lowerPrompt.includes('who are you') || lowerPrompt.includes('background')) {
    return { responseText: fakeResponses['about'] }
  }

  // This looks at runtimeConfig.GEMINI_API_KEY defined in nuxt.config.ts
  const apiKey = config.geminiApiKey

  // If no API key, use fake responses based on keywords
  if (!apiKey) {
    for (const key in fakeResponses) {
      if (lowerPrompt.includes(key)) {
        return { responseText: fakeResponses[key] }
      }
    }
    return { responseText: "I'm currently in offline mode, but I can still tell you about Panha's skills, projects, and productivity! Just ask about one of those." }
  }

  try {
    const genAI = new GoogleGenerativeAI(apiKey)

    // Using gemini-flash-latest for best performance
    const model = genAI.getGenerativeModel({
      model: "gemini-flash-latest",
      systemInstruction: "You are a professional, witty data analyst for Nheb Panha's portfolio. Nheb is an Accounting-Developer. You have access to three data types: 'skills', 'projects', and 'productivity'. If the user asks about these, explain that you are visualizing them. Keep responses under 50 words."
    })

    const safeHistory = Array.isArray(history) ? history : []
    const filteredHistory = safeHistory.filter((m: any, index: number) => {
      if (index === 0 && m.role === 'model') return false
      return true
    })

    const chat = model.startChat({
      history: filteredHistory,
    })

    const result = await chat.sendMessage(prompt)
    const responseText = result.response.text()

    return { responseText }

  } catch (error: any) {
    console.error('Gemini API Error:', error)

    // Fallback for leaked key or other API errors
    // Try to find a fake response first
    for (const key in fakeResponses) {
      if (lowerPrompt.includes(key)) {
        return { responseText: fakeResponses[key] }
      }
    }

    if (error.message?.includes('403') || error.message?.includes('API key')) {
      return {
        responseText: "I'm currently experiencing some technical difficulties with my neural link, but I can still guide you through Panha's stats! Try asking about 'skills', 'projects', or 'productivity'."
      }
    }

    throw createError({
      statusCode: 500,
      statusMessage: error.message || 'Internal Server Error'
    })
  }
})

