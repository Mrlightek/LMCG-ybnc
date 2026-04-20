// ── newsletter_form_controller.js ───────────────────────────────
import { Controller } from "@hotwired/stimulus"

export default class NewsletterFormController extends Controller {
  connect() {
    this.element.addEventListener("turbo:submit-start", this._onStart.bind(this))
    this.element.addEventListener("turbo:submit-end",   this._onEnd.bind(this))
  }

  _onStart() {
    const btn = this.element.querySelector("[type=submit]")
    if (btn) { btn.disabled = true; btn.textContent = "Joining..." }
  }

  _onEnd() {
    const btn = this.element.querySelector("[type=submit]")
    if (btn) { btn.disabled = false; btn.textContent = "Join YBNC →" }
  }
}