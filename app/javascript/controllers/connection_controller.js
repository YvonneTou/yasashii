import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-date"
export default class extends Controller {
  static targets = ["appt", "button"]

  connect() {
    // console.log("connected")
  }

  reveal() {
    this.apptTarget.classList.toggle("hide");
  }

  disable() {
    console.log("hello")
    this.buttonTargets.forEach((btn) => {
      btn.disabled = true
    })
  }
}
