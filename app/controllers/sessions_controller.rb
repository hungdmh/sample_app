class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate params[:session][:password]
      check_activate user
    else
      flash.now[:danger] = t ".invalid_credentials"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def check_activate user
    remember_me = params[:session][:remember_me]
    if user.activated?
      log_in user
      remember_me == Settings.boolean.true ? remember(user) : forget(user)
      flash[:success] = t ".login_successfully"
      redirect_back_or user
    else
      flash[:warning] = t ".please_activate"
      redirect_to root_url
    end
  end
end
