Spree::CheckoutController.class_eval do
  alias_method :update_orig, :update
  def update
    test_mode=true
    billing_address = @order.billing_address
    if params[:order] && params[:order][:payments_attributes] && params[:order][:payments_attributes].first && params[:order][:payments_attributes].first[:payment_method_id] && (gw = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])).is_a?(Spree::Gateway::KlarnaInvoice)
      if !params[:accept_agb] || "1" != params[:accept_agb]
        flash[:error] = Spree.t(:agb_must_be_accepted)
        redirect_to checkout_state_path(@order.state) and return
      end
      if params[:p_no]
        if "" == params[:p_no]
          flash[:error] = Spree.t(:social_no_cannot_be_empty)
          redirect_to checkout_state_path(@order.state) and return
        end
        billing_address.p_no = params[:p_no]
      elsif params[:birthday_d]
        v = params[:birthday_y].to_i*365+params[:birthday_m].to_i*30+params[:birthday_d].to_i
        if v < 1900*365 || v > 2200*365
          flash[:error] = Spree.t(:birthday_wrong_value)
          redirect_to checkout_state_path(@order.state) and return
        end
        billing_address.p_no = sprintf("%02u%02u%04u",params[:birthday_d].to_i,params[:birthday_m].to_i,params[:birthday_y].to_i)
      end
      if gw.gender_required?(@order.bill_address.country.iso)
        if "" == params[:gender] || params[:gender].nil?
          flash[:error] = Spree.t(:gender_cannot_be_empty)
          redirect_to checkout_state_path(@order.state) and return
        end
        billing_address.gender = params[:gender].to_i
      end
      billing_address.save!


    end
    update_orig
  # rescue StandardError=>e
  #   if test_mode
  #     flash[:error] = e.to_s
  #   else
  #     flash[:error] = I18n.t(:klarna_error)
  #   end
  #   redirect_to checkout_state_path(@order.state)
  end
end
