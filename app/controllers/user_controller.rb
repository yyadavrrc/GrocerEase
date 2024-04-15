class UserController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(current_user.id)
    @orders = Invoice.where(customer_id: current_user.id)
  end

  def sign_out
    reset_session
    redirect_to '/', notice: 'Customer information updated successfully.'
  end

  def update
    @customer = User.find(params[:id])

    if @customer.update(customer_params)
      # Update successful, handle accordingly (e.g., redirect to another page)
      redirect_to '/account', notice: 'Customer information updated successfully.'
    else
      # Update failed, render the edit page again with error messages
      render :edit
    end
  end

  private

  def customer_params
    params.require(:user).permit(:email, :address, :province_id, :image)
  end
end
