import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="book"
export default class extends Controller {
  static targets = ["card"]
  connect() {
    // console.log(this.cardTarget)
  }

  flipCards() {
    this.cardTarget.classList.toggle('is-flipped');
    console.log("flip")

  }

  destroy() {
    this.cardTarget.remove()
    console.log("deleted")
  }
}
