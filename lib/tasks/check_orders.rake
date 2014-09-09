namespace :klarna do
  desc "check klarna orders"
  task :check => :environment do

    Spree::PaymentMethod.where(type: 'Spree::Gateway::KlarnaInvoice', active: true).each do |gateway|
      gateway.payments.where(state: :pending).where("updated_at < ?", Time.now - 4.hours).find_each do |payment|
        payment.touch
        gateway.check_order_status(payment)
      end
    end

  end
end
