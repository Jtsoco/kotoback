import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="book"
export default class extends Controller {
  static targets = ["card", "deck"]
  connect() {
    console.log(this.cardTarget);
    console.log(this.deckTarget);
    console.log(this.deckTarget.firstChild);
    this.deckTarget.firstElementChild.classList.add("active-card");
    this.deckTarget.firstElementChild.classList.toggle("d-none")
  }

  flipCards() {
    this.cardTarget.classList.toggle('is-flipped');
    console.log("flip")
    console.log(this.cardTarget)

  }

  destroy() {
    this.cardTarget.remove()
    console.log("deleted")
  }

  dontKnow() {
    this.cardTarget.classList.toggle("active-card");
    this.cardTarget.classList.toggle("d-none");
    this.cardTarget.classList.toggle("is-flipped")
    this.cardTarget.nextElementSibling.classList.toggle("d-none");
    this.cardTarget.nextElementSibling.classList.toggle("active-card");
    this.cardTarget.nextElementSibling.classList.toggle("is-flipped")
    console.log(this.deckTarget)
    this.deckTarget.appendChild(this.cardTarget)
  }
}
