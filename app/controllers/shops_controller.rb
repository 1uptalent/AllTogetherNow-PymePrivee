class ShopsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def new
    @shop = Shop.new
  end
  
  def create
    @shop = Shop.new(params[:shop])
    @shop.user = current_user
    if @shop.save
      redirect_to shop_path(@shop)
    else
      render :new
    end
  end
end
