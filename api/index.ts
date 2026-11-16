/**
 * Portfolio API worker.
 *
 * Serves only `/api/chat` and `/api/contact`; everything else is the Flutter Web build,
 * served as static assets (see wrangler.jsonc). Secrets live here, never in the Flutter app.
 *
 * No dependencies: Gemini, Telegram and Supabase are called through their HTTP APIs.
 */

interface Env {
  ASSETS: { fetch(request: Request): Promise<Response> }
  // New names (preferred) and the older NUXT_* names, so existing Cloudflare secrets keep working.
  GEMINI_API_KEY?: string
  NUXT_GEMINI_API_KEY?: string
  TELEGRAM_BOT_TOKEN?: string
  NUXT_TELEGRAM_BOT_TOKEN?: string
  TELEGRAM_CHAT_ID?: string
  NUXT_TELEGRAM_CHAT_ID?: string
  SUPABASE_URL?: string
  NUXT_PUBLIC_SUPABASE_URL?: string
  SUPABASE_SERVICE_ROLE_KEY?: string
  NUXT_SUPABASE_SERVICE_ROLE_KEY?: string
  SUPABASE_ANON_KEY?: string
  NUXT_PUBLIC_SUPABASE_ANON_KEY?: string
}

interface Ctx {
  waitUntil(promise: Promise<unknown>): void
}

export default {
  async fetch(request: Request, env: Env, ctx: Ctx): Promise<Response> {
    const { pathname } = new URL(request.url)

    if (pathname === '/api/chat' || pathname === '/api/contact') {
      if (request.method !== 'POST') return error(405, 'Method not allowed.')
      let body: any
      try {
        body = await request.json()
      } catch {
        return error(400, 'Invalid JSON body.')
      }
      return pathname === '/api/chat' ? chat(body, env, ctx) : contact(body, env)
    }

    if (pathname.startsWith('/api/')) return error(404, 'Not found.')
    return env.ASSETS.fetch(request)
  },
}

// ─────────────────────────────── helpers ───────────────────────────────

const json = (data: unknown, status = 200) =>
  new Response(JSON.stringify(data), { status, headers: { 'content-type': 'application/json; charset=utf-8' } })

// Same shape Nuxt used ({ statusCode, statusMessage }); the Flutter app reads `statusMessage`.
const error = (statusCode: number, statusMessage: string) => json({ error: true, statusCode, statusMessage }, statusCode)

const pick = (...values: (string | undefined)[]) => values.find((v) => v && v.trim())?.trim() ?? ''

const supabaseConfig = (env: Env) => {
  const url = pick(env.SUPABASE_URL, env.NUXT_PUBLIC_SUPABASE_URL)
  const key = pick(
    env.SUPABASE_SERVICE_ROLE_KEY,
    env.NUXT_SUPABASE_SERVICE_ROLE_KEY,
    env.SUPABASE_ANON_KEY,
    env.NUXT_PUBLIC_SUPABASE_ANON_KEY,
  )
  return url.startsWith('http') && key ? { url: url.replace(/\/$/, ''), key } : null
}

async function supabaseInsert(env: Env, table: string, row: Record<string, unknown>): Promise<boolean> {
  const cfg = supabaseConfig(env)
  if (!cfg) return false
  try {
    const res = await fetch(`${cfg.url}/rest/v1/${table}`, {
      method: 'POST',
      headers: {
        apikey: cfg.key,
        authorization: `Bearer ${cfg.key}`,
        'content-type': 'application/json',
        prefer: 'return=minimal',
      },
      body: JSON.stringify(row),
    })
    if (!res.ok) console.warn(`Supabase insert into ${table} failed:`, res.status, await res.text())
    return res.ok
  } catch (err) {
    console.error(`Supabase insert into ${table} threw:`, err)
    return false
  }
}

// ─────────────────────────────── /api/contact ───────────────────────────────

const LIMITS = { name: 120, email: 200, type: 80, message: 5000 }
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

const clean = (value: unknown, max: number) => (typeof value === 'string' ? value.trim().slice(0, max) : '')
const escapeHtml = (value: string) => value.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')

async function contact(body: any, env: Env): Promise<Response> {
  const name = clean(body?.name, LIMITS.name)
  const email = clean(body?.email, LIMITS.email)
  const type = clean(body?.type, LIMITS.type) || 'General Inquiry'
  const message = clean(body?.message, LIMITS.message)

  if (!name || !email || !message) return error(400, 'Please provide name, email, and message.')
  if (!EMAIL_RE.test(email)) return error(400, 'Please provide a valid email address.')

  const supabaseSaved = await supabaseInsert(env, 'contact_submissions', { name, email, message, type, status: 'unread' })

  let telegramSent = false
  const token = pick(env.TELEGRAM_BOT_TOKEN, env.NUXT_TELEGRAM_BOT_TOKEN)
  const chatId = pick(env.TELEGRAM_CHAT_ID, env.NUXT_TELEGRAM_CHAT_ID)
  if (token && chatId) {
    const text = [
      '✨ <b>New Portfolio Contact</b>',
      '',
      `👤 <b>Name:</b> ${escapeHtml(name)}`,
      `📧 <b>Email:</b> ${escapeHtml(email)}`,
      `📌 <b>Type:</b> ${escapeHtml(type)}`,
      '💬 <b>Message:</b>',
      escapeHtml(message),
      '',
      `💾 Supabase: ${supabaseSaved ? 'saved ✅' : 'not saved'}`,
    ].join('\n')
    try {
      const res = await fetch(`https://api.telegram.org/bot${token}/sendMessage`, {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ chat_id: chatId, text, parse_mode: 'HTML' }),
      })
      telegramSent = res.ok
      if (!res.ok) console.error('Telegram API error:', res.status, await res.text())
    } catch (err) {
      console.error('Telegram API threw:', err)
    }
  }

  if (!supabaseSaved && !telegramSent) {
    return error(503, 'Message could not be delivered right now. Please email me directly.')
  }
  return json({ success: true, supabaseSaved, telegramSent })
}

// ─────────────────────────────── /api/chat ───────────────────────────────

const SYSTEM_INSTRUCTION = `
You are the official AI Portfolio Assistant for Nheb Panha.
Panha is a professional Full-Stack Developer & Mobile App Architect based in Phnom Penh, Cambodia (UTC+7).

Key Profile Information about Nheb Panha:
- Specialties: Flutter & Dart cross-platform mobile apps, Nuxt 3 (Vue 3) web apps, Supabase databases, Laravel REST APIs, Tailwind CSS.
- Background: Accounting-Developer background giving him financial precision, clean data modeling capabilities, and strong UI/UX design skills.
- Key Projects:
  1. RED ANT Express — e-commerce shopping app for customers (Flutter)
  2. RED ANT Merchant — seller app for managing products and orders on RED ANT Express (Flutter)
  3. RED ANT Driver — delivery driver app for RED ANT Express orders (Flutter)
  4. E-Shop Native — native Android/iOS shopping app (Kotlin, Swift)
- This portfolio itself is built with Flutter Web.
- Contact Info: Email: nhebpanha78@gmail.com, Location: Phnom Penh, Cambodia.
- Availability: Available for Freelance Projects and Full-time Software Engineering roles.

Instructions:
Be helpful, polite, professional, concise (under 75 words), and enthusiastic. Highlight Panha's expertise in Flutter, Supabase, Nuxt and Laravel.
`.trim()

// Current model first; the alias is a fallback.
const MODELS = ['gemini-2.5-flash', 'gemini-flash-latest']

async function chat(body: any, env: Env, ctx: Ctx): Promise<Response> {
  const raw = body?.prompt
  if (typeof raw !== 'string' || !raw.trim()) {
    return json({ responseText: "Hello! How can I help you explore Nheb Panha's portfolio today?" })
  }
  // Keep requests small so a single visitor can't run up the Gemini bill.
  const prompt = raw.trim().slice(0, 1000)

  let answer = ''
  const apiKey = pick(env.GEMINI_API_KEY, env.NUXT_GEMINI_API_KEY)
  if (apiKey) {
    const history = (Array.isArray(body?.history) ? body.history.slice(-12) : [])
      .filter((m: any) => (m?.role === 'user' || m?.role === 'model') && typeof m?.parts?.[0]?.text === 'string')
      .map((m: any) => ({ role: m.role, parts: [{ text: String(m.parts[0].text).slice(0, 1000) }] }))
    // Gemini requires the conversation to start with a user turn.
    while (history.length && history[0].role !== 'user') history.shift()

    for (const model of MODELS) {
      try {
        const res = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent`, {
          method: 'POST',
          headers: { 'content-type': 'application/json', 'x-goog-api-key': apiKey },
          body: JSON.stringify({
            systemInstruction: { parts: [{ text: SYSTEM_INSTRUCTION }] },
            contents: [...history, { role: 'user', parts: [{ text: prompt }] }],
            generationConfig: { maxOutputTokens: 400, temperature: 0.7, thinkingConfig: { thinkingBudget: 0 } },
          }),
        })
        if (!res.ok) {
          console.warn(`Gemini ${model} failed:`, res.status, (await res.text()).slice(0, 300))
          continue
        }
        const data: any = await res.json()
        answer = (data?.candidates?.[0]?.content?.parts ?? [])
          .map((p: any) => (typeof p?.text === 'string' ? p.text : ''))
          .join('')
          .trim()
        if (answer) break
      } catch (err) {
        console.warn(`Gemini ${model} threw:`, err)
      }
    }
  }

  if (!answer) answer = fallbackAnswer(prompt.toLowerCase())

  // Store the exchange without delaying the response.
  ctx.waitUntil(supabaseInsert(env, 'chat_logs', { user_prompt: prompt, bot_response: answer }))

  return json({ responseText: answer })
}

/** Canned answers used when Gemini isn't configured or fails. */
function fallbackAnswer(q: string): string {
  const has = (...words: string[]) => words.some((w) => q.includes(w))
  if (has('availab', 'hire', 'freelance'))
    return 'Yes! Panha is currently open to freelance projects and full-time roles. The quickest way to reach him is the contact form on this page or email at nhebpanha78@gmail.com.'
  if (has('experience', 'career'))
    return 'Panha has been building software since 2022, moving from junior mobile and web work to backend and database development, then full-stack Nuxt engineering and senior Flutter and Supabase work. See the Experience section for details.'
  if (has('supabase'))
    return 'Panha uses Supabase for PostgreSQL databases, authentication, edge functions and Row Level Security. On this portfolio it stores messages sent through the contact form.'
  if (has('skill', 'stack', 'tech'))
    return "Panha's core stack includes Flutter & Dart for cross-platform mobile apps, Nuxt & Vue for web apps, Supabase & PostgreSQL for databases, and Laravel for backend APIs."
  if (has('project', 'work', 'portfolio'))
    return "Panha's projects include the RED ANT Express e-commerce platform (a customer shopping app, a Merchant app for sellers and a Driver app for deliveries, all built with Flutter) and E-Shop Native, a native Android/iOS shopping app built with Kotlin and Swift."
  if (has('about', 'who is', 'who are'))
    return 'Nheb Panha is a full-stack developer and mobile app specialist based in Phnom Penh, Cambodia. He combines accounting-level data precision with modern UI/UX design and clean software architecture.'
  if (has('contact', 'email'))
    return 'You can contact Nheb Panha by email at nhebpanha78@gmail.com or through the Contact section on this page. He is open to freelance and full-time opportunities.'
  if (has('hello', 'hi', 'hey'))
    return "Hello! I'm Panha's AI portfolio assistant. Ask me about his Flutter apps, projects, skills, or how to contact him!"
  return "I'm Panha's AI assistant! I can answer questions about his Flutter apps, projects, skills and career experience. What would you like to know?"
}
