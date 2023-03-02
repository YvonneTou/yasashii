import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="connection-subscription"
export default class extends Controller {
  static values = { connectionID: Number }
  static targets = ["messages"]

  connect() {
    console.log(`Subscribe to the chatroom with the id ${this.connectionIdValue}.`)
  }
}
