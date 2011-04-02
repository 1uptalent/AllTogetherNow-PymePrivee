class SaleItem < ActiveRecord::Base
  belongs_to :shop
  has_many :products
  validates :shop, :presence => true
  
  def image
    shop.logo
  end
end
