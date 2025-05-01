class OrderProduct < ApplicationRecord
  belongs_to :product
  belongs_to :order

  # Add price attribute if it's missing
  validates :price, presence: true
end
