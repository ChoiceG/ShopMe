class User < ApplicationRecord
  has_many :orders
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # You can optionally add validations here
  validates :name, presence: true

  # Check if user has completed orders
  def has_completed_orders?
    orders.completed.exists? # Using the completed scope here
  end
end
