ActiveMerchant::Billing::PaypalExpressGateway.default_currency = "EUR"

module ActiveMerchant
  module Billing
    def gateway
      @gateway ||= PaypalExpressGateway.new(APP_CONFIG.paypal.to_hash.symbolize_keys)
    end
  end
end