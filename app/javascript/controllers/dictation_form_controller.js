import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["optionalField", "addButton"]

  toggleField(event) {
    const fieldId = event.params.field
    const field = this.optionalFieldTargets.find(f => f.dataset.fieldId === fieldId)
    const button = this.addButtonTargets.find(b => b.dataset.fieldId === fieldId)

    if (field && button) {
      field.classList.remove("hidden")
      button.classList.add("hidden")
    }
  }
}


