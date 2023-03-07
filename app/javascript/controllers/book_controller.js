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

  destroy(event) {
    console.log(this.cardTarget.nextElementSibling)
    if (this.cardTarget.nextElementSibling == null) {
      let card_id = this.cardTarget.dataset.cardId;
      this.cardUpdate(event, card_id, true, false);
      this.deckTarget.innerHTML =

      "<div class='flashcard'><div class='flashcard__face flashcard__face--front'>Finished!</div></div>"
    }
    this.cardTarget.nextElementSibling.classList.toggle("d-none");
    this.cardTarget.nextElementSibling.classList.toggle("active-card");
    // this.cardTarget.nextElementSibling.classList.toggle("is-flipped")
    // cardTarget.dataset.cardId dataset returns an object
    // cardId is the value of it we pass in the html
    let card_id = this.cardTarget.dataset.cardId;
    this.cardUpdate(event, card_id, true, false);
    this.cardTarget.remove();
    // this.cardUpdate(event, card_id, true, true)
    console.log("deleted")
  }

  dontKnow(event) {
    event.stopPropagation();
    if (this.cardTarget.nextElementSibling == null) {
      this.cardTarget.classList.toggle("is-flipped");
    }
    else {

      this.cardTarget.classList.toggle("active-card");
      this.cardTarget.classList.toggle("d-none");
      // TODO fix this flipping issue so I don't have to unflip here
      this.cardTarget.classList.toggle("is-flipped");
      this.cardTarget.nextElementSibling.classList.toggle("d-none");
      this.cardTarget.nextElementSibling.classList.toggle("active-card");
      // this.cardTarget.nextElementSibling.classList.toggle("is-flipped")
      console.log(this.deckTarget)
      this.deckTarget.appendChild(this.cardTarget)
    }
    // TODO add cardUpdate to here so it updates with failed true
  }

  cardUpdate(event, card_id, completed, failed) {
    event.preventDefault
    console.log(event)
    console.log(card_id)
    console.log(completed)
    console.log(failed)
    const csrfToken = document.getElementsByName("csrf-token")[0].content;

    fetch(`/cards/${card_id}`, {
      method: "PATCH",
      // Accept is for what format we get back
      // content-type is telling the controller what format we are giving it
      headers: {Accept: "application/json", "Content-Type": "application/json", "X-CSRF-Token": csrfToken,},
      // the body is the parameters i'm sending it
      // the key, and the value

      body: JSON.stringify({card: {"completed_today": completed, "failed_today": failed }})

    })
    .then(response => response.json())
    .then((data) => {
      console.log(data)
    })
  }
}
