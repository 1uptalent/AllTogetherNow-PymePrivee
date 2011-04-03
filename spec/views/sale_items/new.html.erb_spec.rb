require 'spec_helper'

describe "sale_items/new.html.erb" do
  let(:shop) { mock_model(Shop) }
  
  before(:each) do
    assign(:shop, shop)
    assign(:sale_item, stub_model(SaleItem,
      :name => "MyString",
      :description => "MyText",
      :total_cost => "9.99",
      :price => "9.99"
    ).as_new_record)
  end

  it "renders new sale_item form" do
    render

    assert_select "form", :action => shop_sale_items_path(shop), :method => "post" do
      assert_select "input#sale_item_name", :name => "sale_item[name]"
      assert_select "input#sale_item_valid_from", :name => "sale_item[valid_from]"
      assert_select "input#sale_item_valid_until", :name => "sale_item[valid_intil]"
      assert_select "textarea#sale_item_description", :name => "sale_item[description]"
    end
  end
end
