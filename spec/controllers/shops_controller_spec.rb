require 'spec_helper'

describe ShopsController do
  User.delete_all
  user = User.new(:email => "foo@bar.com", :password => "abc123", :password_confirmation => "abc123") { |u| u.save! }
  
  context "GET: show" do
    
    let(:shop) { stub_model(Shop, :id => 1, :name => "ShopName", :description => "1\n2") }
    
    before do
      Shop.stub(:find).with("1").and_return(shop)
      get :show, :id => "1"
    end
    
    it "should be public" do
      should respond_with :ok
    end
    
    context "response" do
      subject { response.body }
      
      it "should display the name" do
        should match "ShopName"
      end
    
      it "should format the description" do
        should match %r{<p>1</p>.*<p>2</p>}m
      end
    end
  end
  
  context "GET: new" do
    
    context "with no authenticated user" do
      before(:each) do
        get :new
      end
      
      it { should redirect_to new_user_session_path }
    end
    
    context "with an authenticated user" do
      before(:each) do
        sign_in user
        get :new
      end
      it { should respond_with :ok }
      it { should assign_to(:shop) }
    end
  end
  
  context "POST: create" do
    context "with no authenticated user" do
      before(:each) do
        post :create
      end
      
      it { should redirect_to new_user_session_path }
    end

    context "with an authenticated user" do
      let(:name) { "nombre negocio" }
      before(:each) do
        sign_in user
        post :create, :shop=> {:name => name}
      end
      it { should redirect_to shop_path(assigns(:shop)) }
      it "should belong to current user" do
        assigns(:shop).user.should == user
      end
      it "should have the name" do
        assigns(:shop).name.should == name
      end
      it "should create a shop" do
        expect { post :create, :shop => { :name => "foo"} }.to change { Shop.count }.by(1)
      end
    end
  end
end
