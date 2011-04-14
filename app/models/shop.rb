class Shop < ActiveRecord::Base
  belongs_to :user
  has_many :products
  has_many :sale_items
  
  
  validates :user, :name, :presence => true
  
  has_attached_file :logo, 
                    { :styles => { :full => "1024x768#", 
                                   :large => "700x400#", 
                                   :medium => "250x150#", 
                                   :thumb => "50x50#" } }.merge(PAPERCLIP_STORAGE_OPTIONS)
  def virtual_site?
    !hostname.blank?
  end
end
