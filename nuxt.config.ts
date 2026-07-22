export default defineNuxtConfig({
  compatibilityDate: '2024-04-04', // Fixes the WARN in your terminal
  modules: ['@nuxtjs/tailwindcss', '@nuxt/icon'],
  ssr: false,
  tailwindcss: {
    config: {
      darkMode: 'class',
    }
  },
  css: ['~/assets/css/main.css'],
  runtimeConfig: {
    geminiApiKey: process.env.NUXT_GEMINI_API_KEY,
    supabaseServiceRoleKey: process.env.SUPABASE_SERVICE_ROLE_KEY || '',
    public: {
      telegramBotToken: process.env.NUXT_TELEGRAM_BOT_TOKEN,
      telegramChatId: process.env.NUXT_TELEGRAM_CHAT_ID,
      supabaseUrl: process.env.NUXT_PUBLIC_SUPABASE_URL || '',
      supabaseAnonKey: process.env.NUXT_PUBLIC_SUPABASE_ANON_KEY || '',
    }
  },
  app: {
    head: {
      link: [
        {
          rel: 'stylesheet',
          href: 'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined'
        },
        {
          rel: 'icon',
          type: 'image/png',
          href: '/logo_test.png'
        }
      ]
    }
  }
})