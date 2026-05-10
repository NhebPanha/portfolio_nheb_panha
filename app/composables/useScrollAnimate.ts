import { ref, onMounted } from 'vue'

export function useScrollAnimate(threshold = 0.1) {
  const sectionRef = ref<HTMLElement | null>(null)
  const isVisible = ref(false)

  onMounted(() => {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          isVisible.value = true
          observer.disconnect()
        }
      })
    }, { threshold })

    if (sectionRef.value) {
      observer.observe(sectionRef.value)
    }
  })

  return {
    sectionRef,
    isVisible
  }
}
