class SaleItem < ActiveRecord::Base
  belongs_to :shop
  has_many  :products
  validates :shop, :name, :description, :price, :valid_from, :valid_until, :presence => true
  
  attr_readonly :total_cost
  
  # TODO: Validate date_from <= date_until
  # TODO: Validate date_from now or future
  
  def image
    @image ||= products.first.picture || shop.logo
  end

  def current?
    now = Time.now
    valid_from.to_time <= now && now < valid_until.to_time
  end

  def self.current(date=Date.today)
    where("valid_from <= :now and valid_until > :now", :now => date.to_date).first
  end
end
