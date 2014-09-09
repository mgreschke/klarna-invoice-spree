module Spree
  Order.class_eval do
    # preference :gender, :integer
    # preference :p_no, :string
    # p "loaded"
    alias_method :available_payment_methods_orig, :available_payment_methods

    def available_payment_methods
      available_payment_methods_orig.reject{|p| p.is_a?(Spree::Gateway::KlarnaInvoice) && !Spree::Gateway::KlarnaInvoice.available_countries.include?(billing_address.country.iso)}
    end

  end
end
