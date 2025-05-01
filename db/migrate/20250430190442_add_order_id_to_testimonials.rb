class AddOrderIdToTestimonials < ActiveRecord::Migration[8.0]
  def change
    add_reference :testimonials, :order, null: true, foreign_key: true
  end
end
