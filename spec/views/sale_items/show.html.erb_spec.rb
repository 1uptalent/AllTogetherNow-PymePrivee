require 'spec_helper'

describe "sale_items/show.html.erb" do
  before(:each) do
    @sale_item = assign(:sale_item, stub_model(SaleItem,
      :name => "Name",
      :description => "MyText",
      :total_cost => "9.99",
      :price => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
  end
end
