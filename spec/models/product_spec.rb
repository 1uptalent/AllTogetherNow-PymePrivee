require 'spec_helper'

describe Product do
  it { should belong_to :shop }
  it { should validate_presence_of :shop }
  xit { should have_many :bundles }
end
