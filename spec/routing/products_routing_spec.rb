require "spec_helper"

describe ProductsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/shops/11/products" }.should route_to(:controller => "products", :action => "index", :shop_id => "11")
    end

    it "recognizes and generates #new" do
      { :get => "/shops/11/products/new" }.should route_to(:controller => "products", :action => "new", :shop_id => "11")
    end

    it "recognizes and generates #show" do
      { :get => "/shops/11/products/1" }.should route_to(:controller => "products", :action => "show", :id => "1", :shop_id => "11")
    end

    it "recognizes and generates #edit" do
      { :get => "/shops/11/products/1/edit" }.should route_to(:controller => "products", :action => "edit", :id => "1", :shop_id => "11")
    end

    it "recognizes and generates #create" do
      { :post => "/shops/11/products" }.should route_to(:controller => "products", :action => "create", :shop_id => "11")
    end

    it "recognizes and generates #update" do
      { :put => "/shops/11/products/1" }.should route_to(:controller => "products", :action => "update", :id => "1", :shop_id => "11")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/shops/11/products/1" }.should route_to(:controller => "products", :action => "destroy", :id => "1", :shop_id => "11")
    end

  end
end
