// app/javascript/controllers/testimonial_carousel_controller.js
import { Controller } from "@hotwired/stimulus";

export default class TestimonialCarouselController extends Controller {
  static targets = ["slide"];
  currentIndex = 0;
  visibleCount = 2;

  connect() {
    this.showSlides(this.currentIndex);
  }

  showSlides(startIndex) {
    this.slideTargets.forEach((el, i) => {
      el.classList.toggle("hidden", i < startIndex || i >= startIndex + this.visibleCount);
    });
  }

  next() {
    this.currentIndex += this.visibleCount;
    if (this.currentIndex >= this.slideTargets.length) {
      this.currentIndex = 0;
    }
    this.showSlides(this.currentIndex);
  }

  prev() {
    this.currentIndex -= this.visibleCount;
    if (this.currentIndex < 0) {
      const remainder = this.slideTargets.length % this.visibleCount;
      this.currentIndex = remainder === 0
        ? this.slideTargets.length - this.visibleCount
        : this.slideTargets.length - remainder;
    }
    this.showSlides(this.currentIndex);
  }
}
