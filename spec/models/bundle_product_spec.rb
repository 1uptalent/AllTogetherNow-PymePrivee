require 'spec_helper'

describe BundleProduct do
  it { should belong_to :bundle  }
  it { should belong_to :product }
  
  it { should validate_presence_of :bundle }
  it { should validate_presence_of :product }
end
