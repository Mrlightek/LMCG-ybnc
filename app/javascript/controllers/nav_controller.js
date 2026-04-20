// ── nav_controller.js ──────────────────────────────────────────
import { Controller } from "@hotwired/stimulus"

export default class NavController extends Controller {
  connect() {
    this._onScroll = this.handleScroll.bind(this)
    window.addEventListener("scroll", this._onScroll, { passive: true })
    this.handleScroll()
  }
  disconnect() { window.removeEventListener("scroll", this._onScroll) }

  handleScroll() {
    this.element.classList.toggle("scrolled", window.scrollY > 60)
  }

  toggleMobile(event) {
    const btn    = event.currentTarget
    const links  = this.element.querySelector(".nav__links")
    const isOpen = btn.getAttribute("aria-expanded") === "true"

    if (isOpen) {
      links.style.cssText = ""
      btn.setAttribute("aria-expanded", "false")
    } else {
      links.style.cssText = `
        display: flex; flex-direction: column; align-items: center;
        justify-content: center; gap: 2.5rem;
        position: fixed; inset: 0; z-index: 300;
        background: rgba(10,10,10,0.98); backdrop-filter: blur(16px);
        animation: navIn 0.3s ease;
      `
      btn.setAttribute("aria-expanded", "true")
      links.querySelectorAll(".nav__link, .nav__cta").forEach(a => {
        a.style.cssText = `
          font-size: 2.2rem; font-weight: 800; text-transform: uppercase;
          letter-spacing: .06em; color: var(--cream);
          font-family: 'Syne', sans-serif;
        `
        a.addEventListener("click", () => {
          links.style.cssText = ""
          btn.setAttribute("aria-expanded", "false")
        }, { once: true })
      })
    }
  }
}