class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate params[:session][:password]
      log_in user
      params[:session][:remember_me] == Settings.boolean.true ? remember(user) : forget(user)
      flash[:success] = t ".login_successfully"
      redirect_back_or user
    else
      flash.now[:danger] = t ".invalid_credentials"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
