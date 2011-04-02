require 'spec_helper'

describe "sale_items/edit.html.erb" do
  before(:each) do
    @sale_item = assign(:sale_item, stub_model(SaleItem,
      :name => "MyString",
      :description => "MyText",
      :total_cost => "9.99",
      :price => "9.99"
    ))
  end

  it "renders the edit sale_item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sale_items_path(@sale_item), :method => "post" do
      assert_select "input#sale_item_name", :name => "sale_item[name]"
      assert_select "textarea#sale_item_description", :name => "sale_item[description]"
      assert_select "input#sale_item_total_cost", :name => "sale_item[total_cost]"
      assert_select "input#sale_item_price", :name => "sale_item[price]"
    end
  end
end
