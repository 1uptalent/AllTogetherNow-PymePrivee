class HomeController < ApplicationController
  def index
    @shops = Shop.order("created_at desc").limit(10)
    @products = Product.order("created_at desc").limit(10)
  end

end
