require "spec_helper"

describe BundlesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/shops/13/bundles" }.should route_to(:controller => "bundles", :action => "index", :shop_id => "13")
    end

    it "recognizes and generates #new" do
      { :get => "/shops/13/bundles/new" }.should route_to(:controller => "bundles", :action => "new", :shop_id => "13")
    end

    it "recognizes and generates #show" do
      { :get => "/shops/13/bundles/1" }.should route_to(:controller => "bundles", :action => "show", :id => "1", :shop_id => "13")
    end

    it "recognizes and generates #edit" do
      { :get => "/shops/13/bundles/1/edit" }.should route_to(:controller => "bundles", :action => "edit", :id => "1", :shop_id => "13")
    end

    it "recognizes and generates #create" do
      { :post => "/shops/13/bundles" }.should route_to(:controller => "bundles", :action => "create", :shop_id => "13")
    end

    it "recognizes and generates #update" do
      { :put => "/shops/13/bundles/1" }.should route_to(:controller => "bundles", :action => "update", :id => "1", :shop_id => "13")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/shops/13/bundles/1" }.should route_to(:controller => "bundles", :action => "destroy", :id => "1", :shop_id => "13")
    end
    
    it "recognizes and generates #current" do
      { :get => "/shops/13/bundles/current" }.should route_to(:controller => "bundles", :action => "current", :shop_id => "13")
    end

    it "recognizes and generates #buy" do
      { :get => "/shops/13/bundles/3/buy" }.should route_to(:controller => "bundles", :action => "buy", :shop_id => "13", :id => "3")
    end
  end
end
