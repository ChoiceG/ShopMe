import { Controller } from "@hotwired/stimulus"

export default class AlertController extends Controller {
  static targets = ["flash-container", "alert"]

  connect() {
    this.dismissAfterDelay()
  }

  dismissAfterDelay() {
    this.alertTargets.forEach((alert) => {
      setTimeout(() => {
        alert.remove()
      }, 4000)
    })
  }
}
