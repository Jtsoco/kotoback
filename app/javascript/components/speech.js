export default function SynthVoice(options = {}) {
  this.synth = window.speechSynthesis;
  this.utterance = new SpeechSynthesisUtterance()
  // Default options
  this.options = { voiceURI: "Google US English" }
  Object.assign(this.options, options)

  this.getVoices = () => {
    // Need to wait until getVoices() actually returns some results
    return new Promise(resolve => {
      var fetchVoicesInterval = setInterval(() => {
        if (this.synth.getVoices().length !== 0) {
          resolve(this.synth.getVoices());
          clearInterval(fetchVoicesInterval);
        }
      }, 10);
    })
  }

  this.initVoice = async (options = {}) => {
    if (!this.voices) this.voices = await this.getVoices()
    const voiceURI = options.voiceURI || this.options.voiceURI
    this.options.voice = this.voices.find((el) => el.voiceURI === voiceURI);
    // Assign default options
    Object.assign(this.utterance, this.options)
    // Override default options
    if (Object.keys(options).length) Object.assign(this.utterance, options)
  };

  this.say = async (message, options = {}) => {
    await this.initVoice(options)

    this.utterance.text = message
    this.synth.speak(this.utterance);
  }

  this.initVoice()
}
