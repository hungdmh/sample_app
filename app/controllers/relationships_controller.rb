class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    user = User.find_by id: params[:followed_id]
    return unless user

    current_user.follow user
    ajax_response
  end

  def destroy
    user = Relationship.find_by id: params[:id].followed
    return unless user

    current_user.unfollow user
    ajax_response
  end

  def ajax_response
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end
end
