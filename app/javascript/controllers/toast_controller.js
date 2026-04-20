// ── toast_controller.js ─────────────────────────────────────────
import { Controller } from "@hotwired/stimulus"

export default class ToastController extends Controller {
  connect() {
    this._timer = setTimeout(() => this.dismiss(), 5500)
  }
  disconnect() { clearTimeout(this._timer) }

  dismiss() {
    this.element.style.transition = "opacity .4s, transform .4s"
    this.element.style.opacity    = "0"
    this.element.style.transform  = "translateX(110%)"
    setTimeout(() => this.element.remove(), 400)
  }
}