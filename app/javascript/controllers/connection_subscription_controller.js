import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="connection-subscription"
export default class extends Controller {
  static values = { connectionId: Number }
  static targets = ["messages"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ConnectionChannel", id: this.connectionIdValue },
      { received: data => {
          if (data.head == 302 && data.path && data.params) {
            window.location.pathname = data.path
            window.location.search = data.params
          }
          else if (data.head == 302 && data.path) {
            window.location.pathname = data.path
          }
          else {
            this.messagesTarget.insertAdjacentHTML("beforeend", data)
            window.scrollTo({
              top: this.element.scrollHeight,
              left: 0,
              behavior: "smooth",
            })
          }
        }
      }
    )

    // console.log(`Subscribed to the connection with the id ${this.connectionIdValue}.`)
  }
}
