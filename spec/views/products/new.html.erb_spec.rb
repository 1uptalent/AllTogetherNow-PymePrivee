require 'spec_helper'

describe "products/new.html.erb" do
  before(:each) do
    @shop = assign(:shop, stub_model(Shop, :id => 3) )
    assign(:product, stub_model(Product,
      :name => "MyString",
      :description => "MyString",
      :cost => 7.07,
      :tax => 0.04
    ).as_new_record)
  end

  it "renders new product form" do
    render

    assert_select "form", :action => shop_products_path(@shop), :method => "post" do
      assert_select "input#product_name", :name => "product[name]"
      assert_select "input#product_description", :name => "product[description]"
      assert_select "input#product_cost", :name => "product[cost]"
      assert_select "input#product_tax", :name => "product[tax]"
    end
  end
end
