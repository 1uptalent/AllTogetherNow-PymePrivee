require 'spec_helper'

describe SaleItem do
  it { should belong_to :shop }
  it { should validate_presence_of :shop }
  it { should have_many :products }
  it { should have_db_column :valid_from }
  it { should have_db_column :valid_until }
  
  context "#current" do
    let(:shop)     { mock_model(Shop)}
    let!(:previous) { SaleItem.create!(:shop => shop, :valid_from => 10.days.ago, :valid_until => Date.today) }
    let!(:current)  { SaleItem.create!(:shop => shop, :valid_from => Date.today, :valid_until => 1.day.from_now) }
    let!(:next)  { SaleItem.create!(:shop => shop, :valid_from => 1.day.from_now, :valid_until => 10.days.from_now) }
    
    it "should return only the currently enabled item" do
      SaleItem.current.should == current
    end
  end
end
