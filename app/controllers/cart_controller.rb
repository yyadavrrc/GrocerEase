class CartController < ApplicationController
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
    @total_price = calculate_total_price(session[:cart])
    @total_price_with_tax = calculate_total_price_with_tax(session[:cart])
  end

  private

  def calculate_total_price(cart)
    total_price = 0
    cart.each do |product_id, quantity|
      product = Product.find(product_id)
      total_price += product.price * quantity
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
end
