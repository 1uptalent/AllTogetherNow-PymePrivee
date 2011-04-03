require 'spec_helper'

describe ShopsController do
  let(:user) { mock_model(User, :id => 33) }
  
  context "GET: show" do
    
    let(:shop) { stub_model(Shop, :id => 1, :name => "ShopName", :description => "1\n2" ) }
    
    before do
      Shop.stub(:find).with("1").and_return(shop)
      get :show, :id => "1"
    end
    
    it "should be public" do
      should respond_with :ok
    end
    
    context "response" do
      render_views
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
        User.stub(:find).and_return(user)
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
        User.stub(:find).and_return(user)
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
  
  context "GET: edit" do
    let(:owner) { mock_model(User, :id => 55) }
    let(:shop) { stub_model(Shop, :id => 1, :name => "NotMyShop", :description => "1\n2", :user => owner) }

    before do
      Shop.stub(:find).with("1").and_return(shop)
    end

    context "with no authenticated user" do
      before(:each) do
        get :edit, :id => "1"
      end
      
      it { should redirect_to new_user_session_path }
    end
    
    context "with an authenticated user who is not the owner" do
      before(:each) do
        User.stub(:find).and_return(user)
        sign_in user
        get :edit, :id => "1"
      end
      it { should respond_with :forbidden }
    end
    
    context "with the owner as authenticated user" do
      before(:each) do
        User.stub(:find).and_return(owner)
        sign_in owner
        get :edit, :id => "1"
      end

      it { should respond_with :ok }
      
      it "should edit the correct shop" do
        assigns(:shop).should be(shop)
      end

      it "should render the edit form" do
        response.should render_template("new")
      end
      
    end
    
  end
  
  context "PUT: update" do
    context "with no authenticated user" do
      before(:each) do
        put :update, :id => "3"
      end
      
      it { should redirect_to new_user_session_path }
    end

    context "with an authenticated user" do
      let(:shop) { stub_model(Shop, :id => 3, :user => user, :name => "old name") }
      
      before(:each) do
        User.stub(:find).and_return(user)
        Shop.stub(:find).with("3").and_return(shop)
        sign_in user
      end
      context "with valid params" do
        before do
          shop.stub(:save).and_return(true)
          put :update, :id => "3", :shop=> {:name => "new name"}
        end
        it { should redirect_to shop_path(assigns(:shop)) }
        it "should update the name" do
          assigns(:shop).name.should == "new name"
        end
      end
      context "with invalid params" do
        before do
          shop.stub(:save).and_return(false)
          put :update, :id => "3", :shop=> {:name => ""}
        end
        it { response.should render_template("new") }
      end
    end
  end
  
end
