import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab"]

  connect() {
    this.updateActiveTab()
    document.addEventListener('turbo:load', this.updateActiveTab.bind(this))
  }

  updateActiveTab() {
    const currentPath = window.location.pathname
    this.tabTargets.forEach(tab => {
      const tabPath = tab.getAttribute('href')
      if (currentPath === tabPath) {
        this.activateTab(tab)
      } else {
        this.deactivateTab(tab)
      }
    })
  }

  switchTab(event) {
    event.preventDefault()
    const clickedTab = event.currentTarget
    this.tabTargets.forEach(tab => {
      if (tab === clickedTab) {
        this.activateTab(tab)
      } else {
        this.deactivateTab(tab)
      }
    })
    // フレーム内のコンテンツのみを更新
    const frame = document.getElementById('mypage_content')
    frame.src = clickedTab.getAttribute('href')
  }

  activateTab(tab) {
    tab.classList.remove('text-placeholder', 'border-placeholder', 'hover:text-neutral', 'hover:border-accent')
    tab.classList.add('text-neutral', 'border-accent', 'tab-active', '!border-accent')
  }

  deactivateTab(tab) {
    tab.classList.remove('text-neutral', 'border-accent', 'tab-active', '!border-accent')
    tab.classList.add('text-placeholder', 'border-placeholder', 'hover:text-neutral', 'hover:border-accent')
  }
}