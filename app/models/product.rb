class Product < ActiveRecord::Base
  belongs_to :shop
  
  validates :shop, :presence => true
end
