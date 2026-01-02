import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab"]

  connect() {
    console.log("Tabs controller connected!")
    console.log("Tab targets found:", this.tabTargets.length)
    if (this.tabTargets.length > 0) {
      this.setActiveTab(this.tabTargets[0])
    }
  }

  select(event) {
    console.log("Tab clicked!")
    this.setActiveTab(event.currentTarget)
  }

  setActiveTab(selectedTab) {
    console.log("Setting active tab:", selectedTab)
    this.tabTargets.forEach(tab => tab.classList.remove("active"))
    selectedTab.classList.add("active")
  }
}
