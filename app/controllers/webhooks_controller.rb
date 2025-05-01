# class WebhooksController < ApplicationController
#   skip_forgery_protection

#   def stripe
#     puts "✅ Webhook received!"

#     Stripe.api_key = ENV["stripe_api_key"]
#     payload = request.body.read
#     sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
#     endpoint_secret = ENV["stripe_webhooks_secret"]

#     begin
#       event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
#     rescue JSON::ParserError => e
#       puts "❌ JSON parse error: #{e.message}"
#       return head :bad_request
#     rescue Stripe::SignatureVerificationError => e
#       puts "❌ Signature verification failed: #{e.message}"
#       return head :bad_request
#     end

#     case event.type
#     when "checkout.session.completed"
#       session = event.data.object

#       shipping_details = session["shipping_details"]
#       puts "Session: #{session}"

#       if shipping_details
#         address = "#{shipping_details['address']['line1']},
#                    #{shipping_details['address']['city']},
#                    #{shipping_details['address']['state']},
#                    #{shipping_details["address"]["postal_code"]}"
#       else
#         address = ""
#       end

#       begin
#         order = Order.create!(
#           customer_email: session["customer_details"]["email"],
#           total: session["amount_total"],
#           address: address,
#           fulfilled: false
#         )

#         full_session = Stripe::Checkout::Session.retrieve({
#           id: session.id,
#           expand: [ "line_items" ]
#         })

#         line_items = full_session.line_items
#         line_items["data"].each do |item|
#           product = Stripe::Product.retrieve(item["price"]["product"])
#           metadata = product["metadata"] || {}

#           # Debugging the metadata
#           puts "🧾 Product metadata: #{metadata.inspect}"

#           product_id = metadata["product_id"].to_i
#           product_stock_id = metadata["product_stock_id"]

#           if product_id.zero? || !Product.exists?(product_id)
#             puts "⚠️ Skipping item: Invalid or missing product_id in metadata."
#             next
#           end

#           # Create OrderProduct association
#           OrderProduct.create!(
#             order: order,
#             product_id: product_id,
#             quantity: item["quantity"],
#             size: metadata["size"]
#           )

#           # Decrease stock based on the product_stock_id
#           if product_stock_id && Stock.exists?(product_stock_id)
#             Stock.find(product_stock_id).decrement!(:amount, item["quantity"])
#           else
#             puts "⚠️ Skipping stock decrement: Invalid or missing product_stock_id"
#           end
#         end

#       rescue StandardError => e
#         puts "❌ Error creating order or processing items: #{e.message}"
#         return head :internal_server_error
#       end

#     else
#       puts "🔸 Unhandled event type: #{event.type}"
#     end

#     render json: { message: "success" }, status: :ok
#   end
# end

class WebhooksController < ApplicationController
  skip_forgery_protection

  def stripe
    puts "✅ Webhook received!"

    Stripe.api_key = ENV["stripe_api_key"]
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = ENV["stripe_webhooks_secret"]

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      puts "❌ JSON parse error: #{e.message}"
      return head :bad_request
    rescue Stripe::SignatureVerificationError => e
      puts "❌ Signature verification failed: #{e.message}"
      return head :bad_request
    end

    case event.type
    when "checkout.session.completed"
      session = event.data.object

      # Ensure we have customer email and try to find the user
      customer_email = session["customer_details"]["email"]

      if customer_email
        user = User.find_by(email: customer_email)
      end

      # Fallback if user is not found
      user ||= User.find_or_create_by(email: customer_email)

      shipping_details = session["shipping_details"]
      puts "Session: #{session}"

      if shipping_details
        address = "#{shipping_details['address']['line1']},
                   #{shipping_details['address']['city']},
                   #{shipping_details['address']['state']},
                   #{shipping_details['address']['postal_code']}"
      else
        address = ""
      end

      # Create Order with associated user
      begin
        order = Order.create!(
          user: user,  # Link the order to the user
          customer_email: session["customer_details"]["email"],
          total: session.amount_total / 100, # Convert kobo to naira
          address: address,
          fulfilled: false
        )

        # Retrieve full session with line items
        full_session = Stripe::Checkout::Session.retrieve({
          id: session.id,
          expand: [ "line_items" ]
        })

        line_items = full_session.line_items
        line_items["data"].each do |item|
          product = Stripe::Product.retrieve(item["price"]["product"])
          metadata = product["metadata"] || {}

          # Debugging the metadata
          puts "🧾 Product metadata: #{metadata.inspect}"

          product_id = metadata["product_id"].to_i
          product_stock_id = metadata["product_stock_id"]

          if product_id.zero? || !Product.exists?(product_id)
            puts "⚠️ Skipping item: Invalid or missing product_id in metadata."
            next
          end

          # Extract the price information from the Stripe item
          price = item["price"]["unit_amount"] # This should be the correct value for price

          # Create OrderProduct association
          OrderProduct.create!(
            order: order,
            product_id: product_id,
            quantity: item["quantity"],
            size: metadata["size"],
            price: price # Ensure price is populated
          )

          # Decrease stock based on the product_stock_id
          if product_stock_id && Stock.exists?(product_stock_id)
            Stock.find(product_stock_id).decrement!(:amount, item["quantity"])
          else
            puts "⚠️ Skipping stock decrement: Invalid or missing product_stock_id"
          end
        end
      rescue StandardError => e
        puts "❌ Error creating order or processing items: #{e.message}"
        return head :internal_server_error
      end
    else
      puts "🔸 Unhandled event type: #{event.type}"
    end

    render json: { message: "success" }, status: :ok
  end
end
