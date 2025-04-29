class AddUserToOrders < ActiveRecord::Migration[8.0]
  def change
    # add_reference :orders, :user, null: false, foreign_key: true
    add_reference :orders, :user, foreign_key: true # removed `null: false`
  end
end
