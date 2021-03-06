require 'spec_helper'

describe BundlesController do
  

  let(:owner) { mock_model(User, :id => 33) }
  let(:shop) { stub_model(Shop, :id => 13, :user => owner)}
    
  before(:each) do
    owner.stub(:shop => shop)
    Shop.stub(:find).and_return shop
  end
  
  %w{delete post put get}.each do |method|
    class_eval <<-EO_CODE
    def #{method}_with_shop_id(*args)
      args << {} unless args.last.is_a? Hash
      args.last[:shop_id] = shop.id.to_s
      #{method}_without_shop_id(*args)
    end
    alias_method_chain :#{method}, :shop_id
    EO_CODE
  end

  def mock_bundle(stubs={:name => "SIName", :description => "SIDesc", :total_cost => "11.11", :price => "33.33"})
    @mock_bundle ||= mock_model(Bundle, stubs).as_null_object
  end

  describe "when authenticated with the owner" do
    
    before do
      User.stub(:find).and_return(owner)
      sign_in owner
    end

    describe "GET index" do
      let!(:bundles) { [mock_bundle] }
      
      before(:each) do
        shop.should_receive(:bundles).and_return(bundles)
        get :index
      end
      
      it "assigns all bundles as @bundles" do
        assigns(:bundles).should eq([mock_bundle])
      end
      
      it { should assign_to(:shop) }
    end

    describe "GET show" do
      before do
        Bundle.stub(:find).with("37") { mock_bundle }
        get :show, :id => "37"
      end
      
      it "assigns the requested bundle as @bundle" do
        assigns(:bundle).should be(mock_bundle)
      end
      it { should assign_to(:shop) }
    end

    describe "GET new" do
      before do
        Bundle.stub(:new) { mock_bundle }
        get :new
      end
      
      it "assigns a new bundle as @bundle" do
        assigns(:bundle).should be(mock_bundle)
      end
      it { should assign_to(:shop) }
    end

    describe "GET edit" do
      before do
        Bundle.stub(:find).with("37") { mock_bundle }
        get :edit, :id => "37"
      end
      
      it "assigns the requested bundle as @bundle" do
        assigns(:bundle).should be(mock_bundle)
      end
      it { should assign_to(:shop) }
    end

    describe "POST create" do
      it "assigns the shop" do
        mock_bundle.should_receive(:save)
        mock_bundle.should_receive(:shop=)
        Bundle.stub(:new).with({'these' => 'params'}) { mock_bundle }
        post :create, :bundle => {'these' => 'params'}
      end
      
      it "should assign to @shop" do
        Bundle.stub(:new) { mock_bundle(:save => true) }
        post :create, :bundle => {}
        should assign_to(:shop)
      end
    
      describe "with valid params" do
        it "assigns a newly created bundle as @bundle" do
          Bundle.stub(:new).with({'these' => 'params'}) { mock_bundle(:save => true) }
          post :create, :bundle => {'these' => 'params'}
          assigns(:bundle).should be(mock_bundle)
        end

        it "redirects to the created bundle" do
          Bundle.stub(:new) { mock_bundle(:save => true) }
          post :create, :bundle => {}
          response.should redirect_to(shop_bundle_url(shop, mock_bundle))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved bundle as @bundle" do
          Bundle.stub(:new).with({'these' => 'params'}) { mock_bundle(:save => false) }
          post :create, :bundle => {'these' => 'params'}
          assigns(:bundle).should be(mock_bundle)
        end

        it "re-renders the 'new' template" do
          Bundle.stub(:new) { mock_bundle(:save => false) }
          post :create, :bundle => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      it "should assign a shop" do
        Bundle.stub(:find).with("37") { mock_bundle }
        put :update, :id => "37" 
        should assign_to(:shop)
      end
      
      describe "with valid params" do
        it "updates the requested bundle" do
          Bundle.stub(:find).with("37") { mock_bundle }
          mock_bundle.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :bundle => {'these' => 'params'}
        end

        it "assigns the requested bundle as @bundle" do
          Bundle.stub(:find) { mock_bundle(:update_attributes => true) }
          put :update, :id => "1"
          assigns(:bundle).should be(mock_bundle)
        end

        it "redirects to the bundle" do
          Bundle.stub(:find) { mock_bundle(:update_attributes => true) }
          put :update, :id => "1"
          response.should redirect_to(shop_bundle_url(shop, mock_bundle))
        end
      end

      describe "with invalid params" do
        it "assigns the bundle as @bundle" do
          Bundle.stub(:find) { mock_bundle(:update_attributes => false) }
          put :update, :id => "1"
          assigns(:bundle).should be(mock_bundle)
        end

        it "re-renders the 'edit' template" do
          Bundle.stub(:find) { mock_bundle(:update_attributes => false) }
          put :update, :id => "1"
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested bundle" do
        Bundle.stub(:find).with("37") { mock_bundle }
        mock_bundle.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the bundles list" do
        Bundle.stub(:find) { mock_bundle }
        delete :destroy, :id => "1"
        response.should redirect_to(shop_bundles_url(shop.id))
      end
    end
  
    describe "GET add_product" do
      before  do
        Bundle.stub(:find).and_return(mock_bundle)
        @shop=mock(:shop)
        mock_bundle.stub(:shop).and_return(shop)
      end
      
      it "retrieves the avaliable products" do
        shop.should_receive(:products)
        get_without_shop_id :add_product, :id => "1"
      end
      
      it "assigns the list of products" do
        get_without_shop_id :add_product, :id => "1"
        should assign_to :products
      end
    end
    
    describe "POST update_products" do
      before do
        Bundle.stub(:find).and_return(mock_bundle)
        mock_bundle.stub(:shop => shop)
      end
      
      it "should redirect to the shop_bundle url" do
        post_without_shop_id :update_products, :id => "1", :product_ids => %w{1 10 100}
        should redirect_to shop_bundle_path(shop, mock_bundle)
      end
      
      it "should set the products to the selected ones" do
        mock_bundle.should_receive(:product_ids=).with(%w{1 10 100})
        post_without_shop_id :update_products, :id => "1", :product_ids => %w{1 10 100}
      end
    end
  end
end
