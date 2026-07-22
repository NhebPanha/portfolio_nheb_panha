import { createClient } from '@supabase/supabase-js'

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const body = await readBody(event)

  const { name, email, type, message } = body || {}

  if (!name || !email || !message) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Please provide name, email, and message.',
    })
  }

  let supabaseSaved = false
  let telegramSent = false

  // 1. Save to Supabase if configured
  const supabaseUrl = config.public.supabaseUrl as string
  const supabaseKey = (config.supabaseServiceRoleKey || config.public.supabaseAnonKey) as string

  if (supabaseUrl && supabaseKey && supabaseUrl.startsWith('http')) {
    try {
      const supabase = createClient(supabaseUrl, supabaseKey)
      const { error } = await supabase.from('contact_submissions').insert([
        {
          name,
          email,
          message,
          type: type || 'General Contact',
          status: 'unread'
        }
      ])
      if (!error) {
        supabaseSaved = true
      } else {
        console.warn('Supabase DB Insert Warning:', error.message)
      }
    } catch (err: any) {
      console.error('Supabase DB Insert Exception:', err?.message || err)
    }
  }

  // 2. Notify Telegram if token is set
  const telegramBotToken = config.public.telegramBotToken as string
  const telegramChatId = config.public.telegramChatId as string

  if (telegramBotToken && telegramChatId) {
    const text = `
✨ *New Portfolio Contact* ✨

👨‍💻 *Name:* ${name}
📧 *Email:* ${email}
📌 *Type:* ${type || 'General Contact'}
💬 *Message:*
${message}
───────────────
💾 *Supabase Status:* ${supabaseSaved ? 'Saved to DB ✅' : 'Demo / Standby ⚡'}
`.trim()

    const url = `https://api.telegram.org/bot${telegramBotToken}/sendMessage`
    try {
      await $fetch(url, {
        method: 'POST',
        body: JSON.stringify({
          chat_id: telegramChatId,
          text: text,
          parse_mode: 'Markdown',
        })
      })
      telegramSent = true
    } catch (error) {
      console.error('Telegram API Error:', error)
    }
  }

  return {
    success: true,
    supabaseSaved,
    telegramSent,
    message: 'Submission received successfully!'
  }
})
