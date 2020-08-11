class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  before_action :new_micropost, only: :create

  def create
    @micropost.image.attach params[:micropost][:image]

    if @micropost.save
      flash[:success] = t ".success"
      redirect_to root_url
    else
      @feed_items = feed_items
      flash.now[:danger] = t ".fail"
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = t ".success"
    redirect_to request.referer || root_url
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url if @micropost.nil?
  end

  def new_micropost
    @micropost = current_user.microposts.build micropost_params
  end

  def feed_items
    per_page = Settings.pagination.per_page
    current_user.feed.date_desc_posts.page params[:page].per per_page
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end
end
