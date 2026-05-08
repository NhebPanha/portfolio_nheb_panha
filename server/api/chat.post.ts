import { GoogleGenerativeAI } from '@google/generative-ai'

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const body = await readBody(event)
  const { prompt, history } = body

  // This looks at runtimeConfig.GEMINI_API_KEY defined in nuxt.config.ts
  const apiKey = config.geminiApiKey
  if (!apiKey) {
    throw createError({
      statusCode: 500,
      statusMessage: 'CRITICAL: GEMINI_API_KEY is missing from environment.',
    })
  }

  try {
    const genAI = new GoogleGenerativeAI(apiKey)
    
    // Using gemini-flash-latest for best performance (points to 2.5 flash in 2026)
    const model = genAI.getGenerativeModel({ 
      model: "gemini-flash-latest",
      systemInstruction: "You are a professional, witty data analyst for a developer's portfolio. You have access to three data types: 'skills', 'projects', and 'productivity'. If the user asks about these, explain that you are visualizing them. Keep responses under 50 words."
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
    throw createError({
      statusCode: 500,
      statusMessage: error.message || 'Internal Server Error'
    })
  }
})