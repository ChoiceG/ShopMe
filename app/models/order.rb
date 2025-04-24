class Order < ApplicationRecord
  has_many :order_products
  accepts_nested_attributes_for :order_products, reject_if: :all_blank, allow_destroy: true

  def total_in_naira
    total / 100.0 if total.present?
  end
end
