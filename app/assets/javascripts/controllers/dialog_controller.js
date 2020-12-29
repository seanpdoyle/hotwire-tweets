import { Controller } from "stimulus"

export default class extends Controller {
  initialize() {
    this.observer = new MutationObserver((mutationList) => {
      for (const { target, type } of mutationList) {
        if (target.tagName == "TURBO-FRAME" && !target.hasAttribute("busy")) {
          this.element.showModal()
        }
      }
    })
  }

  connect() {
    this.observer.observe(this.element, { subtree: true, attributeFilter: [ "busy" ] })
  }

  disconnect() {
    this.observer.disconnect()
  }
}
