import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["range", "status"]

  connect() {
    this.updateAllStatuses()
  }

  updateStatus(event) {
    const range = event.target
    const statusElement = this.statusTargets.find(el => el.dataset.statusBarAttribute === range.dataset.attribute)
    statusElement.textContent = this.getStatus(range.value, range.dataset.attribute)
  }

  updateAllStatuses() {
    this.rangeTargets.forEach(range => {
      const statusElement = this.statusTargets.find(el => el.dataset.statusBarAttribute === range.dataset.attribute)
      statusElement.textContent = this.getStatus(range.value, range.dataset.attribute)
    })
  }

  getStatus(value, attribute) {
    const intValue = parseInt(value)
    if (intValue <= 33) {
      return attribute === 'sweetness' ? '控えめ' : 'なめらか'
    } else if (intValue <= 66) {
      return attribute === 'sweetness' ? 'ほどよい' : 'ほどよい'
    } else {
      return attribute === 'sweetness' ? '甘党向け' : 'かため'
    }
  }
}