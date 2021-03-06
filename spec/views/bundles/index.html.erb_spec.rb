require 'spec_helper'

describe "bundles/index.html.erb" do
  before(:each) do
    assign(:shop, mock_model(Shop))
    assign(:bundles, [
      stub_model(Bundle,
        :name => "Name",
        :description => "MyText",
        :total_cost => "9.99",
        :price => "12.99"
      ),
      stub_model(Bundle,
        :name => "Name",
        :description => "MyText",
        :total_cost => "9.99",
        :price => "12.99"
      )
    ])
  end

  it "renders a list of bundles" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "12.99".to_s, :count => 2
  end
end
