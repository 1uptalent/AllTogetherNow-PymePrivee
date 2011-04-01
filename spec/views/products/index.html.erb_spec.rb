require 'spec_helper'

describe "products/index.html.erb" do
  before(:each) do
    assign(:shop, stub_model(Shop))
    assign(:products, [
      stub_model(Product,
        :name => "Name",
        :description => "Description",
        :cost => 9.99,
        :tax => 0.18
      ),
      stub_model(Product,
        :name => "Name",
        :description => "Description",
        :cost => 9.99,
        :tax => 0.18
      )
    ])
  end

  it "renders a list of products" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "0.18".to_s, :count => 2
  end
end
