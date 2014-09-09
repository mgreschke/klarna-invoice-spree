module Spree
  Payment.class_eval do
    alias_method :process_orig, :process!
    def process!
      if payment_method.is_a? Spree::Gateway::KlarnaInvoice
        payment_method.process!(order,self)
        reload
        p completed?
      else
        process_orig
      end
    end
  end
end
