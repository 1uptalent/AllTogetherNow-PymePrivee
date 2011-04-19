class BundlesController < ApplicationController
  include ActionView::Helpers::JavaScriptHelper
    
  before_filter :authenticate_user!, :except => [:show, :info, :buy]
  before_filter :load_shop, :except => [:add_product, :update_products]
  
  include ActiveMerchant::Billing
  
  # GET /bundles
  # GET /bundles.xml
  def index
    @bundles = @shop.bundles

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /bundles/1
  # GET /bundles/1.xml
  def show
    if params[:id].blank?
      @bundle = @shop.bundles.current
    else
      @bundle = Bundle.find(params[:id])
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json do
        ActionController::Base.asset_host = request.host + ":" + request.port.to_s 
        content = render_to_string(:partial => "sale")
        render :json => " #{params[:callback]}( {
                  shop_name: '#{@shop.name}',
                  html: '#{escape_javascript content}' }
             )"
      end
    end
  end

  def info
    if params[:id].blank?
      @bundle = @shop.bundles.current
    else
      @bundle = Bundle.find(params[:id])
    end
    respond_to do |format|
      format.json do
        @callback_name = params[:callback]
      end
    end
    
  end

  # GET /bundles/new
  # GET /bundles/new.xml
  def new
    @bundle = Bundle.new(:valid_from => Date.today, :valid_until => 7.days.from_now.to_date)

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /bundles/1/edit
  def edit
    @bundle = Bundle.find(params[:id])
  end

  # POST /bundles
  # POST /bundles.xml
  def create
    @bundle = Bundle.new(params[:bundle])
    @bundle.shop = @shop
    respond_to do |format|
      if @bundle.save
        format.html { redirect_to([@shop, @bundle], :notice => 'Sale item was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /bundles/1
  # PUT /bundles/1.xml
  def update
    @bundle = Bundle.find(params[:id])

    respond_to do |format|
      if @bundle.update_attributes(params[:bundle])
        format.html { redirect_to([@shop, @bundle], :notice => 'Sale item was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /bundles/1
  # DELETE /bundles/1.xml
  def destroy
    @bundle = Bundle.find(params[:id])
    @bundle.destroy

    respond_to do |format|
      format.html { redirect_to(shop_bundles_url(@shop)) }
    end
  end
  
  def add_product
    @bundle = Bundle.find(params[:id])
    @products = @bundle.shop.products
  end
  
  def update_products
    @bundle = Bundle.find(params[:id])
    @bundle.product_ids = params[:product_ids]
    if @bundle.save
      redirect_to [@bundle.shop, @bundle]
    else
      render :action => :add_product
    end
  end
  
  def current
    redirect_to [@shop, @shop.bundles.current]
  end

  def buy
    @bundle = Bundle.find(params[:id])
    @payment = Payment.create!(:bundle_id => @bundle.id, 
                               :concept => @bundle.name,
                               :amount => @bundle.price)
    setup_response = gateway.setup_purchase(@payment.activemerchant_amount,
      :name => "PymePrivee", 
      :quantity => 1, 
      :description => @payment.concept,
      :amount      => @payment.amount,
      :ip                => request.remote_ip,
      :return_url        => confirm_payment_url(@payment),
      :cancel_return_url => shop_bundle_url(@bundle.shop, @bundle)
    )
    session[:after_purchase_url] = request.referer 
    redirect_to gateway.redirect_url_for(setup_response.token)
  end

  def all
    @bundles = @shop.bundles
  end

end
