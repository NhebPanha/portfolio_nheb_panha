import 'package:flutter/material.dart';

/// All portfolio content lives here, so updating the site means editing this file only.

const ownerName = 'Nheb Panha';
const ownerRole = 'Flutter & Full-Stack Developer';
const email = 'nhebpanha78@gmail.com';
const githubUrl = 'https://github.com/panhanheb';
const telegramUrl = 'https://t.me/nhebpanha';
const telegramHandle = '@nhebpanha';
const location = 'Phnom Penh, Cambodia';

const heroIntro =
    'I build cross-platform mobile apps and web platforms end to end, from the database '
    'and APIs to a polished interface. I work mainly with Flutter, Nuxt, Laravel and Supabase, '
    'and I bring an accounting background to products where data accuracy matters.';

const heroFacts = [
  (label: 'Focus', value: 'Mobile & Web'),
  (label: 'Building since', value: '2022'),
  (label: 'Core stack', value: 'Flutter · Nuxt'),
];

const aboutParagraphs = [
  "I'm a full-stack developer based in Phnom Penh who specialises in cross-platform mobile "
      'apps with Flutter and modern web applications with Nuxt and Vue.',
  'Before software, I trained in accounting. That shapes how I work: careful data modelling, '
      'predictable state, and interfaces that make complex information easy to read.',
  'I care about clean architecture, strict typing and shipping things that hold up in '
      'production, and I enjoy owning a feature from database schema to final pixel.',
];

const coreStack = ['Flutter', 'Dart', 'Nuxt', 'Vue', 'Laravel', 'Supabase', 'PostgreSQL', 'TypeScript'];

class Service {
  const Service(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;
}

const services = [
  Service(Icons.smartphone_outlined, 'Mobile apps',
      'Cross-platform Flutter apps for iOS and Android with clean state management (BLoC, Riverpod) and offline support.'),
  Service(Icons.web_outlined, 'Web applications',
      'Fast, responsive Nuxt and Vue apps with TypeScript, accessible UI and a maintainable component structure.'),
  Service(Icons.dns_outlined, 'Backends & APIs',
      'REST APIs in Laravel and Node.js, authentication, background jobs and integrations such as payments and Telegram.'),
  Service(Icons.storage_outlined, 'Data & databases',
      'PostgreSQL and MySQL schema design, Supabase with row-level security, and reporting for finance-style data.'),
];

class Job {
  const Job({
    required this.period,
    required this.role,
    required this.company,
    required this.location,
    required this.type,
    required this.summary,
    required this.highlights,
    required this.tech,
  });
  final String period, role, company, location, type, summary;
  final List<String> highlights, tech;
}

// TODO: replace the company names and figures below with your real roles.
const jobs = [
  Job(
    period: '2025 — Present',
    role: 'Senior Flutter & Supabase Developer',
    company: 'Cross-Platform Mobile Ecosystems',
    location: 'Phnom Penh / Remote',
    type: 'Full-time',
    summary:
        'Building high-performance Flutter mobile applications with real-time Supabase PostgreSQL synchronisation, biometric security, BLoC state isolation and offline caching.',
    highlights: [
      'Engineered a FinTech mobile wallet handling real-time WebSocket transaction feeds.',
      'Designed row-level security (RLS) policies for Supabase PostgreSQL schemas.',
      'Optimised local Hive/Isar caching, reducing initial launch time by 38%.',
    ],
    tech: ['Flutter', 'Dart', 'Supabase', 'PostgreSQL', 'Firebase', 'BLoC'],
  ),
  Job(
    period: '2024 — 2025',
    role: 'Full-Stack Nuxt & Vue Engineer',
    company: 'Enterprise SaaS Solutions',
    location: 'Phnom Penh',
    type: 'Full-time',
    summary:
        'Developed modular server-rendered web applications in Nuxt 3 and Vue 3, with a custom design system and payment gateway integrations.',
    highlights: [
      'Built responsive web portals serving over 50,000 monthly sessions with sub-second page loads.',
      'Integrated Pinia state management with persisted storage for reliable session retention.',
      'Created reusable design tokens and a dark/light theme system.',
    ],
    tech: ['Nuxt 3', 'Vue 3', 'TypeScript', 'Tailwind CSS', 'Pinia', 'REST API'],
  ),
  Job(
    period: '2023 — 2024',
    role: 'Backend & Database Developer',
    company: 'Cloud Infrastructure & API Services',
    location: 'Phnom Penh',
    type: 'Full-time',
    summary:
        'Built REST APIs in Laravel and Node.js with database indexing, background queue jobs and automated Telegram alerting.',
    highlights: [
      'Built financial accounting API endpoints processing daily transactions within atomic database transactions.',
      'Optimised SQL queries and compound indexes, cutting database response latency by 40%.',
      'Integrated Telegram bot alerts for immediate production error reporting.',
    ],
    tech: ['Laravel', 'Node.js', 'MySQL', 'PostgreSQL', 'Redis', 'Telegram API'],
  ),
  Job(
    period: '2022 — 2023',
    role: 'Junior Mobile & Web Developer',
    company: 'Digital Product Innovation Lab',
    location: 'Phnom Penh',
    type: 'Full-time',
    summary:
        'Created cross-platform UI components from high-fidelity Figma designs and set up continuous integration with GitHub Actions.',
    highlights: [
      'Built 15+ reusable Flutter UI widget packages following a shared design system.',
      'Automated multi-platform builds using GitHub Actions CI/CD pipelines.',
    ],
    tech: ['Flutter', 'JavaScript', 'HTML/CSS', 'Git', 'GitHub Actions', 'Figma'],
  ),
];

class Project {
  const Project({
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
    required this.tags,
    this.demoUrl,
    this.sourceUrl,
  });
  final String title, category, description;
  final IconData icon;
  final List<String> tags;
  final String? demoUrl, sourceUrl;
}

// TODO: add store / demo / GitHub links (demoUrl, sourceUrl) when available.
const projects = [
  Project(
    title: 'RED ANT Express',
    category: 'E-Commerce',
    description:
        'Customer shopping app for the RED ANT Express e-commerce platform: browse products, add them to the cart, check out and track orders through to delivery.',
    icon: Icons.shopping_bag_outlined,
    tags: ['Flutter', 'Dart'],
  ),
  Project(
    title: 'RED ANT Merchant',
    category: 'Merchant App',
    description:
        'Seller app for RED ANT Express that lets merchants manage their products and incoming orders, and prepare each order for delivery.',
    icon: Icons.storefront_outlined,
    tags: ['Flutter', 'Dart'],
  ),
  Project(
    title: 'RED ANT Driver',
    category: 'Delivery App',
    description:
        'Driver app for RED ANT Express for accepting delivery jobs, picking up orders from merchants and updating each order through to drop-off.',
    icon: Icons.delivery_dining_outlined,
    tags: ['Flutter', 'Dart'],
  ),
  Project(
    title: 'E-Shop Native',
    category: 'E-Commerce',
    description: 'Native mobile shopping app for Android and iOS covering product browsing, cart and checkout.',
    icon: Icons.phone_iphone_outlined,
    tags: ['Kotlin', 'Swift'],
  ),
];

class SkillGroup {
  const SkillGroup(this.icon, this.title, this.items);
  final IconData icon;
  final String title;
  final List<(String, String?)> items;
}

const skillGroups = [
  SkillGroup(Icons.smartphone_outlined, 'Mobile', [
    ('Flutter', 'Primary'),
    ('Dart', null),
    ('BLoC & Riverpod', null),
    ('Firebase', 'Auth, FCM'),
  ]),
  SkillGroup(Icons.web_outlined, 'Frontend', [
    ('Nuxt', 'Primary'),
    ('Vue 3', null),
    ('TypeScript', null),
    ('Tailwind CSS', null),
  ]),
  SkillGroup(Icons.dns_outlined, 'Backend', [
    ('Laravel', 'REST APIs'),
    ('Node.js & Express', null),
    ('Supabase', 'Auth, RLS'),
    ('Telegram Bot API', null),
  ]),
  SkillGroup(Icons.storage_outlined, 'Data', [
    ('PostgreSQL', null),
    ('MySQL', null),
    ('Redis', null),
  ]),
  SkillGroup(Icons.build_outlined, 'Tooling', [
    ('Git & GitHub Actions', 'CI/CD'),
    ('Docker', null),
    ('Figma', 'Design to code'),
  ]),
];

const practices = [
  'Clean architecture with clear separation between UI, state and data layers',
  'Strict typing in TypeScript and Dart to catch errors before release',
  'Database-level security with row-level policies',
  'Responsive, accessible interfaces that work on every screen size',
];

class Post {
  const Post({
    required this.title,
    required this.category,
    required this.date,
    required this.readTime,
    required this.summary,
    required this.content,
    required this.tags,
  });
  final String title, category, date, readTime, summary, content;
  final List<String> tags;
}

const posts = [
  Post(
    title: 'Building Real-Time Mobile Apps with Flutter & Supabase',
    category: 'Mobile Architecture',
    date: 'Jul 2025',
    readTime: '5 min read',
    summary:
        'A practical guide to implementing BLoC state isolation, Supabase Row-Level Security (RLS), and offline-first Hive caching in Flutter production apps.',
    content: '''Building real-time mobile applications requires a decoupled architecture that balances UI responsiveness, local data caching, and secure cloud synchronization.

### 1. State Management with BLoC Pattern
Using the Business Logic Component (BLoC) pattern separates presentation logic from data streaming. This ensures predictable state transitions when receiving real-time WebSocket events from Supabase.

### 2. Row Level Security (RLS) Policies
Supabase PostgreSQL database policies allow row-level authorization directly at the database layer. By enforcing RLS, client mobile apps interact securely with data without complex intermediary API proxies.

### 3. Offline-First Hive & Isar Caching
To maintain sub-100ms UI interactions, local key-value stores like Hive cache remote payloads locally. When network connectivity drops, operations queue locally and sync atomically once reconnected.''',
    tags: ['Flutter', 'Supabase', 'BLoC', 'PostgreSQL'],
  ),
  Post(
    title: 'Optimizing Nuxt 3 SSR & Design Tokens',
    category: 'Frontend Engineering',
    date: 'Jun 2025',
    readTime: '4 min read',
    summary:
        'How to craft fast Vue 3 applications using Nuxt 3 server-side rendering, dynamic dark mode themes, and performance-first CSS utilities.',
    content: '''Modern web interfaces must deliver immediate visual impact without sacrificing Lighthouse web vitals or page transition speeds.

### 1. Server-Side Rendering (SSR) Optimization
Nuxt 3 leverages Vite and Nitro server engines to render HTML payloads on the server. Using useAsyncData with key caching avoids duplicate requests and speeds up initial loads.

### 2. Custom Design Tokens
Instead of relying on heavy third-party UI libraries, a small set of CSS design tokens keeps styling consistent and maintains high frame rates during scrolling and theme transitions.''',
    tags: ['Nuxt 3', 'Vue 3', 'Tailwind CSS', 'SSR'],
  ),
  Post(
    title: 'Architecting High-Throughput REST APIs in Laravel & Node.js',
    category: 'Backend Systems',
    date: 'May 2025',
    readTime: '6 min read',
    summary:
        'Database indexing strategies, background worker queues, and automated Telegram bot alerts for mission-critical API backends.',
    content: '''When handling high daily transaction volume, API backend performance hinges on SQL indexing precision and asynchronous background queues.

### 1. Database Indexing & Query Optimization
Creating compound indexes on frequent query filter columns reduces database search time significantly. Avoiding N+1 queries using Eloquent eager loading keeps memory usage tight.

### 2. Operational Error Alerts with Telegram
By integrating automated webhook triggers into exception handlers, engineering teams receive immediate stack trace alerts in Telegram channels for fast triage.''',
    tags: ['Laravel', 'Node.js', 'MySQL', 'Telegram API'],
  ),
];
