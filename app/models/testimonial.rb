class Testimonial < ApplicationRecord
  belongs_to :user
  belongs_to :order

  validates :name, presence: true
  validates :content, presence: true
end
