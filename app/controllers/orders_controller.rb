class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end
  
  def receipt
    @order = Order.find(params[:id])
    @expected_delivery = @order.created_at + 5.days
  end
end
