// app/javascript/controllers/data_method_controller.js
import { Controller } from "@hotwired/stimulus"

export default class DataMethodController extends Controller {
  handleClick(event) {
    const method = this.element.dataset.method;
    if (method) {
      event.preventDefault();
      const form = document.createElement("form");
      form.method = "POST";
      form.action = this.element.getAttribute("href");

      const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
      const methodInput = document.createElement("input");
      methodInput.type = "hidden";
      methodInput.name = "_method";
      methodInput.value = method;

      const csrfInput = document.createElement("input");
      csrfInput.type = "hidden";
      csrfInput.name = "authenticity_token";
      csrfInput.value = csrfToken;

      form.appendChild(methodInput);
      form.appendChild(csrfInput);
      document.body.appendChild(form);
      form.submit();
    }
  }
}
