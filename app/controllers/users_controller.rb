class UsersController < ApplicationController

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "welcome"
      log_in @user
      redirect_to @user
    else
      flash[:danger] = t "users.create.error"
      redirect_to signup_path
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".user_not_found"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end
end
