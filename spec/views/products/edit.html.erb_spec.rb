require 'spec_helper'

describe "products/edit.html.erb" do
  before(:each) do
    @shop = assign(:shop, stub_model(Shop, :id => 3) )
    @product = assign(:product, stub_model(Product,
      :name => "MyString",
      :description => "MyString",
      :cost => 10.99,
      :tax => 0.18
    ))
  end

  it "renders the edit product form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => shop_products_path(@shop, @product), :method => "post" do
      assert_select "input#product_name", :name => "product[name]"
      assert_select "input#product_description", :name => "product[description]"
      assert_select "input#product_cost", :name => "product[cost]"
      assert_select "input#product_tax", :name => "product[tax]"
    end
  end
end
