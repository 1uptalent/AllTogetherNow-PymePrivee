class PaymentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_gateway_token_is_provided!
  
  include ActiveMerchant::Billing
  
  def confirm
    # TODO: log attempts to confirm a non-existant payment
    @payment = Payment.find(params[:id])
    # TODO: log attempts to confirm a non-existant payment
    details_response = gateway.details_for(params[:token])

    if !details_response.success?
      @message = details_response.message
      @payment.update_attributes!(status: "confirmation_error")
      render :action => 'error'
      return
    end

    @payment.update_attributes!(status: "confirmation_pending")
    @address = details_response.address
  end
  
  def complete
    # TODO: log attempts to complete a non-existant payment
    @payment = Payment.find(params[:id])
    purchase = gateway.purchase(@payment.activemerchant_amount,
      :ip       => request.remote_ip,
      :payer_id => params[:payer_id],
      :token    => params[:token]
    )

    if !purchase.success?
      @message = purchase.message
      if @payment.status == "confirmation_pending"
        # avoid overwriting the previous status if this is a reload
        @payment.update_attributes!(status: "completion_error")
      end
      render :action => 'error'
      return
    end
    @payment.update_attributes!(status: "user_confirmed")
  end
  
  protected
  
  def verify_gateway_token_is_provided!
    unless params[:token] 
      flash[:alert] = "Missing required parameters from the payment gateway."
      # TODO: Log the event, looks like someone is trying to trick us
      redirect_to root_url
    end
  end
  
end
