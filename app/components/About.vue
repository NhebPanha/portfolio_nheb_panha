<template>
    <div id="about"
        class="bg-background text-on-background font-body relative overflow-hidden transition-colors duration-500">

        <!-- Ambient Glows -->
        <div
            class="absolute top-0 right-0 w-[600px] h-[600px] bg-primary/5 rounded-full blur-[140px] pointer-events-none">
        </div>

        <div
            class="absolute bottom-0 left-0 w-[600px] h-[600px] bg-secondary/5 rounded-full blur-[140px] pointer-events-none">
        </div>

        <main class="pt-24 md:pt-40 pb-32 px-4 md:px-8 max-w-7xl mx-auto relative z-10" ref="sectionRef">

            <!-- About Me Section -->
            <section class="max-w-5xl transition-all duration-1000 ease-out"
                :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">

                <!-- Label -->
                <span
                    class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white/5 border border-white/10 text-primary text-[10px] font-bold tracking-[0.35em] uppercase mb-8">
                    <span class="w-1.5 h-1.5 rounded-full bg-primary animate-pulse"></span>
                    About Me
                </span>

                <!-- Main Heading -->
                <h1 class="font-headline text-5xl md:text-8xl font-black tracking-tighter leading-[0.85] mb-10">
                    Nheb
                    <span class="text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-blue-500 to-pink-500">
                        Panha
                    </span>
                </h1>

                <!-- Grid -->
                <div class="grid grid-cols-1 md:grid-cols-12 gap-12 items-start">

                    <!-- Left Content -->
                    <div class="md:col-span-8 space-y-8">

                        <p class="text-xl md:text-3xl text-on-surface-variant font-light leading-snug">
                            I am a
                            <span
                                class="text-on-surface font-medium italic underline decoration-primary/30 decoration-2 underline-offset-4">
                                Mobile App Developer
                            </span>
                            passionate about building modern, high-performance applications with seamless user
                            experiences and scalable architecture.
                        </p>

                        <p class="text-lg text-on-surface-variant/80 leading-relaxed max-w-3xl">
                            My journey combines financial precision with software engineering,
                            allowing me to create solutions that are both technically powerful
                            and strategically efficient. I specialize in modern technologies
                            including Flutter, Nuxt, Laravel, and cloud-based ecosystems.
                        </p>

                        <p class="text-lg text-on-surface-variant/80 leading-relaxed max-w-3xl">
                            From fintech platforms and delivery systems to AI-powered dashboards,
                            I focus on building high-performance applications with clean architecture,
                            modern UI/UX, and real-world impact.
                        </p>

                        <!-- Quick Info -->
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 pt-4">

                            <div class="glass-panel p-5 rounded-2xl border border-white/5">
                                <p class="text-primary text-xs tracking-[0.25em] uppercase mb-2">
                                    Experience
                                </p>
                                <h3 class="text-3xl font-black">06+</h3>
                                <p class="text-sm text-on-surface-variant">
                                    Years
                                </p>
                            </div>

                            <div class="glass-panel p-5 rounded-2xl border border-white/5">
                                <p class="text-secondary text-xs tracking-[0.25em] uppercase mb-2">
                                    Projects
                                </p>
                                <h3 class="text-3xl font-black">42+</h3>
                                <p class="text-sm text-on-surface-variant">
                                    Completed
                                </p>
                            </div>

                            <div class="glass-panel p-5 rounded-2xl border border-white/5">
                                <p class="text-primary text-xs tracking-[0.25em] uppercase mb-2">
                                    Focus
                                </p>
                                <h3 class="text-xl font-black">
                                    UI/UX
                                </h3>
                                <p class="text-sm text-on-surface-variant">
                                    Innovation
                                </p>
                            </div>

                            <div class="glass-panel p-5 rounded-2xl border border-white/5">
                                <p class="text-secondary text-xs tracking-[0.25em] uppercase mb-2">
                                    Location
                                </p>
                                <h3 class="text-xl font-black">
                                    Cambodia
                                </h3>
                                <p class="text-sm text-on-surface-variant">
                                    Phnom Penh
                                </p>
                            </div>

                        </div>
                    </div>

                    <!-- Right Side Card -->
                    <div class="md:col-span-4">
                        <div class="glass-panel border border-white/10 rounded-[2rem] p-8 relative overflow-hidden">

                            <div
                                class="absolute inset-0 bg-gradient-to-br from-primary/10 via-transparent to-secondary/10 pointer-events-none">
                            </div>

                            <div class="relative z-10">

                                <div
                                    class="w-20 h-20 rounded-3xl bg-gradient-to-br from-primary to-secondary flex items-center justify-center mb-6 shadow-2xl">
                                    <span class="material-symbols-outlined text-white text-4xl">
                                        person
                                    </span>
                                </div>

                                <h3 class="text-3xl font-black tracking-tight mb-3">
                                    Creative Developer
                                </h3>

                                <p class="text-on-surface-variant leading-relaxed mb-6">
                                    Passionate about designing modern digital ecosystems with
                                    clean code, scalable architecture, and immersive user experiences.
                                </p>

                                <div class="space-y-4">

                                    <div class="flex items-center gap-3">
                                        <span class="material-symbols-outlined text-primary">
                                            code
                                        </span>
                                        <span>Full Stack Development</span>
                                    </div>

                                    <div class="flex items-center gap-3">
                                        <span class="material-symbols-outlined text-secondary">
                                            smartphone
                                        </span>
                                        <span>Cross-Platform Mobile Apps</span>
                                    </div>

                                    <div class="flex items-center gap-3">
                                        <span class="material-symbols-outlined text-primary">
                                            palette
                                        </span>
                                        <span>Modern UI/UX Design</span>
                                    </div>

                                    <div class="flex items-center gap-3">
                                        <span class="material-symbols-outlined text-secondary">
                                            database
                                        </span>
                                        <span>Backend & Database Systems</span>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>

                </div>
            </section>

            <!-- Skills Marquee -->
            <div class="mt-32 md:mt-48 relative transition-all duration-1000 delay-300"
                :class="isVisible ? 'opacity-100 scale-100' : 'opacity-0 scale-95'">

                <h3 class="text-center text-[10px] font-bold tracking-[0.4em] text-white/20 uppercase mb-12">
                    Core Technical Ecosystem
                </h3>

                <!-- Row 1 -->
                <div class="marquee-wrap mb-6">
                    <div class="marquee-content animate-marquee">
                        <div v-for="skill in [...allSkills, ...allSkills]" :key="skill.name" class="skill-tag">
                            <span class="material-symbols-outlined text-primary/70 text-lg">
                                {{ skill.icon }}
                            </span>
                            <span class="font-bold tracking-tight">
                                {{ skill.name }}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Row 2 -->
                <div class="marquee-wrap">
                    <div class="marquee-content animate-marquee-reverse">
                        <div v-for="skill in [...allSkills, ...allSkills]" :key="skill.name + '-rev'"
                            class="skill-tag skill-tag-alt">
                            <span class="material-symbols-outlined text-secondary/70 text-lg">
                                {{ skill.icon }}
                            </span>
                            <span class="font-bold tracking-tight">
                                {{ skill.name }}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Gradient Overlays -->
                <div class="absolute inset-y-0 left-0 w-32 bg-gradient-to-r from-background to-transparent z-10">
                </div>

                <div class="absolute inset-y-0 right-0 w-32 bg-gradient-to-l from-background to-transparent z-10">
                </div>

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
    0% {
        transform: translateX(0);
    }

    100% {
        transform: translateX(-50%);
    }
}

@keyframes marquee-reverse {
    0% {
        transform: translateX(-50%);
    }

    100% {
        transform: translateX(0);
    }
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