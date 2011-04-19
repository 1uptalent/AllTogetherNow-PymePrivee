require 'spec_helper'

describe Payment do
  it { should have_db_column :concept }
  it { should belong_to :bundle }
  it { should validate_presence_of :amount }
  it { should validate_presence_of :status }
  # bundle might be optional for suscription payments
  
  it "with saved records, it should default to 'user_requested' status" do
    bundle = new_bundle and bundle.save!
    
    p = Payment.create(:bundle => bundle,
                       :amount => 12.34, :concept => "some reason")
    p.save!
    p.status.should == "user_requested"
  end
  
  context "should return the active merchant ammount" do
    def payment_for_amount(amount)
      Payment.new(:amount => amount).activemerchant_amount
    end
    it("for 12.34") { payment_for_amount("12.34").should == 1234 }
    it("for 12.341") { payment_for_amount("12.341").should == 1234 }
    it("for 12") { payment_for_amount("12").should == 1200 }
    it("for 0.1") { payment_for_amount("0.1").should == 10 }
  end
  
  context "with several payments with different states" do
    before(:all) do
      Payment.delete_all
      Payment::VALID_STATUSES.each do |status|
        new_payment(:status => status).save!
      end
    end
    
    Payment::VALID_STATUSES.each do |status|
      it "should find one record with the status '#{status}'" do
        Payment.send(status).count.should == 1
      end
    end
  end
end
