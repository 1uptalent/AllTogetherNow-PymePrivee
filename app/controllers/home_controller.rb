class HomeController < ApplicationController
  def index
    @shops = Shop.order("created_at desc").limit(10)
    @sales = Bundle.order("created_at desc").limit(10)
  end

end
