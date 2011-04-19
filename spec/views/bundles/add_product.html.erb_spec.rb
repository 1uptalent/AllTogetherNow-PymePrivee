require 'spec_helper'

describe "bundles/add_product.html.erb" do
  before do
    @products = assign(:products, [mock_model(Product, :name => 'Jam'),       mock_model(Product, :name => 'Cheese')])
    @bundle = assign(:bundle, mock_model(Bundle, :products => [], :product_ids => [], :shop => mock_model(Shop)))
    render
  end

  it "should submit via post to update_products_for_bundle" do
    assert_select "form[action=?][method=post]", update_products_for_bundle_path(@bundle)
  end

  it 'renders the avaliable products in a select' do
    assert_select "input[type=checkbox]", :count => 2
    rendered.should match /Jam/
    rendered.should match /Cheese/
  end

  it 'renders a submit button' do
    assert_select "input[type=submit]", :count => 1
  end    
  
  context "with previous selection" do
    before do
      @bundle.stub(:products).and_return(@products)
      @bundle.stub(:product_ids).and_return(@products.collect(&:id))
      render
    end

    it 'renders the avaliable products in a select' do
      assert_select "input[type=checkbox][checked]", :count => 2
    end
  end
end