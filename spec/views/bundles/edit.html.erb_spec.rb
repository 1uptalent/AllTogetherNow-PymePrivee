require 'spec_helper'

describe "bundles/edit.html.erb" do
  before(:each) do
    @shop = assign(:shop, stub_model(Shop))
    @bundle = assign(:bundle, stub_model(Bundle,
      :name => "MyString",
      :description => "MyText",
      :total_cost => "9.99",
      :price => "9.99"
    ))
  end

  it "renders the edit bundle form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => shop_bundles_path(@shop, @bundle), :method => "post" do
      assert_select "input#bundle_name", :name => "bundle[name]"
      assert_select "textarea#bundle_description", :name => "bundle[description]"
      assert_select "input#bundle_price", :name => "bundle[price]"
    end
  end
end
