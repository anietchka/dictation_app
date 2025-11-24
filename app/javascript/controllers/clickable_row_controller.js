import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.element.style.cursor = "pointer"
  }

  click(event) {
    // Ne pas rediriger si on clique sur un lien ou un bouton
    if (event.target.closest("a, button")) {
      return
    }
    
    if (this.urlValue) {
      window.location.href = this.urlValue
    }
  }
}

