<template>
    <div class="bg-background text-on-background font-body transition-colors duration-500">
        <section id="about" class="pt-24 md:pt-32 pb-16 md:pb-24 max-w-7xl mx-auto px-4 md:px-8" ref="sectionRef">
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 md:gap-12">
                <div class="lg:col-span-4 transition-all duration-700 ease-out delay-100"
                     :class="isVisible ? 'opacity-100 translate-x-0' : 'opacity-0 -translate-x-12'">
                    <span class="font-label text-xs tracking-[0.2em] text-primary uppercase mb-4 block">
                        Get to know me
                    </span>
                    <h2 class="font-headline text-4xl md:text-5xl font-black tracking-tighter leading-none mb-8">
                        About <span class="text-secondary-fixed-dim">Me</span>
                    </h2>
                </div>
                <div class="lg:col-span-8 transition-all duration-700 ease-out delay-300"
                     :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'">
                    <div class="glass-panel p-8 md:p-12">
                        <p class="text-on-surface-variant text-lg leading-relaxed mb-6">
                            I am a dedicated Software Developer specializing in crafting modern mobile and web applications with Flutter, Vue.js, and Laravel. With a strong foundation in full-stack development, I bridge the gap between intuitive UI/UX design and robust backend architectures.
                            <br><br>
                            My portfolio spans diverse projects, including e-commerce platforms, wallet applications, and delivery systems. In these roles, I've successfully implemented complex features like secure authentication, real-time data processing, and seamless responsive designs.
                        </p>
                        <p class="text-on-surface-variant text-lg leading-relaxed">
                            Committed to engineering excellence, I prioritize clean, maintainable, and scalable code. I am driven by a continuous desire to learn and innovate, particularly in mobile development and system architecture, with the ultimate goal of building digital solutions that make a tangible impact.
                        </p>
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>

<script setup>
const { sectionRef, isVisible } = useScrollAnimate(0.2)
</script>

<style scoped>
.glass-panel {
    background: rgba(255, 255, 255, 0.4);
    backdrop-filter: blur(12px);
    border-radius: 12px;
    transition: transform 0.3s;
}

.dark .glass-panel {
    background: rgba(131, 130, 130, 0.144);
}
</style>
