import { GoogleGenerativeAI } from '@google/generative-ai'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  const config = useRuntimeConfig()
  const { prompt, history, apiKey } = body
  const finalApiKey = apiKey || config.geminiApiKey

  if (!finalApiKey) {
    console.error('Chat API Error: No API key found in request or environment')
    throw createError({
      statusCode: 400,
      statusMessage: 'API Key is missing',
    })
  }

  try {
    const genAI = new GoogleGenerativeAI(finalApiKey)
    // Using gemini-pro for maximum compatibility
    const model = genAI.getGenerativeModel({ 
      model: "gemini-pro",
      systemInstruction: "You are a professional, witty data analyst for a developer's portfolio. You have access to three data types: 'skills', 'projects', and 'productivity'. If the user asks about these, explain that you are visualizing them. Keep responses under 40 words."
    })

    // Gemini requires the history to start with a 'user' role
    const filteredHistory = history.filter((_: any, index: number) => {
      if (index === 0 && history[0].role === 'model') return false
      return true
    })

    console.log(`Processing chat request: "${prompt}"`)
    const chat = model.startChat({ history: filteredHistory })
    const result = await chat.sendMessage(prompt)
    const responseText = result.response.text()

    return { responseText }
  } catch (error: any) {
    console.error('Gemini API Error Detail:', error)
    throw createError({
      statusCode: 500,
      statusMessage: error.message || 'Internal Server Error',
    })
  }
})
