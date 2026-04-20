// ── reveal_controller.js ────────────────────────────────────────
import { Controller } from "@hotwired/stimulus"

export default class RevealController extends Controller {
  connect() {
    this._obs = new IntersectionObserver(entries => {
      entries.forEach(e => {
        if (e.isIntersecting) {
          e.target.classList.add("vis")
          this._obs.unobserve(e.target)
        }
      })
    }, { threshold: 0.08, rootMargin: "0px 0px -40px 0px" })

    this.element.querySelectorAll(".reveal").forEach(el => this._obs.observe(el))
  }

  disconnect() { this._obs?.disconnect() }
}