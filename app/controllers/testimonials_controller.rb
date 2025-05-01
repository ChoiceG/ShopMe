# class TestimonialsController < ApplicationController
#   def new
#     @testimonial = Testimonial.new
#   end

#   def create
#     Rails.logger.info "Testimonial creation started."

#     # Log the incoming parameters for the testimonial
#     Rails.logger.info "Received testimonial params: #{testimonial_params.inspect}"

#     @testimonial = Testimonial.new(testimonial_params)
#     @testimonial.approved = false # Default to unapproved

#     # Log the status of the new testimonial object
#     Rails.logger.info "Created testimonial object: #{@testimonial.inspect}"

#     if @testimonial.save
#       # Log success
#       Rails.logger.info "Testimonial saved successfully with ID: #{@testimonial.id}"

#       redirect_to root_path, notice: "Thank you! Your testimonial is pending approval."
#     else
#       # Log validation errors if save fails
#       Rails.logger.error "Failed to save testimonial. Errors: #{@testimonial.errors.full_messages.join(", ")}"

#       render :new
#     end
#   end

#   private

#   def testimonial_params
#     params.require(:testimonial).permit(:name, :content)
#   end
# end


# # MUST HAVE AN APPROVED ORDER TO LEAVE A TESTIMONIAL REVIEW
# class TestimonialsController < ApplicationController
#   before_action :authorize_testimonial_access, only: [ :new, :create ]

#   def new
#     @testimonial = Testimonial.new
#   end

#   def create
#     Rails.logger.info "Testimonial creation started."

#     # Log the incoming parameters for the testimonial
#     Rails.logger.info "Received testimonial params: #{testimonial_params.inspect}"

#     # Ensure the user has at least one completed order
#     if current_user.orders.completed.exists?
#       @testimonial = Testimonial.new(testimonial_params)
#       @testimonial.approved = false # Default to unapproved

#       # Log the status of the new testimonial object
#       Rails.logger.info "Created testimonial object: #{@testimonial.inspect}"

#       if @testimonial.save
#         # Log success
#         Rails.logger.info "Testimonial saved successfully with ID: #{@testimonial.id}"

#         redirect_to root_path, notice: "Thank you! Your testimonial is pending approval."
#       else
#         # Log validation errors if save fails
#         Rails.logger.error "Failed to save testimonial. Errors: #{@testimonial.errors.full_messages.join(", ")}"

#         render :new
#       end
#     else
#       # If the user doesn't have a completed order, we prevent them from submitting a testimonial
#       redirect_to root_path, alert: "You must have a completed order to leave a testimonial."
#     end
#   end

#   private

#   def testimonial_params
#     params.require(:testimonial).permit(:name, :content)
#   end

#   # A method to ensure that only users with completed orders can create testimonials
#   def authorize_testimonial_access
#     unless current_user && current_user.orders.completed.exists?
#       redirect_to root_path, alert: "You must be logged in and have a completed order to leave a testimonial."
#     end
#   end
# end

class TestimonialsController < ApplicationController
  before_action :authorize_testimonial_access, only: [ :new, :create ]

  def new
    @order = Order.find(params[:order_id])  # Find the order for which the testimonial is being created
    @testimonial = Testimonial.new(order: @order) # Associate the testimonial with the order
  end

  # def create
  #   Rails.logger.info "Testimonial creation started."

  #   # Log the incoming parameters for the testimonial
  #   Rails.logger.info "Received testimonial params: #{testimonial_params.inspect}"

  #   # Ensure the user has at least one fulfilled order
  #   @order = Order.find(params[:order_id])

  #   if @order.fulfilled? && @order.user == current_user
  #     @testimonial = Testimonial.new(testimonial_params)
  #     @testimonial.user = current_user
  #     @testimonial.order = @order
  #     @testimonial.approved = false  # Default to unapproved

  #     # Log the status of the new testimonial object
  #     Rails.logger.info "Created testimonial object: #{@testimonial.inspect}"

  #     if @testimonial.save
  #       # Log success
  #       Rails.logger.info "Testimonial saved successfully with ID: #{@testimonial.id}"

  #       redirect_to root_path, notice: "Thank you! Your testimonial is pending approval."
  #     else
  #       # Log validation errors if save fails
  #       Rails.logger.error "Failed to save testimonial. Errors: #{@testimonial.errors.full_messages.join(", ")}"

  #       render :new
  #     end
  #   else
  #     # If the order is not fulfilled or the order doesn't belong to the current user
  #     redirect_to root_path, alert: "You must have a fulfilled order to leave a testimonial."
  #   end
  # end

  # def create
  #   Rails.logger.info "Testimonial creation started."
  #   Rails.logger.info "Received testimonial params: #{testimonial_params.inspect}"

  #   # Ensure the user has at least one completed order
  #   if current_user.orders.where(fulfilled: true).exists?
  #     @order = current_user.orders.where(fulfilled: true).first  # Assuming you're getting a fulfilled order
  #     @testimonial = Testimonial.new(testimonial_params)

  #     @testimonial.user = current_user  # Associate the current user
  #     @testimonial.order = @order      # Associate the order
  #     @testimonial.approved = false    # Default to unapproved

  #     if @testimonial.save
  #       Rails.logger.info "Testimonial saved successfully with ID: #{@testimonial.id}"
  #       redirect_to root_path, notice: "Thank you! Your testimonial is pending approval."
  #     else
  #       Rails.logger.error "Failed to save testimonial. Errors: #{@testimonial.errors.full_messages.join(", ")}"
  #       render :new
  #     end
  #   else
  #     redirect_to root_path, alert: "You must have a completed order to leave a testimonial."
  #   end
  # end

  def create
    @order = Order.find(params[:order_id]) # Assuming you're passing order_id as a parameter
    @testimonial = Testimonial.new(testimonial_params)
    @testimonial.user = current_user    # Associate the current user
    @testimonial.order = @order        # Associate the order
    @testimonial.approved = false      # Default to unapproved

    if @testimonial.save
      redirect_to root_path, notice: "Thank you! Your testimonial is pending approval."
    else
      render :new
    end
  end


  private

  def testimonial_params
    params.require(:testimonial).permit(:name, :content, :order_id)
  end

  # A method to ensure that only users with fulfilled orders can create testimonials
  def authorize_testimonial_access
    unless current_user && current_user.orders.where(fulfilled: true).exists?
      redirect_to root_path, alert: "You must be logged in and have a fulfilled order to leave a testimonial."
    end
  end
end
