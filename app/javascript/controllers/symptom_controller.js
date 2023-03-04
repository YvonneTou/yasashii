import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "list", "outer"]

  connect() {
    console.log("Hello from our first Stimulus controller")
  }

  dropdown() {
    this.buttonTarget.innerText = "..."
    this.buttonTarget.setAttribute("disabled", "")
    this.listTarget.classList.toggle("d-none")
  }

  close() {
    this.buttonTarget.innerText = "+"
    this.buttonTarget.removeAttribute("disabled")
    this.listTarget.classList.add("d-none")
  }
}
