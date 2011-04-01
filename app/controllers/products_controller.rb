class ProductsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :load_shop
  before_filter :user_must_be_owner
  before_filter :load_product, :except => [:index, :new, :create]
  
  # GET /products
  # GET /products.xml
  def index
    @products = Product.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to([@shop, @product], :notice => 'Product was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to([@shop, @product], :notice => 'Product was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(shop_products_url(@shop)) }
    end
  end
  
  protected
  
  def user_must_be_owner
    raise User::Forbidden unless current_user == @shop.owner
  end
  
  def load_shop
    @shop = Shop.find(params[:shop_id])
  end
  
  def load_product
    @product = Product.find(params[:id])
  end
end
