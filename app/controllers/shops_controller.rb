class ShopsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show, :by_hostname, :sales]
  before_filter :load_shop, :except => [:new, :create, :my_shop, :by_hostname]
  before_filter :user_must_be_owner, :except => [:new, :create, :show, :my_shop, :by_hostname, :sales]
  
  def show
  end

  def my_shop
    @shop = current_user.shop
    redirect_to new_shop_path and return if @shop.nil?
    render :show
  end
  
  def by_hostname
    @shop = Shop.find_by_hostname(request.host)
    render :show, :layout => 'virtual_1'
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
