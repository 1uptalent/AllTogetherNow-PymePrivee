require 'spec_helper'

describe Product do
  it { should belong_to :shop }
  it { should validate_presence_of :shop }
  it { should have_many :bundle_products }
  it { should have_many(:bundles).through(:bundle_products) }
end
