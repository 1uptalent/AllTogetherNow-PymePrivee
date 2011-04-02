class SaleItem < ActiveRecord::Base
  belongs_to :shop
  has_many  :products
  validates :shop, :valid_from, :valid_until, :presence => true
  # TODO: Validate date_from <= date_until
  # TODO: Validate date_from now or future
  
  def image
    shop.logo
  end

  def self.current(date=Date.today)
    where("valid_from <= :now and valid_until > :now", :now => date.to_date).first
  end
end
