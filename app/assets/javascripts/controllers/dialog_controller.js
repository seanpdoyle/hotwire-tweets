import dialogPolyfill from "https://cdn.skypack.dev/dialog-polyfill"
import wicgInert from "https://cdn.skypack.dev/wicg-inert"
import { Controller } from "stimulus"

export default class extends Controller {
  initialize() {
    dialogPolyfill.registerDialog(this.element)
  }

  showModal() {
    this.trapFocus()
    this.element.showModal()
  }

  trapFocus = () => {
    this.siblingElements.forEach(element => element.inert = true)
    this.element.addEventListener("close", this.releaseFocus, { once: true })
  }

  releaseFocus = () => {
    this.siblingElements.forEach(element => element.inert = false)
  }

  get siblingElements() {
    return [ ...this.element.parentElement.children ].filter(element => element != this.element)
  }
}
