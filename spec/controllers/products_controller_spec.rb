require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe ProductsController do

  let(:owner) { mock_model(User, :id => 33) }
  let(:shop)  { mock_model(Shop, :id => 3, :user => owner) }
  
  before do
    owner.stub(:shop => shop)
    Shop.stub(:find).with("3").and_return(shop)
  end

  def mock_product(stubs={ :name => "PName", :description => "PDesc", :cost => 123.45, :tax => 99.99})
    @mock_product ||= mock_model(Product, stubs).as_null_object
  end

  describe "when authenticated is not the owner" do
    let(:other_user) { mock_model(User, :id => 55, :shop => mock_model(Shop)) } 
    before do
      User.stub(:find).and_return(other_user)
      sign_in other_user
    end
    
    it "should not allow to edit the product" do
      Product.stub(:find).with("37") { mock_model(Product) }
      get :edit, :shop_id => "3", :id => "37"
      should respond_with :forbidden
      
    end
    
  end

  describe "when authenticated" do
    
    before do
      User.stub(:find).and_return(owner)
      sign_in owner
    end
    
    describe "GET index" do
      it "assigns all products as @products" do
        other_product = mock_product(:name => "OPName", :description => "OPDesc", :cost => 623.45, :tax => 1.1)
        Product.stub(:all) { [mock_product, other_product] }
        products = mock("products", :all => [mock_product])
        Product.stub(:where).with(:shop_id => 3) { products }
        get :index, :shop_id => "3"
        assigns(:products).should eq([mock_product])
      end
    end

    describe "GET show" do
      it "assigns the requested product as @product" do
        Product.stub(:find).with("37") { mock_product }
        get :show, :id => "37", :shop_id => "3"
        assigns(:product).should be(mock_product)
      end
    end

    describe "GET new" do
      it "assigns a new product as @product" do
        Product.stub(:new) { mock_product }
        get :new, :shop_id => "3"
        assigns(:product).should be(mock_product)
      end
    end

    describe "GET edit" do
      it "assigns the requested product as @product" do
        Product.stub(:find).with("37") { mock_product }
        get :edit, :shop_id => "3", :id => "37"
        assigns(:product).should be(mock_product)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "assigns a newly created product as @product" do
          Product.stub(:new).with({'these' => 'params'}) { mock_product(:save => true) }
          post :create, :shop_id => "3", :product => {'these' => 'params'}
          assigns(:product).should be(mock_product)
        end

        it "redirects to the created product" do
          Product.stub(:new) { mock_product(:save => true) }
          post :create, :shop_id => "3", :product => {}
          response.should redirect_to(shop_product_url(shop, mock_product))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved product as @product" do
          Product.stub(:new).with({'these' => 'params'}) { mock_product(:save => false) }
          post :create, :shop_id => "3", :product => {'these' => 'params'}
          assigns(:product).should be(mock_product)
        end

        it "re-renders the 'new' template" do
          Product.stub(:new) { mock_product(:save => false) }
          post :create, :shop_id => "3", :product => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested product" do
          Product.stub(:find).with("37") { mock_product }
          mock_product.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :shop_id => "3", :product => {'these' => 'params'}
        end

        it "assigns the requested product as @product" do
          Product.stub(:find) { mock_product(:update_attributes => true) }
          put :update, :id => "1", :shop_id => "3"
          assigns(:product).should be(mock_product)
        end

        it "redirects to the product" do
          Product.stub(:find) { mock_product(:update_attributes => true) }
          put :update, :id => "1", :shop_id => "3"
          response.should redirect_to(shop_product_url(shop, mock_product))
        end
      end

      describe "with invalid params" do
        it "assigns the product as @product" do
          Product.stub(:find) { mock_product(:update_attributes => false) }
          put :update, :id => "1", :shop_id => "3"
          assigns(:product).should be(mock_product)
        end

        it "re-renders the 'edit' template" do
          Product.stub(:find) { mock_product(:update_attributes => false) }
          put :update, :id => "1", :shop_id => "3"
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested product" do
        Product.stub(:find).with("37") { mock_product }
        mock_product.should_receive(:destroy)
        delete :destroy, :id => "37", :shop_id => "3"
      end

      it "redirects to the products list" do
        Product.stub(:find) { mock_product }
        delete :destroy, :id => "1", :shop_id => "3"
        response.should redirect_to(shop_products_url(shop))
      end
    end
  end
end
