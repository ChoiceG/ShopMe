class Order < ApplicationRecord
  has_many :order_products
  accepts_nested_attributes_for :order_products, reject_if: :all_blank, allow_destroy: true
end
