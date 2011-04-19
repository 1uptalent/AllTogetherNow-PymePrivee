require 'spec_helper'

describe Shop do
  it "should have an owner" do
    should belong_to :user
  end
  it { should validate_presence_of :user }
  it { should validate_presence_of :name }
  it { should have_many :products }
  it { should have_many :bundles }
end
