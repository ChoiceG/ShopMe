class CheckoutsController < ApplicationController
  # Require the Stripe library to allow interactions with the Stripe API
  require "stripe"

  def create
    # Set the Stripe secret key using environment variable for security
    Stripe.api_key = ENV["stripe_api_key"]

    # Retrieve the cart data from the frontend (sent via JSON)
    cart = params[:cart]

    # Build the line items array to be passed to Stripe
    line_items = cart.map do |item|
      # Find the product in the database by ID (make sure product exists)
      product = Product.find(item["id"])

      # Find the specific stock entry for the selected size of the product
      product_stock = product.stocks.find { |ps| ps.size == item["size"] }

      # Check if the requested quantity exceeds the available stock
      if product_stock.amount < item["quantity"].to_i
        # If not enough stock, return an error response and halt execution
        render json: {
          error: "Not enough stock for #{product.name} in size #{item["size"]}. Only #{product_stock.amount} left."
        }, status: 400
        return
      end

      # Construct the line item in the format Stripe expects
      {
        quantity: item["quantity"].to_i, # Quantity of this product
        price_data: {
          currency: "ngn", # Set currency to Nigerian Naira
          unit_amount: item["price"].to_i * 100, # Convert price from Naira to kobo
          product_data: {
            name: item["name"], # Display name for product in Stripe Checkout
            metadata: {
              product_id: product.id, # Useful metadata for backend processing
              size: item["size"], # Track selected size
              product_stock_id: product_stock.id # Reference specific stock entry
            }
          }
        }
      }
    end

    # Create a new Stripe Checkout session with the prepared line items
    session = Stripe::Checkout::Session.create({
      payment_method_types: [ "card" ], # Allow card payments
      line_items: line_items, # Pass the prepared cart items
      mode: "payment", # Mode can be 'payment', 'setup', or 'subscription'
      success_url: "#{root_url}checkout/success?session_id={CHECKOUT_SESSION_ID}", # Include session ID
      cancel_url: "#{root_url}checkout/cancel", #  Corrected URL
      shipping_address_collection: {
        allowed_countries: [ "NG" ] # Limit shipping address to Nigeria
      }
    })

    # Send the session URL back to the frontend so it can redirect to Stripe
    render json: { url: session.url }
  end
    def success
      flash[:notice] = "Payment was successful! Your order is being processed."
      redirect_to root_path # Or wherever you want to redirect
    end

    def cancel
      flash[:alert] = "Payment was canceled. Please try again."
      redirect_to root_path # Or wherever you want to redirect
    end
end
