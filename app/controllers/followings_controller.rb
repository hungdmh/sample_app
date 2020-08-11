class FollowingsController < ApplicationController
  before_action :logged_in_user

  def index
    @title = t "users.following.title"
    @user = User.find_by id: params[:id]
    return unless @user

    @users = @user.following.page params[:page]
    render "users/show_follow"
  end
end
