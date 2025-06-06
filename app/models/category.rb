class Category < ApplicationRecord
  has_one_attached :image do | attachable |
    attachable.variant :thumbnail, resize_to_limit: [ 100, 100 ]
  end

  has_many :products
end
