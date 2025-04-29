class TestimonialsController < ApplicationController
  def new
    @testimonial = Testimonial.new
  end

  def create
    Rails.logger.info "Testimonial creation started."

    # Log the incoming parameters for the testimonial
    Rails.logger.info "Received testimonial params: #{testimonial_params.inspect}"

    @testimonial = Testimonial.new(testimonial_params)
    @testimonial.approved = false # Default to unapproved

    # Log the status of the new testimonial object
    Rails.logger.info "Created testimonial object: #{@testimonial.inspect}"

    if @testimonial.save
      # Log success
      Rails.logger.info "Testimonial saved successfully with ID: #{@testimonial.id}"

      redirect_to root_path, notice: "Thank you! Your testimonial is pending approval."
    else
      # Log validation errors if save fails
      Rails.logger.error "Failed to save testimonial. Errors: #{@testimonial.errors.full_messages.join(", ")}"

      render :new
    end
  end

  private

  def testimonial_params
    params.require(:testimonial).permit(:name, :content)
  end
end
