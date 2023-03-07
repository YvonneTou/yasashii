import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-date"
export default class extends Controller {
  static targets = ['appt', "footer"]

  connect() {
    // console.log("connected")
  }

  reveal() {
    console.log(this.hasApptTarget)
    this.apptTarget.classList.toggle("hide");
  }
}
