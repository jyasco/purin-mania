class Mypage::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @posts = current_user.posts.includes(:user).order(created_at: :desc).page(params[:page])
  end
end