import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="connections"
export default class extends Controller {
  static targets = ["footer"]

  connect() {
    console.log("Connected!")
  }
}
