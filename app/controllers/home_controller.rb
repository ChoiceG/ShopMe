class HomeController < ApplicationController
  def index
    @main_categories = Category.take(4)
    @testimonials = Testimonial.where(approved: true).order(created_at: :desc)
    @testimonial = Testimonial.new
  end
end
