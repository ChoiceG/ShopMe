# class Order < ApplicationRecord
#   belongs_to :user
#   has_many :order_products
#   accepts_nested_attributes_for :order_products, reject_if: :all_blank, allow_destroy: true

#   def total_in_naira
#     total / 100.0 if total.present?
#   end
# end

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products
  accepts_nested_attributes_for :order_products, reject_if: :all_blank, allow_destroy: true

  # Add a completed scope
  scope :completed, -> { where(status: :completed) }

  def display_total
    total.to_f if total.present?
  end

  private

  def set_default_values
    self.fulfilled ||= false
  end
end
