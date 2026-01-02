import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list"]

  add(event) {
    event.preventDefault()
    const index = new Date().getTime()
    const field = `
      <div class="selling-point-item">
        <input type="text" name="landing_page[business_details][selling_points][]" class="form-input" placeholder="Enter selling point">
        <button type="button" data-action="click->selling-points#remove" class="remove-btn">Remove</button>
      </div>
    `
    this.listTarget.insertAdjacentHTML("beforeend", field)
  }

  remove(event) {
    event.target.closest(".selling-point-item").remove()
  }
}
