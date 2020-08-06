class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t ".sending_error"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, :blank
      render :edit
    elsif @user.update user_params.merge reset_digest: nil
      log_in @user
      flash[:success] = t ".reset_password_success"
      redirect_to @user
    else
      flash.now[:danger] = t ".reset_password_success"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_resets.update.expired"
    redirect_to new_password_reset_url
  end
end
