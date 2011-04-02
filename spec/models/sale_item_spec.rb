require 'spec_helper'

describe SaleItem do
  it { should belong_to :shop }
  it { should validate_presence_of :shop }
  it { should have_many :products }
end
