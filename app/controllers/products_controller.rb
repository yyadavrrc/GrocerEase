class ProductsController < ApplicationController
  def index
    @product = Product.page(params[:page]).per(10)
  end

  def show
    @product = Product.find(params[:id])
  end

  def cart
  end

  def cart_remove
  end
end
