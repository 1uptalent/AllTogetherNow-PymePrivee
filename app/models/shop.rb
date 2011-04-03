class Shop < ActiveRecord::Base
  belongs_to :user
  has_many :products
  has_many :sale_items
  
  
  validates :user, :name, :presence => true
  
  has_attached_file :logo, :styles => { :large => "700x400>", :medium => "250x250>", :thumb => "100x100>" }
  
  def virtual_site?
    !hostname.blank?
  end
end
