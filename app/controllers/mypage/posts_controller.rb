class Mypage::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.posts.includes(:user).order(created_at: :desc)
  end
end