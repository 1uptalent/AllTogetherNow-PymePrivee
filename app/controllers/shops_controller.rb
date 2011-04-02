class ShopsController < ApplicationController
  
  before_filter :authenticate_user!, :except => :show
  before_filter :load_shop, :except => [:new, :create]
  before_filter :user_must_be_owner, :except => [:new, :create]
  
  def show
  end
  
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
  
  def edit
    render :new
  end
  
  def update
    @shop.update_attributes(params[:shop])
    if @shop.save
      redirect_to shop_path(@shop)
    else
      render :new
    end
  end
  
  protected

  def load_shop
    @shop = Shop.find(params[:id])
  end
  
  def user_must_be_owner
    raise User::Forbidden unless current_user == @shop.user
  end
  
end
