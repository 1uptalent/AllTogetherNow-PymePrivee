class BundleProduct < ActiveRecord::Base
  belongs_to :bundle
  belongs_to :product
  
  validates :bundle, :product, :presence => true
end
