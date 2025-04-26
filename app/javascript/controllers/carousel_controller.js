import { Controller } from "@hotwired/stimulus";

export default class CarouselController extends Controller {
  static targets = ["slide"];
  currentIndex = 0;

  connect() {
    this.showSlide(this.currentIndex);
  }

  showSlide(index) {
    this.slideTargets.forEach((el, i) => {
      el.classList.toggle("opacity-100", i === index);
      el.classList.toggle("opacity-0", i !== index);
    });
  }

  next() {
    this.currentIndex = (this.currentIndex + 1) % this.slideTargets.length;
    this.showSlide(this.currentIndex);
  }

  prev() {
    this.currentIndex = (this.currentIndex - 1 + this.slideTargets.length) % this.slideTargets.length;
    this.showSlide(this.currentIndex);
  }
}
