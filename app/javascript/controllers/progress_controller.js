import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["progress"]

  connect() {
    console.log("progress bar controller")
    this.current = this.progressTarget.attributes["aria-valuenow"]
    this.max = this.progressTarget.attributes["aria-valuemax"]
    this.displayProgress()
  }

  progress() {
    this.current.value = Number(this.current.value) + 1
    this.displayProgress()
  }

  displayProgress() {
    this.progressTarget.innerText = `${Number(this.current.value)} / ${Number(this.max.value)}`
    this.progressTarget.style = `width: ${this.current.value === "0" ? "auto" : (Number(this.current.value) / Number(this.max.value)) * 100
      }%`
  }

}
