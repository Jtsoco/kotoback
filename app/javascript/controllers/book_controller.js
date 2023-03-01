import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="booking"
export default class extends Controller {
  static targets = ["card"]
  connect() {
    console.log(this.cardTarget)
  }

  flipCards() {
    this.cardTarget.classList.toggle('is-flipped');
    console.log("flip")

  }
}
