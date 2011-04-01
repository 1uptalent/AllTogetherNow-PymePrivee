require "spec_helper"

describe "Home-related routes" do
  context "GET index" do
    it "should route to HomeController#index" do
      { :get => root_path }.should 
        route_to(:controller => "home", :action => "index")
    end
  end
end