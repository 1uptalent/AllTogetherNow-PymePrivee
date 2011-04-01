require 'spec_helper'

describe ShopsController do
  User.delete_all
  user = User.new(:email => "foo@bar.com", :password => "abc123", :password_confirmation => "abc123") { |u| u.save! }
  
  
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
