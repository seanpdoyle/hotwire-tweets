import { Controller } from "stimulus"

let isPaginatedVisit = false

export default class extends Controller {
  static targets = [ "ignored" ]
  static values = { scrollY: Number }

  connect() {
    if (this.scrollYValue) {
      window.scroll({ top: this.scrollYValue })
    }
  }

  prepareVisit() {
    isPaginatedVisit = true
  }

  preserveScroll() {
    this.scrollYValue = window.scrollY
  }

  injectIntoVisit({ detail }) {
    if (isPaginatedVisit) {
      const elementInNewBody = detail.newBody.querySelector(`[id="${this.element.id}"]`)

      if (elementInNewBody) {
        elementInNewBody.setAttribute(`data-${this.identifier}-scroll-y-value`, this.scrollYValue)
        elementInNewBody.insertAdjacentHTML("afterbegin", this.element.innerHTML)
        elementInNewBody.querySelector(`[data-${this.identifier}-target~="ignored"]`).remove()
      }

      isPaginatedVisit = false
    }
  }
}
