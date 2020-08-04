class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    token = params[:id]

    if user&.activated? == false && user.authenticated?(:activation, token)
      user.activate
      log_in user
      flash[:success] = t ".activated"
      redirect_to user
    else
      flash[:danger] = t ".invalid_activation_link"
      redirect_to root_url
    end
  end
end
