class Testimonial < ApplicationRecord
  validates :name, presence: true
  validates :content, presence: true
end
