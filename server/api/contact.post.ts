import { createClient } from '@supabase/supabase-js'

const LIMITS = { name: 120, email: 200, type: 80, message: 5000 }
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

const escapeHtml = (value: string) =>
  value.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')

const clean = (value: unknown, max: number) =>
  typeof value === 'string' ? value.trim().slice(0, max) : ''

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig(event)
  const body = await readBody(event)

  const name = clean(body?.name, LIMITS.name)
  const email = clean(body?.email, LIMITS.email)
  const type = clean(body?.type, LIMITS.type) || 'General Inquiry'
  const message = clean(body?.message, LIMITS.message)

  if (!name || !email || !message) {
    throw createError({ statusCode: 400, statusMessage: 'Please provide name, email, and message.' })
  }
  if (!EMAIL_RE.test(email)) {
    throw createError({ statusCode: 400, statusMessage: 'Please provide a valid email address.' })
  }

  let supabaseSaved = false
  let telegramSent = false

  // 1. Save to Supabase if configured
  const supabaseUrl = config.public.supabaseUrl as string
  const supabaseKey = (config.supabaseServiceRoleKey || config.public.supabaseAnonKey) as string

  if (supabaseUrl && supabaseKey && supabaseUrl.startsWith('http')) {
    try {
      const supabase = createClient(supabaseUrl, supabaseKey)
      const { error } = await supabase
        .from('contact_submissions')
        .insert([{ name, email, message, type, status: 'unread' }])
      if (error) console.warn('Supabase insert warning:', error.message)
      else supabaseSaved = true
    } catch (err: any) {
      console.error('Supabase insert exception:', err?.message || err)
    }
  }

  // 2. Notify Telegram if configured (server-only credentials)
  const telegramBotToken = config.telegramBotToken as string
  const telegramChatId = config.telegramChatId as string

  if (telegramBotToken && telegramChatId) {
    const text = [
      '✨ <b>New Portfolio Contact</b>',
      '',
      `👤 <b>Name:</b> ${escapeHtml(name)}`,
      `📧 <b>Email:</b> ${escapeHtml(email)}`,
      `📌 <b>Type:</b> ${escapeHtml(type)}`,
      '💬 <b>Message:</b>',
      escapeHtml(message),
      '',
      `💾 Supabase: ${supabaseSaved ? 'saved ✅' : 'not saved'}`
    ].join('\n')

    try {
      await $fetch(`https://api.telegram.org/bot${telegramBotToken}/sendMessage`, {
        method: 'POST',
        body: { chat_id: telegramChatId, text, parse_mode: 'HTML' }
      })
      telegramSent = true
    } catch (error: any) {
      console.error('Telegram API error:', error?.data?.description || error?.message || error)
    }
  }

  if (!supabaseSaved && !telegramSent) {
    throw createError({
      statusCode: 503,
      statusMessage: 'Message could not be delivered right now. Please email me directly.'
    })
  }

  return { success: true, supabaseSaved, telegramSent }
})
