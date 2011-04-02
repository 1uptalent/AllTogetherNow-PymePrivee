require "spec_helper"

describe SaleItemsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/shops/13/sale_items" }.should route_to(:controller => "sale_items", :action => "index", :shop_id => "13")
    end

    it "recognizes and generates #new" do
      { :get => "/shops/13/sale_items/new" }.should route_to(:controller => "sale_items", :action => "new", :shop_id => "13")
    end

    it "recognizes and generates #show" do
      { :get => "/shops/13/sale_items/1" }.should route_to(:controller => "sale_items", :action => "show", :id => "1", :shop_id => "13")
    end

    it "recognizes and generates #edit" do
      { :get => "/shops/13/sale_items/1/edit" }.should route_to(:controller => "sale_items", :action => "edit", :id => "1", :shop_id => "13")
    end

    it "recognizes and generates #create" do
      { :post => "/shops/13/sale_items" }.should route_to(:controller => "sale_items", :action => "create", :shop_id => "13")
    end

    it "recognizes and generates #update" do
      { :put => "/shops/13/sale_items/1" }.should route_to(:controller => "sale_items", :action => "update", :id => "1", :shop_id => "13")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/shops/13/sale_items/1" }.should route_to(:controller => "sale_items", :action => "destroy", :id => "1", :shop_id => "13")
    end

  end
end
