class SaleItemsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :load_shop
  
  # GET /sale_items
  # GET /sale_items.xml
  def index
    @sale_items = SaleItem.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /sale_items/1
  # GET /sale_items/1.xml
  def show
    @sale_item = SaleItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /sale_items/new
  # GET /sale_items/new.xml
  def new
    @sale_item = SaleItem.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /sale_items/1/edit
  def edit
    @sale_item = SaleItem.find(params[:id])
  end

  # POST /sale_items
  # POST /sale_items.xml
  def create
    @sale_item = SaleItem.new(params[:sale_item])
    @sale_item.shop = @shop
    respond_to do |format|
      if @sale_item.save
        format.html { redirect_to([@shop, @sale_item], :notice => 'Sale item was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /sale_items/1
  # PUT /sale_items/1.xml
  def update
    @sale_item = SaleItem.find(params[:id])

    respond_to do |format|
      if @sale_item.update_attributes(params[:sale_item])
        format.html { redirect_to([@shop, @sale_item], :notice => 'Sale item was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /sale_items/1
  # DELETE /sale_items/1.xml
  def destroy
    @sale_item = SaleItem.find(params[:id])
    @sale_item.destroy

    respond_to do |format|
      format.html { redirect_to(shop_sale_items_url(@shop)) }
    end
  end
end