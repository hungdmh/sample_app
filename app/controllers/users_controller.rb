class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(create new show)
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    page = params[:page]
    @users = User.is_activated.page(page).per Settings.pagination.per_page
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "user_mailer.please_activate"
      redirect_to root_url
    else
      flash[:danger] = t "users.create.error"
      redirect_to signup_path
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = find_user_by_id params[:id]
    page = params[:page]
    @microposts = @user.microposts.page(page).per Settings.pagination.per_page
    return if @user&.activated
  end

  def edit
    @user = find_user_by_id params[:id]
  end

  def update
    @user = find_user_by_id params[:id]

    if @user.update user_params
      flash[:success] = t "users.edit.success"
      log_in @user
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def correct_user
    @user = find_user_by_id params[:id]
    redirect_to(root_url) unless current_user? @user
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t "users.destroy.success"
    redirect_to users_url
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def find_user_by_id id
    user = User.find_by id: id
    return user if user

    flash[:danger] = t ".user_not_found"
    redirect_to root_path
  end
end
