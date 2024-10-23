class Mypage::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @posts = current_user.posts.includes(:user).order(created_at: :desc)
  end
end