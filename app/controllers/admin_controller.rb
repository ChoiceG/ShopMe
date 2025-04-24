# class AdminController < ApplicationController
#   layout "admin"
#   before_action :authenticate_admin!
#     def index
#       # fetch las five(5) unfulfilled orders
#       @orders = Order.where(fulfilled: false).order(created_at: :desc).take(5)

#       # add a hash called quick_stats
#       @quick_stats = {
#         sales: Order.where(created_at: Time.now.midnight..Time.now).count,
#         revenue: Order.where(created_at: Time.now.midnight..Time.now).sum(:total).to_f.round,
#         avg_sale: Order.where(created_at: Time.now.midnight..Time.now).average(:total).to_f.round,
#         per_sale: OrderProduct.joins(:order).where(orders: { created_at: Time.now.midnight..Time.now }).average(:quantity).to_f.round
#       }

#       # graph- line chart that shows how much revenue we have made each day for the last seven days
#       @orders_by_day = Order.where("created_at > ?", 7.days.ago).order(:created_at)
#       @orders_by_day = @orders_by_day.group_by { |order| order.created_at.to_date }
#       @revenue_by_day = @orders_by_day.map { |day, orders| [ day.strftime("%A"), orders.sum(&:total) ] }

#       # if no order for one day set to 0
#       if @revenue_by_day.count < 7
#         days_of_week = [ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ]

#         data_hash = @revenue_by_day.to_h
#         current_day = Date.today.strftime("%A")
#         current_day_index = days_of_week.index(current_day)
#         next_day_index = (current_day_index + 1) % days_of_week.length

#         ordered_days_with_current_last = days_of_week [next_day_index..-1] + days_of_week [0...next_day_index]
#         complete_ordered_array_with_current_last = ordered_days_with_current_last.map { |day| [ day, data_hash.fetch(day, 0) ] }

#         @revenue_by_day = complete_ordered_array_with_current_last
#       end
#     end
# end

# class AdminController < ApplicationController
#   layout "admin"
#   before_action :authenticate_admin!

#   def index
#     # fetch last five (5) unfulfilled orders
#     @orders = Order.where(fulfilled: false).order(created_at: :desc).take(5)

#     # add a hash called quick_stats
#     today_start_of_day_utc = Time.zone.now.utc.beginning_of_day
#     today_end_of_day_utc = Time.zone.now.utc.end_of_day

#     @quick_stats = {
#       sales: Order.where(created_at: today_start_of_day_utc..today_end_of_day_utc).count,
#       revenue: Order.where(created_at: today_start_of_day_utc..today_end_of_day_utc).sum(:total).to_f.round,
#       avg_sale: Order.where(created_at: today_start_of_day_utc..today_end_of_day_utc).average(:total).to_f.round,
#       per_sale: OrderProduct.joins(:order).where(orders: { created_at: today_start_of_day_utc..today_end_of_day_utc }).average(:quantity).to_f.round
#     }

#     # graph- line chart that shows how much revenue we have made each day for the last seven days
#     @orders_by_day = Order.where("created_at >= ?", 7.days.ago.beginning_of_day.utc).order(:created_at)
#     @revenue_by_day_grouped = @orders_by_day.group_by { |order| order.created_at.to_date }
#     @revenue_by_day = (6.days.ago.to_date..Date.today).map do |date|
#       [ date.strftime("%A"), @revenue_by_day_grouped.fetch(date, []).sum(&:total).to_f.round ]
#     end
#   end
# end

class AdminController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    # fetch last five (5) unfulfilled orders
    @orders = Order.where(fulfilled: false).order(created_at: :desc).take(5)

    # add a hash called quick_stats
    today_start_of_day_utc = Time.zone.now.utc.beginning_of_day
    today_end_of_day_utc = Time.zone.now.utc.end_of_day

    @quick_stats = {
      sales: Order.where(created_at: today_start_of_day_utc..today_end_of_day_utc).count,
      revenue: Order.where(created_at: today_start_of_day_utc..today_end_of_day_utc).sum("total / 100.0").to_f.round,  # Converting kobo to naira
      avg_sale: Order.where(created_at: today_start_of_day_utc..today_end_of_day_utc).average("total / 100.0").to_f.round,  # Converting kobo to naira
      per_sale: OrderProduct.joins(:order).where(orders: { created_at: today_start_of_day_utc..today_end_of_day_utc }).average(:quantity).to_f.round
    }

    # graph- line chart that shows how much revenue we have made each day for the last seven days
    @orders_by_day = Order.where("created_at >= ?", 7.days.ago.beginning_of_day.utc).order(:created_at)
    @revenue_by_day_grouped = @orders_by_day.group_by { |order| order.created_at.to_date }
    @revenue_by_day = (6.days.ago.to_date..Date.today).map do |date|
      [ date.strftime("%A"), @revenue_by_day_grouped.fetch(date, []).sum { |order| order.total / 100.0 }.to_f.round ] # Converting kobo to naira
    end
  end
end
