class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from 'User::Forbidden' do
    render :text => "forbidden", :status => :forbidden
  end
  
  before_filter :ensure_user_has_shop
  
  #
  # Helpers for laoding parent models
  def load_shop
    @shop = Shop.find(params[:shop_id])
  end
  
  protected
  
  def ensure_user_has_shop
    if user_signed_in? && current_user.shop.nil?
      redirect_to new_shop_url and return false
    end
  end
  
end
