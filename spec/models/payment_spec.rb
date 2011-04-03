require 'spec_helper'

@@user_count = 0
def new_user(opts = {})
  @@user_count += 1
  User.new({:email => "user#{@@user_count}@foo.bar", 
            :password => "pass123", :password_confirmation => "pass123"}.merge(opts))
end
User.delete_all # ensure we start with no users

@@shop_count = 0
def new_shop(opts = {})
  @@shop_count += 1
  Shop.new( { :user => new_user, :name => "Shop #{@@shop_count}"}.merge(opts))
end

@@item_count = 0
def new_sale_item(opts = {})
  SaleItem.create({ :shop => new_shop, :valid_from => Date.today, :valid_until => Date.tomorrow }.merge opts)
end

@@payment_count = 0
def new_payment(opts = {})
  @@payment_count += 1
  merged_opts = {:sale_item => new_sale_item, 
                 :amount => 50.01,
                 :concept => "Payment for reason #{@@payment_count}" }.merge(opts)
  Payment.new(merged_opts)
end

describe Payment do
  it { should have_db_column :concept }
  it { should belong_to :sale_item }
  it { should validate_presence_of :amount }
  it { should validate_presence_of :status }
  # sale_item might be optional for suscription payments
  
  it "with saved records, it should default to 'user_requested' status" do
    sale_item = new_sale_item and sale_item.save!
    
    p = Payment.create(:sale_item => sale_item,
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
