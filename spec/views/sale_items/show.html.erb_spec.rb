require 'spec_helper'

describe "sale_items/show.html.erb" do
  before(:each) do
    @shop = assign(:shop, stub_model(Shop))
    @sale_item = assign(:sale_item, stub_model(SaleItem,
      :name => "Name",
      :description => "MyText",
      :total_cost => "9.99",
      :price => "12.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/9.99/)
    rendered.should match(/12.99/)
  end
end
