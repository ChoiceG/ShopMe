class Admin::TestimonialsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @testimonials = Testimonial.all
  end

  def approve
    @testimonial = Testimonial.find(params[:id])
    
    if @testimonial.update(approved: true)
      # If the action is successful, redirect to the testimonials index
      redirect_to admin_testimonials_path, notice: 'Testimonial approved successfully.'
    else
      # If the update fails, redirect with an error message
      redirect_to admin_testimonials_path, alert: 'Failed to approve testimonial.'
    end
  end
end
