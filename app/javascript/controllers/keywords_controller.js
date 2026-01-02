import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list"]

  add(event) {
    event.preventDefault()
    const field = `
      <div class="keyword-item">
        <input type="text" name="landing_page[business_details][keywords][]" class="form-input" placeholder="Enter keyword">
        <button type="button" data-action="click->keywords#remove" class="remove-btn">Remove</button>
      </div>
    `
    this.listTarget.insertAdjacentHTML("beforeend", field)
  }

  remove(event) {
    event.target.closest(".keyword-item").remove()
  }
}
