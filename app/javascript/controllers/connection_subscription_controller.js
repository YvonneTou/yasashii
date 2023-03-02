import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="connection-subscription"
export default class extends Controller {
  static values = { connectionId: Number }
  static targets = ["messages"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ConnectionChannel", id: this.connectionIdValue },
      { received: data => this.messagesTarget.#insertMessageAndReload(data) }
    )

    #insertMessageAndReload(data) {
      this.messagesTarget.insertAdjacentHTML("beforeend", data)
    }

    console.log(`Subscribed to the connection with the id ${this.connectionIdValue}.`)
  }


}
