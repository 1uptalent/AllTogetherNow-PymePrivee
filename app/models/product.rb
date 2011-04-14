class Product < ActiveRecord::Base
  belongs_to :shop
  
  validates :shop, :presence => true
  
  has_attached_file :picture, 
                    { :styles => { :full => "1024x768#", 
                                   :large => "700x400#", 
                                   :medium => "250x150#", 
                                   :thumb => "50x50#" } }.merge(PAPERCLIP_STORAGE_OPTIONS)
end
