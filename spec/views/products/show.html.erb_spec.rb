require 'spec_helper'

describe "products/show.html.erb" do
  before(:each) do
    @shop    = assign(:shop,    stub_model(Shop))
    @product = assign(:product, stub_model(Product,
      :name => "Name",
      :description => "Description",
      :cost => 9.09,
      :tax => 0.18
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Name/)
    rendered.should match(/Description/)
    rendered.should match(/Cost/)
    rendered.should match(/Tax/)
  end
end
