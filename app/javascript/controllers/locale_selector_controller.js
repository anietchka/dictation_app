import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
  }

  change(event) {
    event.preventDefault()
    event.stopPropagation()
    const locale = event.params.locale
    if (locale) {
      const form = document.createElement("form")
      form.method = "POST"
      form.action = `/locale/${locale}`
      form.style.display = "none"
      
      const methodInput = document.createElement("input")
      methodInput.type = "hidden"
      methodInput.name = "_method"
      methodInput.value = "patch"
      
      const csrfToken = document.querySelector('meta[name="csrf-token"]')
      if (csrfToken) {
        const csrfInput = document.createElement("input")
        csrfInput.type = "hidden"
        csrfInput.name = "authenticity_token"
        csrfInput.value = csrfToken.content
        form.appendChild(csrfInput)
      }
      
      form.appendChild(methodInput)
      document.body.appendChild(form)
      form.submit()
    }
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }

  connect() {
    this.boundClose = this.close.bind(this)
    document.addEventListener("click", this.boundClose)
  }

  disconnect() {
    document.removeEventListener("click", this.boundClose)
  }
}

