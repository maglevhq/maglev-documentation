import { Controller } from "@hotwired/stimulus"

const STORAGE_KEY = "maglev-doc-sidebar-scroll"

export default class extends Controller {
  connect() {
    const raw = sessionStorage.getItem(STORAGE_KEY)
    if (raw === null) return

    const y = parseInt(raw, 10)
    if (Number.isNaN(y)) return

    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.element.scrollTop = y
      })
    })
  }

  disconnect() {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
      this.debounceTimer = null
    }
  }

  scroll() {
    if (this.debounceTimer) clearTimeout(this.debounceTimer)
    this.debounceTimer = window.setTimeout(() => {
      this.debounceTimer = null
      sessionStorage.setItem(STORAGE_KEY, String(this.element.scrollTop))
    }, 100)
  }

  saveNow() {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
      this.debounceTimer = null
    }
    sessionStorage.setItem(STORAGE_KEY, String(this.element.scrollTop))
  }
}
