<template>
    <div id="about" class="bg-background text-on-background font-body relative overflow-hidden transition-colors duration-500">
        <!-- Ambient Glows -->
        <div class="absolute top-0 right-0 w-[600px] h-[600px] bg-primary/5 rounded-full blur-[140px] pointer-events-none"></div>
        <div class="absolute bottom-0 left-0 w-[600px] h-[600px] bg-secondary/5 rounded-full blur-[140px] pointer-events-none"></div>

        <main class="pt-24 md:pt-40 pb-32 px-4 md:px-8 max-w-7xl mx-auto relative z-10" ref="sectionRef">
            
            <!-- Clean About Content -->
            <section class="max-w-4xl transition-all duration-1000 ease-out"
                     :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">
                
                <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/5 border border-white/10 text-primary text-[10px] font-bold tracking-[0.3em] uppercase mb-8">
                    <span class="w-1.5 h-1.5 rounded-full bg-primary animate-pulse"></span>
                    The Architect
                </span>

                <h1 class="font-headline text-5xl md:text-8xl font-black tracking-tighter leading-[0.85] mb-10">
                    Nheb <span class="text-transparent bg-clip-text bg-gradient-to-r from-primary to-secondary">Panha</span>
                </h1>

                <div class="grid grid-cols-1 md:grid-cols-12 gap-12 items-start">
                    <div class="md:col-span-8 space-y-6">
                        <p class="text-xl md:text-3xl text-on-surface-variant font-light leading-snug">
                            An <span class="text-on-surface font-medium italic underline decoration-primary/30 decoration-2 underline-offset-4">Accounting-Developer</span> 
                            crafting high-precision digital ecosystems with Nuxt, Laravel, and Flutter.
                        </p>
                        <p class="text-lg text-on-surface-variant/80 leading-relaxed max-w-2xl">
                            I bridge the gap between financial meticulousness and technical creativity. 
                            My work focuses on building scalable, user-centric applications that solve 
                            complex business challenges with elegant code.
                        </p>
                    </div>

                    <div class="md:col-span-4 flex flex-col gap-6">
                        <div class="p-6 rounded-3xl glass-panel border border-white/5">
                            <span class="text-[10px] font-bold tracking-widest text-primary uppercase block mb-1">Experience</span>
                            <div class="text-4xl font-black tracking-tighter italic">06+ <span class="text-sm font-normal not-italic text-on-surface-variant">Years</span></div>
                        </div>
                        <div class="p-6 rounded-3xl glass-panel border border-white/5">
                            <span class="text-[10px] font-bold tracking-widest text-secondary uppercase block mb-1">Delivery</span>
                            <div class="text-4xl font-black tracking-tighter italic">42+ <span class="text-sm font-normal not-italic text-on-surface-variant">Projects</span></div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Running Skills Marquee (Bottom) -->
            <div class="mt-32 md:mt-48 relative transition-all duration-1000 delay-300"
                 :class="isVisible ? 'opacity-100 scale-100' : 'opacity-0 scale-95'">
                
                <h3 class="text-center text-[10px] font-bold tracking-[0.4em] text-white/20 uppercase mb-12">
                    Core Technical Ecosystem
                </h3>

                <!-- Row 1: Forward -->
                <div class="marquee-wrap mb-6">
                    <div class="marquee-content animate-marquee">
                        <div v-for="skill in [...allSkills, ...allSkills]" :key="skill.name" class="skill-tag">
                            <span class="material-symbols-outlined text-primary/70 text-lg">{{ skill.icon }}</span>
                            <span class="font-bold tracking-tight">{{ skill.name }}</span>
                        </div>
                    </div>
                </div>

                <!-- Row 2: Reverse -->
                <div class="marquee-wrap">
                    <div class="marquee-content animate-marquee-reverse">
                        <div v-for="skill in [...allSkills, ...allSkills]" :key="skill.name + '-rev'" class="skill-tag skill-tag-alt">
                            <span class="material-symbols-outlined text-secondary/70 text-lg">{{ skill.icon }}</span>
                            <span class="font-bold tracking-tight">{{ skill.name }}</span>
                        </div>
                    </div>
                </div>

                <!-- Gradient Overlays for smooth edges -->
                <div class="absolute inset-y-0 left-0 w-32 bg-gradient-to-r from-background to-transparent z-10"></div>
                <div class="absolute inset-y-0 right-0 w-32 bg-gradient-to-l from-background to-transparent z-10"></div>
            </div>

        </main>
    </div>
</template>

<script setup>
const { sectionRef, isVisible } = useScrollAnimate(0.1)

const allSkills = [
    { name: "Flutter", icon: "smartphone" },
    { name: "Laravel", icon: "api" },
    { name: "Nuxt 3", icon: "auto_awesome" },
    { name: "Vue.js", icon: "web" },
    { name: "Supabase", icon: "cloud" },
    { name: "PostgreSQL", icon: "database" },
    { name: "Tailwind", icon: "palette" },
    { name: "Dart", icon: "code" },
    { name: "Node.js", icon: "terminal" },
    { name: "Firebase", icon: "local_fire_department" },
    { name: "TypeScript", icon: "javascript" },
    { name: "Git", icon: "account_tree" }
]
</script>

<style scoped>
.marquee-wrap {
    overflow: hidden;
    display: flex;
    white-space: nowrap;
    mask-image: linear-gradient(to right, transparent, black 10%, black 90%, transparent);
}

.marquee-content {
    display: flex;
    gap: 1.5rem;
    padding: 0.5rem 0;
}

.skill-tag {
    flex-shrink: 0;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 0.75rem 1.5rem;
    background-color: var(--glass-bg);
    border: 1px solid var(--glass-border);
    backdrop-blur: 10px;
    border-radius: 1rem;
    transition: all 0.3s ease;
    cursor: default;
}

.skill-tag:hover {
    background: rgba(0, 251, 251, 0.1);
    border-color: var(--accent);
    transform: translateY(-2px);
    box-shadow: 0 10px 20px -5px rgba(0, 251, 251, 0.2);
}

.skill-tag-alt:hover {
    background: rgba(255, 129, 245, 0.1);
    border-color: var(--secondary);
    box-shadow: 0 10px 20px -5px rgba(255, 129, 245, 0.2);
}

.animate-marquee {
    animation: marquee 40s linear infinite;
}

.animate-marquee-reverse {
    animation: marquee-reverse 45s linear infinite;
}

@keyframes marquee {
    0% { transform: translateX(0); }
    100% { transform: translateX(-50%); }
}

@keyframes marquee-reverse {
    0% { transform: translateX(-50%); }
    100% { transform: translateX(0); }
}

.glass-panel {
    background: rgba(255, 255, 255, 0.03);
    backdrop-filter: blur(12px);
    border-radius: 24px;
}

.dark .glass-panel {
    background: rgba(255, 255, 255, 0.02);
}
</style>
