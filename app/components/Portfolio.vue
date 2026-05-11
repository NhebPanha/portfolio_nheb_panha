<template>
    <section id="portfolio" class="bg-background text-on-background py-24 md:py-40 px-4 md:px-8 max-w-7xl mx-auto relative overflow-hidden" ref="sectionRef">
        <!-- Ambient Glow -->
        <div class="absolute -top-24 -right-24 w-[500px] h-[500px] bg-primary/10 rounded-full blur-[120px] pointer-events-none"></div>
        <div class="absolute -bottom-24 -left-24 w-[500px] h-[500px] bg-secondary/10 rounded-full blur-[120px] pointer-events-none"></div>

        <div class="relative z-10 transition-all duration-1000 ease-out"
             :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">
            
            <div class="mb-20">
                <span class="font-label text-xs tracking-[0.3em] text-primary uppercase mb-4 block">
                    Selected Works
                </span>
                <h2 class="font-headline text-5xl md:text-7xl font-black tracking-tighter leading-none mb-6">
                    Featured <span class="text-transparent bg-clip-text bg-gradient-to-r from-primary to-secondary">Ecosystems</span>
                </h2>
                <p class="text-on-surface-variant/70 text-lg max-w-2xl leading-relaxed">
                    A collection of high-precision digital solutions, ranging from financial ecosystems to complex logistics platforms.
                </p>
            </div>

            <!-- Projects Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 md:gap-8">
                <div v-for="(project, index) in projects" :key="index" 
                     class="group relative rounded-[1.5rem] overflow-hidden glass-panel border border-white/5 bg-white/[0.02] transition-all duration-500 hover:border-primary/30">
                    
                    <!-- Project Image/Placeholder -->
                    <div class="aspect-[16/10] overflow-hidden relative">
                        <div class="absolute inset-0 bg-gradient-to-br from-primary/20 to-secondary/20 opacity-40 group-hover:scale-110 transition-transform duration-700"></div>
                        <div class="absolute inset-0 flex items-center justify-center">
                            <span class="material-symbols-outlined text-6xl text-black/[0.03] dark:text-white/10 group-hover:text-primary/40 transition-colors duration-500">{{ project.icon }}</span>
                        </div>
                        
                        <!-- Floating Tag -->
                        <div class="absolute top-6 left-6 px-4 py-1.5 rounded-full bg-black/40 backdrop-blur-md border border-white/10 text-[10px] font-bold tracking-widest uppercase text-white/80">
                            {{ project.category }}
                        </div>
                    </div>

                    <!-- Project Content -->
                    <div class="p-6 md:p-8">
                        <div class="flex justify-between items-start mb-3">
                            <h3 class="text-xl md:text-2xl font-black tracking-tighter">{{ project.title }}</h3>
                            <a :href="project.link" class="w-10 h-10 rounded-full bg-black/5 dark:bg-white/5 flex items-center justify-center hover:bg-primary hover:text-white dark:hover:text-black transition-all duration-300">
                                <span class="material-symbols-outlined text-xl">north_east</span>
                            </a>
                        </div>
                        <p class="text-sm text-on-surface-variant/80 leading-relaxed mb-6 line-clamp-2">
                            {{ project.description }}
                        </p>
                        
                        <!-- Tech Stack Tags -->
                        <div class="flex flex-wrap gap-2">
                            <span v-for="tech in project.tags" :key="tech" class="px-3 py-1 rounded-lg bg-black/[0.03] dark:bg-white/5 border border-black/[0.05] dark:border-white/5 text-[10px] font-medium text-on-surface-variant/60">
                                {{ tech }}
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- View More Button -->
            <div class="mt-20 text-center">
                <button class="px-8 py-4 rounded-full bg-white/5 border border-white/10 font-bold tracking-widest uppercase text-xs hover:bg-white/10 transition-all duration-300">
                    Explore All Projects
                </button>
            </div>
        </div>
    </section>
</template>

<script setup>
const { sectionRef, isVisible } = useScrollAnimate(0.1)

const projects = [
    {
        title: "FinTech Wallet",
        category: "Financial Ecosystem",
        description: "A robust digital wallet solution featuring real-time transactions, multi-currency support, and biometric security integration.",
        icon: "account_balance_wallet",
        tags: ["Flutter", "Laravel", "PostgreSQL"],
        link: "#"
    },
    {
        title: "Nexus Logistics",
        category: "Delivery System",
        description: "End-to-end logistics platform with real-time GPS tracking, automated routing, and dynamic driver dispatching.",
        icon: "local_shipping",
        tags: ["Nuxt 3", "Supabase", "Google Maps API"],
        link: "#"
    },
    {
        title: "Aura E-Commerce",
        category: "Retail Platform",
        description: "Premium retail experience with advanced filtering, seamless checkout, and integrated inventory management.",
        icon: "shopping_bag",
        tags: ["Vue.js", "Firebase", "Stripe"],
        link: "#"
    },
    {
        title: "Precision Accounting",
        category: "Business Tool",
        description: "Specialized accounting software for SMEs, focusing on automated reporting and fiscal compliance.",
        icon: "calculate",
        tags: ["Laravel", "TypeScript", "Tailwind"],
        link: "#"
    },
    {
        title: "Smart HR",
        category: "Enterprise Tool",
        description: "Comprehensive human resource management system with automated payroll and performance tracking.",
        icon: "groups",
        tags: ["Nuxt 3", "Laravel", "MySQL"],
        link: "#"
    },
    {
        title: "AgriTech Monitor",
        category: "IoT Platform",
        description: "Real-time agricultural monitoring system using IoT sensors for crop health and soil analysis.",
        icon: "agriculture",
        tags: ["Flutter", "Node.js", "MQTT"],
        link: "#"
    }
]
</script>

<style scoped>
.glass-panel {
    backdrop-filter: blur(20px);
}

.group:hover .glass-panel {
    background: rgba(255, 255, 255, 0.04);
}
</style>
