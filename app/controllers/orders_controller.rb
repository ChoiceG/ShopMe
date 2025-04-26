class OrdersController < ApplicationController
  def receipt
    @order = Order.find(params[:id])
    @expected_delivery = @order.created_at + 5.days
  end
end
