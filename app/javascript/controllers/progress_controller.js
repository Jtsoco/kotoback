import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["progress"]

  connect() {
    console.log("progress bar controller")
    this.progress()
  }

  progress() {
    this.progressTarget.aria_valuemaxValue
    console.log(this.progressTarget.attributes["aria-valuenow"])
    this.progressTarget.attributes["aria-valuenow"].value = Number(this.progressTarget.attributes["aria-valuenow"].value) + 1
    this.progressTarget.innerText = `${Number(this.progressTarget.attributes["aria-valuenow"].value)} / ${Number(this.progressTarget.attributes["aria-valuemax"].value)}`
    console.log(this.progressTarget.attributes["aria-valuemax"])
    this.progressTarget.style = `width: ${(Number(this.progressTarget.attributes["aria-valuenow"].value) / Number(this.progressTarget.attributes["aria-valuemax"].value)) * 100
      }%`
  }

}
