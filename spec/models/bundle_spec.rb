require 'spec_helper'

describe Bundle do
  it { should belong_to :shop }
  it { should validate_presence_of :shop }
  it { should validate_presence_of :name }
  it { should validate_presence_of :description }
  it { should validate_presence_of :price }
  it { should validate_presence_of :valid_from }
  it { should validate_presence_of :valid_until }
  it { should have_many :bundle_products }
  it { should have_many(:products).through(:bundle_products) }
  it { should have_db_column :valid_from }
  it { should have_db_column :valid_until }
  
  context "#current" do
    let(:shop)     { mock_model(Shop)}
    let!(:previous) { create_bundle(:shop => shop, :valid_from => 10.days.ago, :valid_until => Date.today) }
    let!(:current)  { create_bundle(:shop => shop, :valid_from => Date.today, :valid_until => 2.day.from_now) }
    let!(:future)  { create_bundle(:shop => shop, :valid_from => 2.day.from_now, :valid_until => 10.days.from_now) }
    
    it "should return only the currently enabled item" do
      Bundle.current.should == current
    end
  end
  
  context "#current?" do
    let(:shop)     { mock_model(Shop)}
    let!(:previous) { create_bundle(:shop => shop, :valid_from => 10.days.ago, :valid_until => Date.today) }
    let!(:current)  { create_bundle(:shop => shop, :valid_from => Date.today, :valid_until => 2.day.from_now) }
    let!(:future)  { create_bundle(:shop => shop, :valid_from => 2.day.from_now, :valid_until => 10.days.from_now) }
    
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
