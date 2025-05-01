class AddPriceToOrderProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :order_products, :price, :decimal
  end
end
