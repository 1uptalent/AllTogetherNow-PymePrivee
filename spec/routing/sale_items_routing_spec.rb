require "spec_helper"

describe SaleItemsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/sale_items" }.should route_to(:controller => "sale_items", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/sale_items/new" }.should route_to(:controller => "sale_items", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/sale_items/1" }.should route_to(:controller => "sale_items", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/sale_items/1/edit" }.should route_to(:controller => "sale_items", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/sale_items" }.should route_to(:controller => "sale_items", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/sale_items/1" }.should route_to(:controller => "sale_items", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/sale_items/1" }.should route_to(:controller => "sale_items", :action => "destroy", :id => "1")
    end

  end
end
