import type { Config } from 'tailwindcss'
import forms from '@tailwindcss/forms'
import containerQueries from '@tailwindcss/container-queries'

// Theme-aware colors read RGB channels from CSS variables (see app/assets/css/main.css),
// so opacity modifiers like `bg-primary/10` work and both themes share one set of class names.
const themed = (name: string) => `rgb(var(--${name}) / <alpha-value>)`

export default <Partial<Config>>{
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: themed('accent-rgb'),
        'primary-strong': themed('accent-strong-rgb'),
        background: themed('bg-rgb'),
        surface: themed('surface-rgb'),
        line: themed('border-rgb'),
        'on-background': themed('text-rgb'),
        'on-surface': themed('text-rgb'),
        'on-surface-variant': themed('muted-rgb'),
      },
      fontFamily: {
        headline: ['Inter', '"Inter Fallback"', 'system-ui', 'sans-serif'],
        body: ['Inter', '"Inter Fallback"', 'system-ui', '-apple-system', 'Segoe UI', 'Roboto', 'sans-serif'],
        mono: ['"JetBrains Mono"', 'ui-monospace', 'SFMono-Regular', 'Menlo', 'monospace'],
      },
      maxWidth: {
        page: '72rem',
      },
    },
  },
  plugins: [forms({ strategy: 'class' }), containerQueries],
}
