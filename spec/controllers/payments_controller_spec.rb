require 'spec_helper'

def new_payment(opts = {})
  Payment.create(opts)
end

describe PaymentsController do

  context "when not authenticated" do
    it "GET :confirm requires the user to sign in" do
      get :confirm, :id => 1
      response.should redirect_to(new_user_session_url)
    end
    it "POST :complete requires the user to sign in" do
      post :complete, :id => 1
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "when authenticated" do
    let(:user) { new_user.tap {|u| u.save! }}
    
    before(:each) { sign_in user }
    
    context "without the :token parameter" do
      context "GET :confirm" do
        before(:each) { get :confirm, :id => 1 }
        it { should redirect_to(root_url)}
        it "should set an alert on the flash" do
          flash[:alert].should_not be_blank
        end
      end
      
      context "POST :complete" do
        before(:each) { post :complete, :id => 1 }
        it "should set an alert on the flash" do
          flash[:alert].should_not be_blank
        end
      end
    end

    context "and with the :token parameter" do
      let(:payment) { new_payment(:amount => "12.34").tap{|p| p.save! } }
      
      before(:each) do
        controller.stub(:gateway).and_return(double("gateway"))
      end
      
      context "GET :confirm" do
        context "when the details can be accessed" do    
          before(:each) do
            # Mock the payment gateway
            details = double("details").as_null_object
            details.should_receive(:success?).and_return(true)
            controller.gateway.stub(:details_for).and_return(details)
            
            get :confirm, :id => payment.id, :token => "some value"
          end
          
          it { should render_template :confirm }
          
          it "should change the payment status to 'confirmation_pending'" do
            payment.reload.status.should == "confirmation_pending"
          end
        end
        
        context "when the details can NOT be accessed" do
          before(:each) do
            # Mock the payment gateway
            details = double("details").as_null_object
            details.should_receive(:success?).and_return(false)
            controller.gateway.stub(:details_for).and_return(details)
            
            get :confirm, :id => payment.id, :token => "some value"
          end
          it { should render_template :error }
          
          it "should change the payment status to 'confirmation_error'" do
            payment.reload.status.should == "confirmation_error"
          end
        end
      end
      
      context "POST :complete" do
        context "while waiting for confirmation from the user" do
          
          before(:each) { payment.status = "confirmation_pending" and payment.save! }
        
          context "with a successful transaction" do
            before(:each) do
              # Mock the payment gateway
              purchase = double("purchase").as_null_object
              purchase.should_receive(:success?).and_return(true)
              controller.gateway.should_receive(:purchase).with(1234, anything).and_return(purchase)
            
              post :complete, :id => payment.id, :token => "some value"
            end
          
            it { should render_template :complete }
          
            it "should change the payment status to 'user_confirmed'" do
              payment.reload.status.should == "user_confirmed"
            end
          end
        
          context "with a failed transaction" do
            before(:each) do
              # Mock the payment gateway
              purchase = double("purchase").as_null_object
              purchase.should_receive(:success?).and_return(false)
              controller.gateway.should_receive(:purchase).with(1234, anything).and_return(purchase)
            
              post :complete, :id => payment.id, :token => "some value"
            end
          
            it { should render_template :error }
          
            it "should change the payment status to 'completion_error'" do
              payment.reload.status.should == "completion_error"
            end
          end
        end
      end
    end
  end
end
