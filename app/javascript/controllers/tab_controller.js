import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "frame"]

  connect() {
    this.updateActiveTab()
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
    tab.classList.add('tab-active', 'text-white', 'bg-accent')
    tab.classList.remove('hover:tab-active')
  }

  deactivateTab(tab) {
    tab.classList.remove('tab-active', 'text-white', 'bg-accent')
    tab.classList.add('hover:tab-active')
  }
}