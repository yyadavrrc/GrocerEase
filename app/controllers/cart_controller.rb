class CartController < ApplicationController
  before_action :authenticate_user!
  def add_to_cart
    session[:cart] ||= {}
    product_id = params[:product_id]
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += 1
    redirect_to view_cart_path, notice: 'Product added to cart successfully'
  end

  def remove_from_cart
    product_id = params[:id]
    session[:cart].delete(product_id)
    redirect_to view_cart_path, notice: 'Product removed from cart successfully'
  end

  def update_cart
    product_id = params[:product_id]
    quantity = params[:quantity][product_id].to_i
    session[:cart][product_id] = quantity if session[:cart][product_id].present?
    redirect_to view_cart_path, notice: 'Cart updated successfully'
  end

  def view_cart
    @total_price = calculate_total_price(session[:cart])
  end

  def checkout
    total_price = 0

    # Calculate total price and prepare cart hash
    session[:cart].each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product
        price = product.price
        total_price += price * quantity
      else
        flash[:error] = "Product with ID #{product_id} not found."
        redirect_to root_path and return
      end
    end

    # Calculate taxes
    province = Province.find_by(id: current_user.province_id)
    if province
      gst = total_price * (province.gst / 100)
      pst = total_price * (province.pst / 100)
      hst = total_price * (province.hst / 100)
    else
      flash[:error] = "Province not found for the current user."
      redirect_to root_path and return
    end

    # Calculate total price including taxes
    total_with_taxes = total_price + gst + pst + hst

    # Create new order record
    order = Invoice.create(
      customer_id: current_user.id,
      total_amount: total_with_taxes,
    )

    # Save the order
    if order.save
      session.delete(:cart)
      redirect_to account_path
    else
      flash[:error] = "Failed to save order."
      @error = flash[:error]
    end
  end


  private

  def calculate_total_price(cart)
    total_price = 0
    if cart.present?
      cart.each do |product_id, quantity|
        product = Product.find(product_id)
        total_price += product.price * quantity
      end
    end
    total_price
  end


  def get_tax_rate_for_province(province)
    # Define tax rates for each province
    tax_rates = {
      "Alberta" => { gst: 0.05 }, # GST only
      "British Columbia" => { gst: 0.05, pst: 0.07 }, # GST and PST
      "Manitoba" => { gst: 0.05, pst: 0.07 }, # GST and PST
      "New Brunswick" => { gst: 0.05, pst: 0.10 }, # GST and HST
      "Newfoundland and Labrador" => { gst: 0.05, pst: 0.10 }, # GST and HST
      "Northwest Territories" => { gst: 0.05 }, # GST only
      "Nova Scotia" => { gst: 0.05, pst: 0.10 }, # GST and HST
      "Nunavut" => { gst: 0.05 }, # GST only
      "Ontario" => { gst: 0.05, pst: 0.08 }, # GST and PST
      "Prince Edward Island" => { gst: 0.05, pst: 0.10 }, # GST and HST
      "Quebec" => { gst: 0.05, qst: 0.09975 }, # GST and QST
      "Saskatchewan" => { gst: 0.05, pst: 0.06 }, # GST and PST
      "Yukon" => { gst: 0.05 } # GST only
    }

    # Retrieve the tax rate for the selected province
    tax_rates[province] || { gst: 0, pst: 0, qst: 0 } # Return default tax rates if province not found
  end

  def calculate_total_price_with_tax(cart)
    total_price = calculate_total_price(cart)
    province = params[:province] # Retrieve province from params (assumed to be passed during checkout)
    tax_rates = get_tax_rate_for_province(province)

    # Calculate total price with applicable taxes
    total_price_with_tax = total_price * (1 + tax_rates.values.sum)
    total_price_with_tax
  end

  def calculate_total_price_with_tax(cart)
    total_price = calculate_total_price(cart)
    province = params[:province] # Retrieve province from params (assumed to be passed during checkout)
    tax_rates = get_tax_rate_for_province(province)

    gst = total_price * tax_rates[:gst]
    pst = total_price * tax_rates[:pst].to_f
    hst = total_price * tax_rates[:hst].to_f

    total_price_with_tax = total_price + gst + pst + hst
    { total_price_with_tax: total_price_with_tax, gst: gst, pst: pst, hst: hst }
  end

end
