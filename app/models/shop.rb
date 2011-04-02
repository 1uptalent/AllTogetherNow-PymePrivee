class Shop < ActiveRecord::Base
  belongs_to :user
  
  validates :user, :name, :presence => true
  
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
