class AddUserIdToTestimonials < ActiveRecord::Migration[8.0]
  def change
    add_reference :testimonials, :user, foreign_key: true, null: true
  end
end
