import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["progress"]

  connect() {
    console.log("progress bar controller")
  }

  progress() {
    this.progressTarget.aria_valuemaxValue
    console.log(this.progressTarget.attributes["aria-valuenow"])
    this.progressTarget.innerText = Number(this.progressTarget.innerText)+1
    this.progressTarget.attributes["aria-valuenow"].value = Number(this.progressTarget.attributes["aria-valuenow"].value)+1
    console.log(this.progressTarget.attributes["aria-valuemax"])
    this.progressTarget.style = `width: ${ (Number(this.progressTarget.attributes["aria-valuenow"].value)/Number(this.progressTarget.attributes["aria-valuemax"].value))*100
    }%`
  }

}