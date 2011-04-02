class Shop < ActiveRecord::Base
  belongs_to :user
  has_many :products
  has_many :sale_items
  
  
  validates :user, :name, :presence => true
end
