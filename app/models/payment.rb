class Payment < ActiveRecord::Base
  has_one    :user, :through => :payment_method
  belongs_to :bundle
  
  VALID_STATUSES = %w{user_requested confirmation_pending 
                      user_confirmed user_canceled gateway_confirmed 
                      confirmation_error completion_error}
  
  validates :bundle, :amount, :concept, :status, :presence => true
  validates :status, :inclusion => { :in => VALID_STATUSES }
  
  # Define search methods for every posible status
  VALID_STATUSES.each do |status|
    eval <<-END_OF_EVAL
      def self.#{status}
        where(:status => "#{status}")
      end
    END_OF_EVAL
  end
  
  # Returns the amount in the format required by the activemerchant gem (in cents)
  def activemerchant_amount
    (amount * 100).to_i
  end
end
