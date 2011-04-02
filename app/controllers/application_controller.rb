class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from 'User::Forbidden' do
    render :text => "forbidden", :status => :forbidden
  end
  
  #
  # Helpers for laoding parent models
  def load_shop
    @shop = Shop.find(params[:shop_id])
  end
  
end
