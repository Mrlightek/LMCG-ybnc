// ── counter_controller.js ───────────────────────────────────────
// Animates numbers up when they scroll into view
import { Controller } from "@hotwired/stimulus"

export default class CounterController extends Controller {
  static targets = ["number"]
  static values  = { duration: { type: Number, default: 2000 } }

  connect() {
    this._obs = new IntersectionObserver(entries => {
      entries.forEach(e => {
        if (e.isIntersecting && !e.target.dataset.counted) {
          this.animateCounter(e.target)
          e.target.dataset.counted = "true"
          this._obs.unobserve(e.target)
        }
      })
    }, { threshold: 0.4 })
    this.numberTargets.forEach(el => this._obs.observe(el))
  }

  disconnect() { this._obs?.disconnect() }

  animateCounter(el) {
    const target   = parseInt(el.dataset.count || el.textContent) || 0
    const suffix   = el.textContent.replace(/[\d,]/g, "").trim()
    const start    = 0
    const duration = this.durationValue
    const startTime = performance.now()

    const step = (now) => {
      const elapsed  = now - startTime
      const progress = Math.min(elapsed / duration, 1)
      // Ease out cubic
      const eased    = 1 - Math.pow(1 - progress, 3)
      const current  = Math.floor(eased * (target - start) + start)
      el.textContent = current.toLocaleString() + suffix
      if (progress < 1) requestAnimationFrame(step)
    }
    requestAnimationFrame(step)
  }
}
