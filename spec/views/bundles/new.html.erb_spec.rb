require 'spec_helper'

describe "bundles/new.html.erb" do
  let(:shop) { mock_model(Shop) }
  
  before(:each) do
    assign(:shop, shop)
    assign(:bundle, stub_model(Bundle,
      :name => "MyString",
      :description => "MyText",
      :total_cost => "9.99",
      :price => "9.99"
    ).as_new_record)
  end

  it "renders new bundle form" do
    render

    assert_select "form", :action => shop_bundles_path(shop), :method => "post" do
      assert_select "input#bundle_name", :name => "bundle[name]"
      assert_select "input#bundle_valid_from", :name => "bundle[valid_from]"
      assert_select "input#bundle_valid_until", :name => "bundle[valid_intil]"
      assert_select "textarea#bundle_description", :name => "bundle[description]"
    end
  end
end
