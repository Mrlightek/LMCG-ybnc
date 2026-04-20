// ── event_filter_controller.js ──────────────────────────────────
import { Controller } from "@hotwired/stimulus"

export default class EventFilterController extends Controller {
  static targets = ["tab", "row"]

  filter(event) {
    const type = event.currentTarget.dataset.type

    this.tabTargets.forEach(t => {
      t.style.borderColor = t.dataset.type === type ? "var(--gold)" : "var(--border)"
      t.style.color       = t.dataset.type === type ? "var(--gold)" : "var(--text-muted)"
    })

    this.rowTargets.forEach(row => {
      const show = type === "all" || row.dataset.type === type
      row.style.opacity       = show ? "1"   : "0.2"
      row.style.pointerEvents = show ? ""    : "none"
      row.style.transition    = "opacity .3s ease"
    })

    // If using Turbo frames for server-side filtering:
    if (type !== "all" && this.element.dataset.filterUrl) {
      const url = new URL(this.element.dataset.filterUrl, window.location.origin)
      url.searchParams.set("type", type)
      Turbo.visit(url.toString(), { frame: "events_list" })
    }
  }
}