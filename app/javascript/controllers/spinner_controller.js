import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="spinner"
export default class extends Controller {
  connect() {
  }

  insertspin(event) {
    event.currentTarget.querySelector('label').innerHTML=" <i class='fa-solid fa-cog fa-spin'></i>"
  }
}
