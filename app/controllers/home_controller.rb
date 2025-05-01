class HomeController < ApplicationController
  def index
    @main_categories = Category.take(4)
    @testimonials = Testimonial.where(approved: true).order(created_at: :desc)
    @testimonial = Testimonial.new

    if current_user
      # Safe to access current_user.orders if the user is logged in
      @testimonial = Testimonial.new
      @order = current_user.orders.find_by(fulfilled: true) # Find a fulfilled order
    else
      # If no user is logged in, @order will be nil, and you can handle it accordingly
      @testimonial = Testimonial.new
      @order = nil # No order to fetch if not logged in
    end
  end
end
