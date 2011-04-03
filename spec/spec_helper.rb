# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  
  # Render all views by default
  # config.render_views
end

@@user_count = 0
def new_user(opts = {})
  @@user_count += 1
  User.create!({:email => "user#{@@user_count}@foo.bar", 
                :password => "pass123", :password_confirmation => "pass123"}.merge(opts))
end
User.delete_all # ensure we start with no users

@@shop_count = 0
def new_shop(opts = {})
  @@shop_count += 1
  Shop.new( { :user => new_user, :name => "Shop #{@@shop_count}"}.merge(opts))
end
def create_shop(opts = {})
  s = new_shop(opts) and s.save! and s
end

@@sale_item_count = 0
def new_sale_item(args = {})
  @@sale_item_count += 1
  SaleItem.new(
    { :name => "Item #{@@sale_item_count}", 
      :description => "Description for #{@@sale_item_count}",
      :shop => create_shop, 
      :valid_from => 10.days.ago, :valid_until => Date.today }.merge args)
end
def create_sale_item(opts = {})
  s = new_sale_item(opts)
  s.save!
  s
end

@@payment_count = 0
def new_payment(opts = {})
  @@payment_count += 1
  Payment.new({:sale_item => create_sale_item, 
               :amount => 50.01,
               :concept => "Payment for reason #{@@payment_count}" }.merge opts)
  
end
def create_payment(opts = {})
  s = new_payment(opts) and s.save! and s
end