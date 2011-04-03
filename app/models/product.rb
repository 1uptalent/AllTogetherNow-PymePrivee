class Product < ActiveRecord::Base
  belongs_to :shop
  
  validates :shop, :presence => true
  
  has_attached_file :picture, 
                    :styles => { :full => "900x400#", 
                                 :large => "700x400#", 
                                 :medium => "250x250#", 
                                 :thumb => "50x50#" }
end
