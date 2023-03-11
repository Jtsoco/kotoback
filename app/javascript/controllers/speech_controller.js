import { Controller } from "@hotwired/stimulus"
import SynthVoice from "../components/speech"

// Connects to data-controller="speech"
export default class extends Controller {
  static targets = ['word']

  connect() {
    console.log('connected');
  }

  talk(event) {
    event.stopPropagation()
    // console.log(this.element.innerText);
    console.log(this.wordTarget.innerText);
    var voice = new SynthVoice()
    if (this.element.dataset.language === 'JP') {
      voice.say(this.wordTarget.innerText, {voiceURI: "Microsoft Ichiro - Japanese (Japan)"})
    } else {
      voice.say(this.wordTarget.innerText)
    }
    //
    // voice.say(this.wordTarget.innerText)
    // voice.say("早い", {voiceURI: "Microsoft Ichiro - Japanese (Japan)"})
  }
}
