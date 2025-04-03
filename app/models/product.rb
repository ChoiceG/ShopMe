class Product < ApplicationRecord
  belongs_to :category

  has_many_attached :images do | attachable |
    attachable.variant :thumbnail, resize_to_limit: [ 100, 100 ]
  end

  has_many :stocks
end
