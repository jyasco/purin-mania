import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["range", "statusText"]

  connect() {
    this.rangeTargets.forEach(range => this.updateStatus({ target: range }))
  }

  updateStatus(event) {
    const range = event.target
    const value = parseInt(range.value)
    const attribute = range.dataset.attribute

    this.statusTextTargets.forEach(statusText => {
      if (statusText.dataset.attribute !== attribute) return

      const status = statusText.dataset.status
      let scale = 0.9
      let opacity = 0.5

      if ((status === 'mild' && value <= 33) ||
          (status === 'smooth' && value <= 33) ||
          (status === 'medium_sweet' && value > 33 && value <= 66) ||
          (status === 'medium_firm' && value > 33 && value <= 66) ||
          (status === 'sweet' && value > 66) ||
          (status === 'firm' && value > 66)) {
        scale = 1.1
        opacity = 1
      } else if ((status === 'mild' && value <= 66) ||
                 (status === 'smooth' && value <= 66) ||
                 (status === 'sweet' && value > 33) ||
                 (status === 'firm' && value > 33)) {
        scale = 0.9
        opacity = 0.7
      }

      statusText.style.transform = `scale(${scale})`
      statusText.style.opacity = opacity
    })
  }
}