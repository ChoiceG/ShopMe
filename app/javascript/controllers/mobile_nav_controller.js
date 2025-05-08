// app/javascript/controllers/mobile_nav_controller.js
import { Controller } from "@hotwired/stimulus"

export default class MobileNavController extends Controller {
  static targets = ["menu"]

  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }
}
