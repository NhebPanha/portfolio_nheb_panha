const siteTitle = 'Nheb Panha — Flutter & Full-Stack Developer'
const siteDescription =
  'Portfolio of Nheb Panha, a Flutter and full-stack developer in Phnom Penh, Cambodia, building mobile apps and web platforms with Flutter, Nuxt, Laravel and Supabase.'

export default defineNuxtConfig({
  compatibilityDate: '2024-04-04',
  modules: ['@nuxtjs/tailwindcss', '@nuxt/icon'],
  ssr: false,
  css: ['~/assets/css/main.css'],
  runtimeConfig: {
    // Server-only secrets. Never put these under `public`: everything in `public` ships to the browser.
    geminiApiKey: '',
    supabaseServiceRoleKey: '',
    telegramBotToken: '',
    telegramChatId: '',
    public: {
      supabaseUrl: '',
      supabaseAnonKey: '',
    }
  },
  app: {
    head: {
      htmlAttrs: { lang: 'en' },
      title: siteTitle,
      meta: [
        { name: 'description', content: siteDescription },
        { name: 'theme-color', content: '#030712' },
        { property: 'og:type', content: 'website' },
        { property: 'og:title', content: siteTitle },
        { property: 'og:description', content: siteDescription },
        { property: 'og:image', content: '/image/panha_portrait.jpg' },
        { name: 'twitter:card', content: 'summary_large_image' },
      ],
      link: [
        { rel: 'icon', type: 'image/png', href: '/logo_test.png' },
        { rel: 'preconnect', href: 'https://fonts.googleapis.com' },
        { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' },
        {
          rel: 'stylesheet',
          href: 'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap'
        },
        {
          rel: 'stylesheet',
          href: 'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,400,0..1,0&display=block'
        }
      ],
      script: [
        {
          // Apply the saved/system theme before first paint to avoid a light-mode flash.
          innerHTML:
            "try{var t=localStorage.getItem('theme');if(t==='dark'||(!t&&matchMedia('(prefers-color-scheme: dark)').matches))document.documentElement.classList.add('dark')}catch(e){}",
          tagPosition: 'head'
        }
      ]
    }
  }
})
