import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  change(event) {
    const locale = event.target.value
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
}

