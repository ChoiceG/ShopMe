import { Controller } from "@hotwired/stimulus";

export default class DropDownController extends Controller {
  static targets = ["content"];

  toggle() {
    this.contentTarget.classList.toggle("hidden");
  }
}
