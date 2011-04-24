require 'spec_helper'

describe "bundles/show.html.erb" do
  before(:each) do
    @shop = assign(:shop, stub_model(Shop))
    @bundle = assign(:bundle, stub_model(Bundle,
      :name => "Name",
      :description => "MyText",
      :total_cost => "9.99",
      :price => "12.99",
      :valid_from => "2009-01-01".to_date,
      :valid_until => Date.tomorrow,
      :image => mock(Paperclip::Attachment, :url => "")
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/12.99/)
  end
  
  context "with products" do
    before do
      products = [mock_model(Product, :name => 'Jam', :description => "Banana", :picture => mock(Paperclip::Attachment, :url => ""))]
      @bundle.stub(:products).and_return(products)
    end
    
    it "should display them" do
      render
      rendered.should match(/Jam/) 
    end
  end
  
  context "when not current" do
    before do
      @bundle.stub(:valid_until).and_return(Date.today)
      @bundle.stub(:image).and_return(mock(Paperclip::Attachment, :url => ""))
    end
    
    it "should render a warning" do
      render
      assert_select "div[class=not_current]", :count => 1
    end
    
    it "should not render the buy button" do
      render
      assert_select "a[href=?]", %r{.*/buy}, :count => 0
    end
  end
  
  context "with the shop owner's sale item" do
    it "should display a add product link" do
      render
      assert_select "a[href=?]", add_product_to_bundle_path(@bundle)
    end
  end
end
