import { createClient, type SupabaseClient } from '@supabase/supabase-js'

export interface ProjectItem {
  id?: string
  title: string
  category: string
  description: string
  icon: string
  link: string
  github_url?: string
  featured?: boolean
  tags: { name: string; icon: string }[]
}

const FALLBACK_PROJECTS: ProjectItem[] = [
  {
    title: "FinTech Wallet & Payment Suite",
    category: "Financial Ecosystem",
    description: "High-performance cross-platform digital wallet solution featuring real-time transactions, biometric authentication, QR payment engine, and multi-currency ledger.",
    icon: "logos:flutter",
    link: "https://github.com/nhebpanha",
    github_url: "https://github.com/nhebpanha",
    featured: true,
    tags: [
      { name: "Flutter", icon: "logos:flutter" },
      { name: "Laravel", icon: "logos:laravel" },
      { name: "PostgreSQL", icon: "logos:postgresql" }
    ]
  },
  {
    title: "Nexus Logistics & Fleet Engine",
    category: "Delivery System",
    description: "Enterprise real-time logistics platform with active GPS telemetry tracking, route optimization algorithms, driver dispatching, and dynamic delivery status.",
    icon: "logos:nuxt-icon",
    link: "https://github.com/nhebpanha",
    github_url: "https://github.com/nhebpanha",
    featured: true,
    tags: [
      { name: "Nuxt 3", icon: "logos:nuxt-icon" },
      { name: "Supabase", icon: "logos:supabase-icon" },
      { name: "Google Maps", icon: "logos:google-maps" }
    ]
  },
  {
    title: "Aura E-Commerce Platform",
    category: "Retail Platform",
    description: "Modern headless retail experience with instant fuzzy filtering, Stripe checkout integration, real-time inventory management, and automated invoice printing.",
    icon: "logos:vue",
    link: "https://github.com/nhebpanha",
    github_url: "https://github.com/nhebpanha",
    featured: true,
    tags: [
      { name: "Vue 3", icon: "logos:vue" },
      { name: "Firebase", icon: "logos:firebase" },
      { name: "Stripe", icon: "logos:stripe" }
    ]
  },
  {
    title: "Precision Accounting Suite",
    category: "Business Tool",
    description: "Automated accounting software for SMEs focused on tax compliance, financial analytics reporting, automated bank feeds, and receipt scanning.",
    icon: "logos:laravel",
    link: "https://github.com/nhebpanha",
    github_url: "https://github.com/nhebpanha",
    featured: false,
    tags: [
      { name: "Laravel", icon: "logos:laravel" },
      { name: "TypeScript", icon: "logos:typescript-icon" },
      { name: "Tailwind", icon: "logos:tailwindcss-icon" }
    ]
  },
  {
    title: "Smart HR & Payroll Engine",
    category: "Enterprise Tool",
    description: "Comprehensive human resource management system featuring automated monthly payroll, attendance check-ins, leave workflow approvals, and KPI dashboards.",
    icon: "logos:nuxt-icon",
    link: "https://github.com/nhebpanha",
    github_url: "https://github.com/nhebpanha",
    featured: false,
    tags: [
      { name: "Nuxt 3", icon: "logos:nuxt-icon" },
      { name: "Laravel", icon: "logos:laravel" },
      { name: "MySQL", icon: "logos:mysql-icon" }
    ]
  },
  {
    title: "AgriTech Monitor IoT",
    category: "IoT Platform",
    description: "Real-time precision agriculture dashboard connecting soil moisture sensors, weather telemetry, automated irrigation triggers, and crop yield forecasting.",
    icon: "logos:flutter",
    link: "https://github.com/nhebpanha",
    github_url: "https://github.com/nhebpanha",
    featured: false,
    tags: [
      { name: "Flutter", icon: "logos:flutter" },
      { name: "Node.js", icon: "logos:nodejs-icon" },
      { name: "Supabase", icon: "logos:supabase-icon" }
    ]
  }
]

let cachedClient: SupabaseClient | null = null

export const useSupabase = () => {
  const config = useRuntimeConfig()
  const url = config.public.supabaseUrl as string
  const key = config.public.supabaseAnonKey as string

  const isConfigured = Boolean(url && key && url.startsWith('http'))

  const getClient = (): SupabaseClient | null => {
    if (!isConfigured) return null
    if (!cachedClient) {
      cachedClient = createClient(url, key)
    }
    return cachedClient
  }

  const fetchProjects = async (): Promise<{ projects: ProjectItem[]; source: 'supabase' | 'fallback' }> => {
    const client = getClient()
    if (!client) {
      return { projects: FALLBACK_PROJECTS, source: 'fallback' }
    }

    try {
      const { data, error } = await client
        .from('projects')
        .select('*')
        .order('created_at', { ascending: false })

      if (error || !data || data.length === 0) {
        console.warn('Supabase projects query returned fallback data:', error?.message || 'Empty table')
        return { projects: FALLBACK_PROJECTS, source: 'fallback' }
      }

      const formattedProjects: ProjectItem[] = data.map((item: any) => ({
        id: item.id,
        title: item.title,
        category: item.category,
        description: item.description,
        icon: item.icon || 'logos:flutter',
        link: item.link || '#',
        github_url: item.github_url || '#',
        featured: item.featured ?? true,
        tags: Array.isArray(item.tags) ? item.tags : (typeof item.tags === 'string' ? JSON.parse(item.tags) : [])
      }))

      return { projects: formattedProjects, source: 'supabase' }
    } catch (err) {
      console.error('Failed to fetch from Supabase:', err)
      return { projects: FALLBACK_PROJECTS, source: 'fallback' }
    }
  }

  const submitContact = async (payload: { name: string; email: string; message: string; type?: string }) => {
    const client = getClient()
    if (!client) {
      return { success: true, savedToSupabase: false }
    }

    try {
      const { error } = await client.from('contact_submissions').insert([
        {
          name: payload.name,
          email: payload.email,
          message: payload.message,
          type: payload.type || 'General Contact'
        }
      ])

      if (error) {
        console.error('Supabase contact submission error:', error)
        return { success: false, error: error.message, savedToSupabase: false }
      }

      return { success: true, savedToSupabase: true }
    } catch (err: any) {
      console.error('Supabase error:', err)
      return { success: false, error: err.message, savedToSupabase: false }
    }
  }

  return {
    isConfigured,
    getClient,
    fetchProjects,
    submitContact,
    fallbackProjects: FALLBACK_PROJECTS
  }
}
