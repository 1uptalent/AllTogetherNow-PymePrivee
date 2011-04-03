require 'spec_helper'

@@sale_item_count = 0
def create_sale_item(args = {})
  @@sale_item_count += 1
  SaleItem.create!(
    { :name => "Item #{@@sale_item_count}", 
      :description => "Description for #{@@sale_item_count}",
      :shop => shop, 
      :valid_from => 10.days.ago, :valid_until => Date.today }.merge args)
end

describe SaleItem do
  it { should belong_to :shop }
  it { should validate_presence_of :shop }
  it { should validate_presence_of :name }
  it { should validate_presence_of :description }
  it { should validate_presence_of :price }
  it { should validate_presence_of :valid_from }
  it { should validate_presence_of :valid_until }
  it { should have_many :products }
  it { should have_db_column :valid_from }
  it { should have_db_column :valid_until }
  
  context "#current" do
    let(:shop)     { mock_model(Shop)}
    let!(:previous) { SaleItem.create!(:shop => shop, :valid_from => 10.days.ago, :valid_until => Date.today) }
    let!(:current)  { SaleItem.create!(:shop => shop, :valid_from => Date.today, :valid_until => 2.day.from_now.to_date) }
    let!(:future)  { SaleItem.create!(:shop => shop, :valid_from => 2.day.from_now, :valid_until => 10.days.from_now.to_date) }
    
    before(:all) {SaleItem.delete_all}
    
    
    it "should return only the currently enabled item" do
      SaleItem.current.should == current
    end
  end
  
  context "#current?" do
    let(:shop)     { mock_model(Shop)}
    let!(:previous) { SaleItem.create!(:shop => shop, :valid_from => 10.days.ago, :valid_until => Date.today) }
    let!(:current)  { SaleItem.create!(:shop => shop, :valid_from => Date.today, :valid_until => 2.day.from_now) }
    let!(:future)  { SaleItem.create!(:shop => shop, :valid_from => 2.day.from_now, :valid_until => 10.days.from_now) }
    
    it "should return false for past items" do
      previous.should_not be_current
    end
    it "should return false for future items" do
      future.should_not be_current
    end
    it "should return true for current items" do
      current.should be_current
    end
  end
end
