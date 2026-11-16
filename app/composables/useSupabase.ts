import { createClient, type SupabaseClient } from '@supabase/supabase-js'

export interface ProjectItem {
  id?: string
  title: string
  category: string
  description: string
  icon: string
  link: string
  github_url?: string
  demo_url?: string
  app_store_url?: string
  status?: 'Released' | 'Production' | 'Featured' | 'Beta'
  metrics?: string
  featured?: boolean
  tags: { name: string; icon: string }[]
}

export interface BlogPost {
  id?: string
  title: string
  slug: string
  category: string
  summary: string
  content: string
  read_time: string
  published_at: string
  author: string
  tags: string[]
  icon: string
}

export interface ContactSubmission {
  id?: string
  name: string
  email: string
  message: string
  type: string
  status?: string
  created_at?: string
}

export interface TimelineItem {
  id?: string
  period: string
  role: string
  company: string
  location: string
  type: string
  category: string
  icon: string
  metric: string
  summary: string
  highlights: string[]
  techStack: string[]
}

export interface TechItem {
  id?: string
  name: string
  category: string
  categoryName: string
  icon: string
  level: number
  status: string
  description: string
  tags: string[]
}

// TODO: add store / demo / GitHub links (demo_url, github_url) when available.
const FALLBACK_PROJECTS: ProjectItem[] = [
  {
    id: "p1",
    title: "RED ANT Express",
    category: "E-Commerce",
    description: "Customer shopping app for the RED ANT Express e-commerce platform: browse products, add them to the cart, check out and track orders through to delivery.",
    icon: "devicon:flutter",
    link: "#",
    featured: true,
    tags: [
      { name: "Flutter", icon: "devicon:flutter" },
      { name: "Dart", icon: "logos:dart" }
    ]
  },
  {
    id: "p2",
    title: "RED ANT Merchant",
    category: "Merchant App",
    description: "Seller app for RED ANT Express that lets merchants manage their products and incoming orders, and prepare each order for delivery.",
    icon: "devicon:flutter",
    link: "#",
    featured: true,
    tags: [
      { name: "Flutter", icon: "devicon:flutter" },
      { name: "Dart", icon: "logos:dart" }
    ]
  },
  {
    id: "p3",
    title: "RED ANT Driver",
    category: "Delivery App",
    description: "Driver app for RED ANT Express for accepting delivery jobs, picking up orders from merchants and updating each order through to drop-off.",
    icon: "devicon:flutter",
    link: "#",
    featured: true,
    tags: [
      { name: "Flutter", icon: "devicon:flutter" },
      { name: "Dart", icon: "logos:dart" }
    ]
  },
  {
    id: "p4",
    title: "E-Shop Native",
    category: "E-Commerce",
    description: "Native mobile shopping app for Android and iOS covering product browsing, cart and checkout.",
    icon: "logos:kotlin-icon",
    link: "#",
    featured: true,
    tags: [
      { name: "Kotlin", icon: "logos:kotlin-icon" },
      { name: "Swift", icon: "logos:swift" }
    ]
  }
]

const FALLBACK_BLOG_POSTS: BlogPost[] = [
  {
    id: "b1",
    title: "Building Real-Time Mobile Apps with Flutter & Supabase",
    slug: "flutter-supabase-realtime",
    category: "Mobile Architecture",
    summary: "A practical guide to implementing BLoC state isolation, Supabase Row-Level Security (RLS), and offline-first Hive caching in Flutter production apps.",
    content: `Building real-time mobile applications requires a decoupled architecture that balances UI responsiveness, local data caching, and secure cloud synchronization.

### 1. State Management with BLoC Pattern
Using the Business Logic Component (BLoC) pattern separates presentation logic from data streaming. This ensures predictable state transitions when receiving real-time WebSocket events from Supabase.

### 2. Row Level Security (RLS) Policies
Supabase PostgreSQL database policies allow row-level authorization directly at the database layer. By enforcing RLS, client mobile apps interact securely with data without complex intermediary API proxies.

### 3. Offline-First Hive & Isar Caching
To maintain sub-100ms UI interactions, local key-value stores like Hive cache remote payloads locally. When network connectivity drops, operations queue locally and sync atomically once reconnected.`,
    read_time: "5 min read",
    published_at: "Jul 2025",
    author: "Nheb Panha",
    tags: ["Flutter", "Supabase", "BLoC", "PostgreSQL"],
    icon: "devicon:flutter"
  },
  {
    id: "b2",
    title: "Optimizing Nuxt 3 SSR & Glassmorphism Design Tokens",
    slug: "nuxt3-ssr-glassmorphism",
    category: "Frontend Engineering",
    summary: "How to craft ultra-fast Vue 3 applications using Nuxt 3 server-side rendering, dynamic dark mode themes, and performance-first CSS glass utilities.",
    content: `Modern web interfaces must deliver immediate visual impact without sacrificing Lighthouse web vitals or page transition speeds.

### 1. Server-Side Rendering (SSR) Optimization
Nuxt 3 leverages Vite and Nitro server engines to render HTML payloads on the server. By utilizing \`useAsyncData\` with key caching, payload payloads double in initial load speed.

### 2. Custom CSS Glass Tokens
Instead of relying on heavy third-party UI libraries, custom backdrop-filter CSS utility classes maintain high frame rates (60fps) during window scrolling and dark mode transitions.`,
    read_time: "4 min read",
    published_at: "Jun 2025",
    author: "Nheb Panha",
    tags: ["Nuxt 3", "Vue 3", "Tailwind CSS", "SSR"],
    icon: "logos:nuxt-icon"
  },
  {
    id: "b3",
    title: "Architecting High-Throughput REST APIs in Laravel & Node.js",
    slug: "laravel-nodejs-api-throughput",
    category: "Backend Systems",
    summary: "Database indexing strategies, background worker queues, and automated Telegram bot telemetry triggers for mission-critical API backends.",
    content: `When handling high daily transaction volume, API backend performance hinges on SQL indexing precision and asynchronous background queues.

### 1. Database Indexing & Query Optimization
Creating compound indexes on frequent query filter columns reduces database search time by up to 40%. Avoiding N+1 queries using Eloquent eager loading ensures tight memory bounds.

### 2. Operational Error Telemetry with Telegram
By integrating automated webhook triggers into exception handlers, engineering teams receive immediate real-time stack trace alerts in Telegram channels for instantaneous triage.`,
    read_time: "6 min read",
    published_at: "May 2025",
    author: "Nheb Panha",
    tags: ["Laravel", "Node.js", "MySQL", "Telegram API"],
    icon: "logos:laravel"
  }
]

const FALLBACK_CONTACT_SUBMISSIONS: ContactSubmission[] = [
  {
    id: 'demo-1',
    name: 'Sarah Connor',
    email: 'sarah@cyberdyne.io',
    type: 'Mobile App Development',
    message: 'We are looking for a Senior Flutter Architect to lead our mobile payment application build in Q3.',
    status: 'unread',
    created_at: new Date(Date.now() - 3600000 * 4).toISOString()
  },
  {
    id: 'demo-2',
    name: 'Alex Mercer',
    email: 'alex@apex-tech.com',
    type: 'Full-Stack Web Development',
    message: 'Need a Nuxt 3 server-side rendered admin dashboard with glassmorphism UI tokens.',
    status: 'read',
    created_at: new Date(Date.now() - 3600000 * 24).toISOString()
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
        return { projects: FALLBACK_PROJECTS, source: 'fallback' }
      }

      const formattedProjects: ProjectItem[] = data.map((item: any) => ({
        id: item.id,
        title: item.title,
        category: item.category,
        description: item.description,
        icon: item.icon || 'devicon:flutter',
        link: item.link || '#',
        github_url: item.github_url || undefined,
        demo_url: item.demo_url || undefined,
        status: item.status || undefined,
        metrics: item.metrics || undefined,
        featured: item.featured ?? true,
        tags: Array.isArray(item.tags) ? item.tags : (typeof item.tags === 'string' ? JSON.parse(item.tags) : [])
      }))

      return { projects: formattedProjects, source: 'supabase' }
    } catch (err) {
      return { projects: FALLBACK_PROJECTS, source: 'fallback' }
    }
  }

  const fetchBlogPosts = async (): Promise<{ posts: BlogPost[]; source: 'supabase' | 'fallback' }> => {
    const client = getClient()
    if (!client) {
      return { posts: FALLBACK_BLOG_POSTS, source: 'fallback' }
    }

    try {
      const { data, error } = await client
        .from('blog_posts')
        .select('*')
        .order('published_at', { ascending: false })

      if (error || !data || data.length === 0) {
        return { posts: FALLBACK_BLOG_POSTS, source: 'fallback' }
      }

      const formattedPosts: BlogPost[] = data.map((item: any) => ({
        id: item.id,
        title: item.title,
        slug: item.slug,
        category: item.category,
        summary: item.summary,
        content: item.content,
        read_time: item.read_time || '5 min read',
        published_at: item.published_at || 'Jul 2025',
        author: item.author || 'Nheb Panha',
        tags: Array.isArray(item.tags) ? item.tags : (typeof item.tags === 'string' ? JSON.parse(item.tags) : []),
        icon: item.icon || 'devicon:flutter'
      }))

      return { posts: formattedPosts, source: 'supabase' }
    } catch (err) {
      return { posts: FALLBACK_BLOG_POSTS, source: 'fallback' }
    }
  }

  const fetchContactSubmissions = async (): Promise<{ submissions: ContactSubmission[]; source: 'supabase' | 'fallback' }> => {
    const client = getClient()
    if (!client) {
      return { submissions: FALLBACK_CONTACT_SUBMISSIONS, source: 'fallback' }
    }

    try {
      const { data, error } = await client
        .from('contact_submissions')
        .select('*')
        .order('created_at', { ascending: false })

      if (error || !data || data.length === 0) {
        return { submissions: FALLBACK_CONTACT_SUBMISSIONS, source: 'fallback' }
      }

      return { submissions: data as ContactSubmission[], source: 'supabase' }
    } catch (err) {
      return { submissions: FALLBACK_CONTACT_SUBMISSIONS, source: 'fallback' }
    }
  }

  const deleteContactSubmission = async (id: string) => {
    const client = getClient()
    if (!client) return { success: true }
    try {
      const { error } = await client.from('contact_submissions').delete().eq('id', id)
      return { success: !error, error: error?.message }
    } catch (err: any) {
      return { success: false, error: err.message }
    }
  }

  const updateContactStatus = async (id: string, status: string) => {
    const client = getClient()
    if (!client) return { success: true }
    try {
      const { error } = await client.from('contact_submissions').update({ status }).eq('id', id)
      return { success: !error, error: error?.message }
    } catch (err: any) {
      return { success: false, error: err.message }
    }
  }

  const saveProject = async (project: ProjectItem) => {
    const client = getClient()
    if (!client) return { success: true }
    try {
      if (project.id) {
        const { error } = await client.from('projects').update(project).eq('id', project.id)
        return { success: !error, error: error?.message }
      } else {
        const { error } = await client.from('projects').insert([project])
        return { success: !error, error: error?.message }
      }
    } catch (err: any) {
      return { success: false, error: err.message }
    }
  }

  const deleteProject = async (id: string) => {
    const client = getClient()
    if (!client) return { success: true }
    try {
      const { error } = await client.from('projects').delete().eq('id', id)
      return { success: !error, error: error?.message }
    } catch (err: any) {
      return { success: false, error: err.message }
    }
  }

  const saveBlogPost = async (post: BlogPost) => {
    const client = getClient()
    if (!client) return { success: true }
    try {
      if (post.id) {
        const { error } = await client.from('blog_posts').update(post).eq('id', post.id)
        return { success: !error, error: error?.message }
      } else {
        const { error } = await client.from('blog_posts').insert([post])
        return { success: !error, error: error?.message }
      }
    } catch (err: any) {
      return { success: false, error: err.message }
    }
  }

  const deleteBlogPost = async (id: string) => {
    const client = getClient()
    if (!client) return { success: true }
    try {
      const { error } = await client.from('blog_posts').delete().eq('id', id)
      return { success: !error, error: error?.message }
    } catch (err: any) {
      return { success: false, error: err.message }
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
          type: payload.type || 'General Inquiry'
        }
      ])

      if (error) {
        return { success: false, error: error.message, savedToSupabase: false }
      }

      return { success: true, savedToSupabase: true }
    } catch (err: any) {
      return { success: false, error: err.message, savedToSupabase: false }
    }
  }

  return {
    isConfigured,
    getClient,
    fetchProjects,
    fetchBlogPosts,
    fetchContactSubmissions,
    deleteContactSubmission,
    updateContactStatus,
    saveProject,
    deleteProject,
    saveBlogPost,
    deleteBlogPost,
    submitContact,
    fallbackProjects: FALLBACK_PROJECTS,
    fallbackBlogPosts: FALLBACK_BLOG_POSTS,
    fallbackContactSubmissions: FALLBACK_CONTACT_SUBMISSIONS
  }
}
